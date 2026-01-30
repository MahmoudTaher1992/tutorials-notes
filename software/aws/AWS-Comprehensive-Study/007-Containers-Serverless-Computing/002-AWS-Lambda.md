Based on the Table of Contents you provided, here is a detailed explanation of **Part VII - Section B: AWS Lambda - Serverless Functions**.

---

# Part VII, Section B: AWS Lambda

## 1. Introduction to Serverless Computing
To understand Lambda, you must first understand **Serverless**.
*   **No Servers to Manage:** "Serverless" doesn't mean there are no servers; it means specific servers are **abstracted away** from you. You do not provision, patch, update, or manage the operating system (OS). AWS handles the infrastructure.
*   **Event-Driven:** Serverless resources usually sit idle until an "event" happens to wake them up.
*   **Pay-for-Value:** You stop paying for "idle" time. If your code isn't running, your bill is $0.

## 2. What is AWS Lambda?
AWS Lambda is a **Function-as-a-Service (FaaS)**. It allows you to upload a piece of code (a function), and AWS runs it only when needed.

### Key Components:
1.  **The Code:** You write the logic (e.g., "Take this image and resize it").
2.  **The Trigger:** What causes the code to run? (e.g., An HTTP request, a file upload, a database change).
3.  **The Runtime:** The environment the code runs in (e.g., Python 3.9 environment).

## 3. Supported Runtimes & Programming Models
Lambda supports many popular programming languages out of the box. You don't need to install Python or Node.js on a server; you just select the runtime.
*   **Native Support:** Node.js, Python, Ruby, Java, Go, .NET (Powershell/C#).
*   **Custom Runtimes:** If functionality isn't supported out of the box (e.g., Rust or PHP), you can use "Custom Runtimes" or provide a Container Image giving you total flexibility.

## 4. Integrating Lambda with Other Services (Use Cases)
Lambda is often called the **"Glue"** of AWS because it connects services together. Here are the most common integrations from your TOC:

### A. Lambda + API Gateway (The Backend)
*   **Scenario:** You want to build a website API without a server.
*   **Flow:** A user clicks a button on your website $\rightarrow$ Sends HTTP Request to **API Gateway** $\rightarrow$ API Gateway triggers **Lambda** $\rightarrow$ Lambda fetches data and returns it.

### B. Lambda + S3 (File Processing)
*   **Scenario:** Automatic thumbnail creation.
*   **Flow:** User uploads a photo to an **S3 Bucket** $\rightarrow$ S3 detects the upload event $\rightarrow$ Triggers **Lambda** $\rightarrow$ Lambda resizes the image and saves the thumbnail back to S3.

### C. Lambda + DynamoDB (Data Streams)
*   **Scenario:** Audit logging.
*   **Flow:** An application updates a user's address in **DynamoDB** $\rightarrow$ DynamoDB Stream triggers **Lambda** $\rightarrow$ Lambda reads the "Old" and "New" data and sends an email notification to the admin via SES.

## 5. Lambda Execution Roles (IAM) & Permissions
This is a critical security concept. A Lambda function is an entity; by default, **it has permission to do absolutely nothing.**

*   **Execution Role:** You must create an IAM Role (e.g., `LambdaS3WriteRole`) and attach it to the function.
*   **Policies:** This role must have specific policies.
    *   *Example:* If your Lambda needs to read a file from S3 and write a log to CloudWatch, the IAM Role must explicitly allow `s3:GetObject` and `logs:PutLogEvents`.
*   **Access Denied:** If your code fails with "Access Denied," it is almost always because the **Execution Role** is missing a permission.

## 6. Concurrency and Scaling
Lambda scales **horizontally** and automatically, but differently than EC2.

*   **1 Event = 1 Execution:** If 1 user visits your site, 1 Copy of Lambda runs. If 1,000 users visit simultaneously, AWS automatically spins up 1,000 separate copies of that function instantly.
*   **Concurrency Limits:** By default, an AWS account has a limit of 1,000 concurrent executions per region (this can be increased by requesting a quota increase).
*   **Cold Starts:** When a function hasn't run in a while, AWS has to "boot up" the environment. This adds a slight delay (latency) called a "Cold Start."
*   **Provisioned Concurrency:** You can pay extra to keep a certain number of Lambdas "warm" and ready to respond instantly.

## 7. Lambda Layers
As you write more functions, you will find yourself Copy/Pasting the same code or libraries (e.g., a PDF generation library or the `pandas` data library) into every function zip file.

*   **The Problem:** Your deployment packages become huge and hard to manage.
*   **The Solution (Layers):** You zip up the shared libraries once and upload them as a **Layer**.
*   **How it works:** You attach the Layer to multiple functions. When the function runs, AWS extracts the layer alongside your code. This keeps your actual function code small and clean.

## Summary: Constraints & Pricing
*   **Timeout:** A Lambda function can verify run for a maximum of **15 minutes**. If your task takes 20 minutes, Lambda is the wrong tool (use ECS or AWS Batch).
*   **Ephemeral:** The file system is temporary. If the function stops, any data saved to the local disk is lost. You must save data to S3 or a Database (DynamoDB/RDS).
*   **Pricing:** You are charged based on:
    1.  **Number of Requests:** How many times it ran.
    2.  **Duration (GB-seconds):** How long the code ran (in milliseconds) multiplied by how much RAM you allocated to it.
