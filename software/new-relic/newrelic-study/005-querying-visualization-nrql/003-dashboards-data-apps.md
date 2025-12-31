Based on the Table of Contents you provided, this section (**Part V, Section C: Dashboards & Data Apps**) is the practical application of the NRQL skills learned in the previous sections.

While NRQL allows you to ask questions of your data, **Dashboards** are where you permanently visualize the answers to monitor the health of your systems.

Here is a detailed breakdown of **005-Querying-Visualization-NRQL/003-Dashboards-Data-Apps.md**.

---

# Detailed Explanation: Dashboards & Data Apps

In New Relic, a **Dashboard** is a collection of widgets (charts) organized on a single page. A **Data App** is essentially a highly interactive dashboard (or set of dashboards) that behaves like an application, allowing users to drill down and filter data dynamically without writing code.

## 1. Creating Custom Dashboards
Standard New Relic views (like the APM Summary page) are great, but they are "opinionated"—they show what New Relic thinks is important. Custom dashboards show what **you** think is important.

There are three main ways to build them:
*   **From Scratch:** You start with a blank white canvas and add widgets one by one using the Query Builder.
*   **From Existing Charts:** When viewing any standard New Relic chart (e.g., in APM or Infrastructure), you can click the `...` menu and select **"Add to Dashboard"**. This is the fastest way to build a board without writing NRQL from scratch.
*   **JSON / Terraform:** You can define dashboards as code (Infrastructure as Code), allowing you to version control your visualizations.

## 2. Widget Types (Visualizing the Data)
Different data requires different visualizations. New Relic offers several "Visualizations" based on the result of your NRQL query.

### A. Billboard (The "Big Number")
*   **Use Case:** High-level KPIs (Key Performance Indicators).
*   **NRQL Requirement:** A query that returns a single value (e.g., `count(*)`, `average(duration)`).
*   **Feature:** You can set **Thresholds**. For example, if `Error Rate > 5%`, turn the number **Red**. If it is `< 1%`, turn it **Green**.
*   *Example:* "Current Apdex Score" or "Total Sales Today."

### B. Line & Area Charts (Time Series)
*   **Use Case:** spotting trends, spikes, or drops over time.
*   **NRQL Requirement:** Must include the `TIMESERIES` clause.
*   **Feature:** You can stack data (Area chart) to see the total composition, or just use lines to compare specific metrics.
*   *Example:* `SELECT average(duration) FROM Transaction TIMESERIES` (Response time over the last hour).

### C. Pie & Donut Charts
*   **Use Case:** Showing distribution or proportions.
*   **NRQL Requirement:** Must include a `FACET` clause (grouping).
*   **Feature:** Shows the top items; everything else is grouped into "Other".
*   *Example:* `SELECT count(*) FROM Transaction FACET appName` (Which apps are generating the most traffic?).

### D. Tables
*   **Use Case:** displaying raw data, logs, or lists of specific attributes.
*   **Feature:** Useful for "Top 10" lists or detailed error logs.
*   *Example:* A list of the slowest 10 URLs in your application.

### E. Bar Charts
*   **Use Case:** Comparing categorical data (similar to Pie charts but better for comparing magnitudes).

## 3. Markdown and Images in Dashboards
A dashboard full of charts can be confusing to a new team member. New Relic allows you to add **Text** and **Images** widgets that do not use data.

*   **Markdown:** You can add a widget containing formatted text.
    *   *Usage:* Add instructions ("If this graph turns red, call Team X"), links to Runbooks/Wikis, or descriptions of what the dashboard represents.
*   **Images:** You can embed architecture diagrams or logos to provide visual context to the data.

## 4. Dashboard Variables (The "Data App" Concept)
This is the most powerful feature. Variables transform a **Static Dashboard** into a **Dynamic Tool**.

Instead of creating 10 different dashboards for 10 different host machines, you create **one** dashboard and add a **Variable** filter.

*   **How it works:**
    1.  You define a variable (e.g., `host_name`).
    2.  You map that variable to a query (e.g., `SELECT uniques(host) FROM Transaction`).
    3.  A dropdown menu appears at the top of the dashboard.
*   **Binding:** inside your widgets, you modify the NRQL to look like this:
    ```sql
    SELECT average(cpuPercent) FROM SystemSample WHERE hostname = {{host_name}}
    ```
*   **The User Experience:** When a user selects "Server-A" from the dropdown, *every widget on the board* instantly updates to show data only for "Server-A."

## 5. Exporting and Reporting
Once a dashboard is built, it needs to be shared.

*   **PDF Generation:** You can export the current view as a PDF. This is commonly used for executive reporting (e.g., "Weekly Performance Report").
*   **TV Mode:** Removes the UI chrome (menus/sidebars) so the dashboard can be displayed on a large TV screen in an office (NOC/SOC).
*   **Permalinks:** A URL that links to the dashboard with the exact time window you are currently looking at.

---

### Summary of Learning Goal
By mastering this section, you move from simply **querying** data to **telling a story** with data. You learn how to build control panels that SREs, Developers, and Business Managers can use to understand the health of the system at a glance.
