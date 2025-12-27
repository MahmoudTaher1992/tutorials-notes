Here is a detailed explanation of **Part IX: Programmability & APIs / Section A: NerdGraph (GraphQL API)**.

---

### What is NerdGraph?
**NerdGraph** is New Relic’s implementation of **GraphQL**. It is the unified, primary API for interacting with the New Relic platform.

Unlike traditional REST APIs, where you have to hit specific endpoints for specific data (e.g., `/v2/alerts` or `/v2/applications`) and often get back too much or too little data, GraphQL allows you to ask for **exactly** what you want in a single request.

Here is a breakdown of the four key areas listed in your Table of Contents:

---

### 1. Exploring the GraphiQL Explorer
The **GraphiQL Explorer** is an interactive browser-based IDE (Integrated Development Environment) provided by New Relic to help you write and test your API queries.

*   **Why it matters:** You do not need to memorize the API syntax. The Explorer provides documentation right inside the tool.
*   **How it works:**
    *   **Point-and-Click:** You can check boxes on the left side to select the data fields you want, and the tool writes the query code for you in the center panel.
    *   **Auto-complete:** As you type, it suggests available fields (Intellisense).
    *   **Live Testing:** You can run the query immediately against your live New Relic account to see the JSON response.
*   **Location:** You can access it at `api.newrelic.com/graphiql`.

---

### 2. Querying Entities and Data
In GraphQL, a "Query" is the equivalent of a `GET` request in REST. This is how you retrieve data.

#### A. The `actor` Hierarchy
Almost all queries start with the `actor`. The actor represents the user (or API key) making the request. From there, you drill down into accounts and entities.

#### B. Fetching NRQL Data via API
One of the most powerful features is running NRQL queries programmatically. This allows you to extract raw data for external reporting or custom tools.

**Example Query:**
```graphql
{
  actor {
    account(id: 1234567) {
      nrql(query: "SELECT average(duration) FROM Transaction SINCE 1 hour ago") {
        results
      }
    }
  }
}
```

#### C. Entity Search
Instead of knowing specific IDs, you can search for entities (Apps, Hosts, Services) based on tags or names.
**Example:** "Find all services that are reporting Red (Critical) health status."

---

### 3. Mutations: Creating Dashboards & Alerts
In GraphQL, when you want to **create, update, or delete** data, it is called a **Mutation** (equivalent to `POST`, `PUT`, `DELETE` in REST).

This is crucial for **Automation** and **Infrastructure as Code**.

#### Common Use Cases:
1.  **Deployment Markers:** When your CI/CD pipeline deploys code (e.g., via Jenkins or GitHub Actions), it sends a mutation to New Relic to mark the chart. This helps you see if a new deployment caused a spike in errors.
2.  **Creating Dashboards:** You can define a dashboard structure in JSON and push it to New Relic using the `dashboardCreate` mutation.
3.  **Configuring Alerts:** You can script the creation of Alert Policies and Conditions so that every new microservice comes with standard alerting automatically.

**Example Mutation (Creating a Deployment Marker):**
```graphql
mutation {
  changeTrackingCreateDeployment(
    deployment: {
      entityGuid: "YOUR_ENTITY_GUID", 
      version: "v2.0.1", 
      user: "cicd-bot"
    }
  ) {
    deploymentId
  }
}
```

---

### 4. Tagging and Metadata Management
Tags are key-value pairs (e.g., `Team:Checkout`, `Env:Production`) attached to your entities. NerdGraph is the primary mechanism for managing these tags.

*   **Why use API for tags?** In large environments with thousands of hosts or containers, you cannot manually tag them in the UI. You use the API to apply tags in bulk.
*   **Workloads:** You use tags to group entities into "Workloads." For example, you can query NerdGraph to "Add the tag `System:Payment` to all APM services that start with the name 'pay-'".

**Example Mutation (Adding a tag):**
```graphql
mutation {
  taggingAddTagsToEntity(
    guid: "YOUR_ENTITY_GUID", 
    tags: {key: "Environment", values: ["Staging"]}
  ) {
    errors {
      message
    }
  }
}
```

### Summary
To master **NerdGraph**, you must understand:
1.  **It is a Single Endpoint:** All requests go to `https://api.newrelic.com/graphql`.
2.  **Hierarchy:** You usually traverse `Actor -> Account -> Feature`.
3.  **Read vs. Write:** Use `query` to get data, use `mutation` to change configurations.
4.  **The Explorer is your best friend:** Use the GraphiQL explorer to build your queries before pasting them into your scripts (Python, Node.js, Terraform, etc.).
