# XIV.C. CI/CD Integration: Observability in Pipelines

## 1. The Concept: "Pipelines as Distributed Systems"

Traditionally, OpenTelemetry is used to monitor applications running in production. However, **CI/CD pipelines are essentially short-lived distributed systems.** They consist of multiple jobs, steps, and services (databases, caches) interacting across different servers or containers.

When a build fails or takes too long, developers typically scroll through thousands of lines of unstructured text logs (console output). CI/CD Integration with OpenTelemetry solves this by generating **Traces** for build executions.

### The Mapping
To apply OTel to CI/CD, we map the concepts as follows:
*   **Trace:** A single execution of a full pipeline (e.g., a GitHub Actions workflow run).
*   **Span:** Individual jobs, steps, or commands (e.g., "Build Docker Image", "Run Unit Tests").
*   **Attributes:** Metadata about the build (Commit SHA, Branch Name, Pull Request ID, Runner OS).
*   **Errors:** Pipeline failures are captured as Span Status `Error` with the exception message attached.

## 2. Layers of Instrumentation

To get a complete picture, instrumentation usually happens at three distinct layers:

### Layer 1: The Orchestrator (GitHub Actions, Jenkins, GitLab CI)
This layer measures the "wrapper." It tells you how long a Job took and the delay between jobs.
*   **How it works:** Hooks into the CI provider's lifecycle events.
*   **What it shows:** Queue time, total duration, final status.

### Layer 2: The Build Tool (Maven, Gradle, npm)
This layer measures the internal logic of the build.
*   **How it works:** Uses plugins/extensions injected into the build tool process.
*   **What it shows:** How long dependency resolution took, how long compilation took, or which specific Maven module is slow.

### Layer 3: The Test Runner (JUnit, PyTest, Jest)
This is "Test Observability."
*   **How it works:** A custom test reporter converts test execution into spans.
*   **What it shows:** Flaky tests, slow tests, and full stack traces for failed tests attached directly to the span.

---

## 3. Implementation Strategies

Here is how you actually implement this using the technologies mentioned in your TOC.

### A. GitHub Actions (GHA) Integration

Since GitHub Actions doesn't support OTel natively (yet), we use a third-party Action or a wrapper.

**The Workflow:**
1.  An Action initializes an OTel Trace at the start of the workflow.
2.  It generates a `traceparent` (W3C standard).
3.  It exports this ID to environment variables (`TRACEPARENT`, `OTEL_EXPORTER_OTLP_ENDPOINT`).
4.  Subsequent steps use this ID to create child spans.

**Example Configuration (using a generic OTel action):**

```yaml
name: CI Pipeline
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # 1. Start the Trace
      - name: Setup OTel
        uses: otel-action/setup@v1
        with:
          endpoint: "api.honeycomb.io:443"
          headers: "x-honeycomb-team=${{ secrets.API_KEY }}"

      # 2. Run your build (Child Span)
      - name: Build Application
        run: ./mvnw clean install
        env:
          # Pass trace context to Maven so it links to the GHA span
          OTEL_TRACES_EXPORTER: otlp 
```

### B. Build Tool Plugins (Maven & Gradle)

Simply running `mvn clean install` inside a traced CI step shows a single block of time. To see *inside* the build, you need the **OpenTelemetry Maven Extension** or **Gradle Plugin**.

**Maven:**
You install the `opentelemetry-maven-extension`. When Maven runs, this extension:
1.  Detects the `TRACEPARENT` environment variable injected by the CI runner.
2.  Creates a child span for every Maven Goal (compile, test, package).
3.  Exports spans to your OTel Collector.

**Gradle:**
Similarly, the OpenTelemetry Gradle Plugin wraps tasks. It is particularly useful for detecting **Cache Misses**. You can look at the trace attributes to see if a task was `UP-TO-DATE` (cache hit) or if it had to run from scratch.

### C. otel-cli (Shell Script Instrumentation)

For custom shell scripts inside a pipeline, you can use `otel-cli`. It allows you to wrap arbitrary commands in spans.

```bash
# In your CI script
export OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317

# Wrap a database migration command in a span
otel-cli exec --name "Run DB Migrations" --service "ci-runner" -- \
  ./migrate-db.sh
```

---

## 4. Semantic Conventions for CI/CD

Just as HTTP spans have standard attributes (`http.method`, `http.status_code`), OpenTelemetry has emerging standards for CI/CD to ensure backends can visualize the data correctly.

**Common Attributes:**
*   `cicd.pipeline.id`: Unique ID of the run.
*   `cicd.pipeline.name`: e.g., "Deploy to Staging".
*   `git.repository_url`: The repo source.
*   `git.commit.sha`: The commit triggering the build.
*   `git.branch.name`: e.g., `main` or `feature/login`.

By attaching the `git.commit.sha` to both the **CI Trace** and the **Application Trace** (via the Docker image tag or app version), you can link the build process directly to production runtime performance.

---

## 5. Use Cases and Benefits

Why go through the trouble of instrumenting pipelines?

### 1. Debugging "Flaky" Tests
*   **Problem:** A test fails 1 out of 10 times.
*   **OTel Solution:** You can query your backend for all spans named `testLogin`. You filter by `status=error`. You compare the attributes of the failed spans vs. successful ones. You might discover that the test only fails when running on a specific `k8s.node.name` or when the database initialization span takes longer than 500ms.

### 2. Optimizing Build Speed
*   **Problem:** The build takes 20 minutes.
*   **OTel Solution:** A Waterfall Trace view immediately highlights the longest bar. You might see that `npm install` is taking 8 minutes because the caching layer isn't working (visible via attributes), or that two tests are running sequentially when they could run in parallel.

### 3. Cost Reduction
*   **Problem:** GitHub Actions/CircleCI bills by the minute.
*   **OTel Solution:** By identifying and fixing inefficient wait times or stuck processes (zombie spans), you reduce runner duration, directly saving money.

### 4. Code Ownership
*   **Problem:** A build fails, but who broke it?
*   **OTel Solution:** The trace contains the `git.author.name`. Automated alerts can slack the specific developer: *"Your commit X caused the build to slow down by 40%."*

---

## 6. Architecture Diagram

The flow of data in a CI/CD OTel setup usually looks like this:

```text
[ GitHub Actions Runner ]
       |
       |-- (Span: Workflow) ----------------------\
       |                                           \
       |-- [ Maven Build Process ]                  \
       |      |                                      \
       |      |-- (Span: Compile) --\                 \
       |      |                      \                 \
       |      |-- (Span: Test) -------> [ OTel Collector ] ---> [ Backend ]
       |             |               /   (Gateway Mode)      (Jaeger/Honeycomb/Tempo)
       |             |-- (Log: Error)/
       |
       |-- [ otel-cli exec ] -----------------------/
```

## Summary for the Exam/Interview
*   **Goal:** Replace text logs with distributed traces to understand build performance and failures.
*   **Key Challenge:** Propagating context (`TRACEPARENT`) from the CI runner (GitHub) to the build tool (Maven) to the test runner (JUnit).
*   **Tools:** `otel-cli`, Maven/Gradle Extensions, Trace-based testing tools.
*   **Outcome:** Faster builds, cheaper infrastructure, and easier debugging of flaky tests.