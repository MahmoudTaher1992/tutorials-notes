Hello! I am a **Senior DevOps Engineer and Computer Science Instructor**. I specialize in teaching how large-scale software systems talk to each other and how we keep them healthy without crashing.

Here is the summary of the OpenTelemetry Core Processors, structured as a deep tree for clarity.

***

### 🌳 OpenTelemetry Collector: Core Processors

*   **1. Concept Overview**
    *   **Role within the Collector** (The "Brain" and "Digestive System")
        *   It sits between **Receivers** (Input/Mouth) and **Exporters** (Output/Hands).
        *   **Main Goal** (To clean, organize, enrich, and optimize data before sending it to the backend).
    *   **The "Core" Processors**
        *   These are four specific processors essential for almost every **production-grade** setup.

*   **2. The Memory Limiter Processor (`memory_limiter`)**
    *   **Function** (The Safety Valve / Crash Prevention)
        *   Prevents the Collector from crashing due to **Out of Memory (OOM)** errors during traffic spikes.
    *   **Mechanism** (How it decides to act)
        *   Monitors RAM usage at set intervals.
        *   **Soft Limit** (When hit, it refuses *new* data or cleans up old data to stabilize).
        *   **Hard Limit** (When hit, it aggressively **drops data** to save the application from dying).
    *   **Configuration**
        *   Can be set by **absolute size** (Mib) or **percentage** (useful for containers).
    *   **Critical Best Practice**
        *   **Must be the FIRST processor.**
        *   *Reasoning* (If the boat is sinking, stop loading cargo immediately. Don't waste CPU processing data you are going to drop anyway).

*   **3. The Batch Processor (`batch`)**
    *   **Function** (The Performance Optimizer)
        *   Prevents network flooding by grouping data points into chunks instead of sending them one by one.
    *   **Triggers** (Sends data when whichever occurs first)
        *   **Time** (e.g., "Wait 200ms and send whatever we have").
        *   **Size** (e.g., "Wait until we have 1,000 items").
    *   **Critical Best Practice**
        *   **Should be the LAST processor.**
        *   *Reasoning* (You want to modify, filter, or clean individual items *before* you seal them into a box/batch).

*   **4. The Resource Processor (`resource`)**
    *   **Function** (The Context Labeler / Infrastructure Identity)
        *   Handles the **"Who"** and **"Where"** of the data.
        *   Deals with **Global** attributes (Applies to the whole app instance, not just one request).
    *   **Use Cases**
        *   **Labeling Environments** (e.g., tagging data with `deployment.environment: production`).
        *   **Cloud Identity** (e.g., adding `cloud.region: us-east-1`).
        *   **Anonymization** (e.g., removing internal IP addresses).
    *   **Actions**
        *   **Insert** (Add if missing).
        *   **Upsert** (Add or overwrite).
        *   **Delete** (Remove sensitive tags).

*   **5. The Attributes Processor (`attributes`)**
    *   **Function** (The Data Janitor)
        *   Handles the **"What"** of the data.
        *   Deals with **Specific** attributes inside a Span, Log, or Metric.
    *   **Key Difference vs. Resource Processor**
        *   Resource = **Entity Identity** (The Server).
        *   Attributes = **Event Detail** (The Request).
    *   **Use Cases**
        *   **PII Redaction** (Masking or Hashing sensitive user data like emails or passwords).
        *   **Cost Reduction** (Dropping unnecessary high-cardinality data to save money).
        *   **Standardization** (Renaming keys to match company standards).

*   **6. The "Golden" Pipeline Order**
    *   **Recommended Sequence**
        1.  **Memory Limiter** (Protection first).
        2.  **Sampling** (Optional reduction).
        3.  **Resource / Attributes** (Cleaning and Tagging).
        4.  **Batch** (Packaging for transport).
    *   **Logic Flow**
        *   **Step 1:** Do we have memory space? (No? Drop it. Yes? Proceed).
        *   **Step 2:** Scrub the data and add name tags.
        *   **Step 3:** Pack the clean data into a box and ship it efficiently.
