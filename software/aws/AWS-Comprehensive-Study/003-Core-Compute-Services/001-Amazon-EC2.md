Based on your Table of Contents, here is a detailed breakdown of **Part III: Core Compute Services — A. Amazon Elastic Compute Cloud (EC2)**.

This is often considered the "backbone" of AWS. EC2 allows you to rent virtual computers (servers) on which to run your own computer applications.

---

### 1. EC2 Fundamentals

#### **Amazon Machine Images (AMIs)**
Think of an AMI as a **template** or a "gold image" for your server. You cannot launch a virtual machine without a template.
*   **What it includes:** The Operating System (Linux, Windows), application server (e.g., Apache, IIS), and applications.
*   **Types of AMIs:**
    *   *AWS Marketplace:* Images pre-configured by vendors (e.g., a Wordpress AMI, a Cisco Router AMI).
    *   *Community AMIs:* Free images created by the public (use with caution).
    *   *My AMIs:* You can configure a server, take a snapshot of it, and save it as your own private AMI to launch duplicates later.

#### **Instance Types**
Not all servers are created equal. AWS categorizes hardware configurations into families using a naming convention (e.g., `m5.large`).
*   **General Purpose (T & M series):** A balance of compute, memory, and networking. Good for web servers and code repositories.
*   **Compute Optimized (C series):** High performance processors. Great for batch processing, media transcoding, and high-performance web servers.
*   **Memory Optimized (R series):** Large amounts of RAM. Necessary for high-performance databases or real-time big data processing.
*   **Accelerated Computing (P & G series):** Hardware GPUs. Used for machine learning, graphics processing, or gaming.

#### **EC2 Pricing Models**
Understanding how to pay is critical for the exam and real-world budgeting.
1.  **On-Demand:** Pay by the second or hour. No commitment. Most flexible, but most expensive.
    *   *Use case:* Short-term, spiky, or unpredictable workloads.
2.  **Reserved Instances (Standard & Convertible):** You commit to a 1-year or 3-year contract. Significant discount (up to 72%).
    *   *Use case:* Steady-state usage (e.g., a database that must run 24/7).
3.  **Savings Plans:** Similar to Reserved, but you commit to a specific dollar amount per hour (e.g., $10/hr) rather than a specific instance family. Offers more flexibility.
4.  **Spot Instances:** You bid on unused AWS capacity. Up to 90% discount. **Caveat:** AWS can terminate your instance with only a 2-minute warning if they need the hardware back.
    *   *Use case:* Batch jobs, image processing, or anything that can "fail" and restart later.
5.  **Dedicated Hosts:** Physical servers dedicated entirely to you (no other customers on the hardware). Used for specific software licensing compliance (e.g., Oracle, Windows).

---

### 2. Launching and Connecting to EC2

#### **Key Pairs (SSH & RDP)**
AWS does not typically give you a root password to log in. They use Public Key Cryptography.
*   **Public Key:** Stored by AWS on the instance.
*   **Private Key:** You download this **once** (`.pem` file) when you create the instance.
*   *Security:* If you lose the Private Key, you lose access to the instance. There is no "reset password" button for the key itself.

#### **User Data**
This is a script that runs **only once** upon the very first boot of the instance.
*   **Bootstrapping:** The process of automatically installing updates, patching software, and downloading source code immediately after the server turns on.
*   *Example:* You launch a Linux server, and in the User Data, you write a script to `yum install httpd` (Apache) and download your website HTML file.

---

### 3. EC2 Storage (Block Storage)

#### **Elastic Block Store (EBS)**
Think of this as a virtual **USB stick** or a network drive.
*   It is a network drive, not physically attached to the CPU.
*   **Persistent:** If you stop the server, the data on the EBS volume remains.
*   They are "Locked" to an Availability Zone (you cannot attach a Volume in AZ-A to an instance in AZ-B).
*   **Snapshots:** You can take a backup of an EBS volume (stored in S3). Snapshots are incremental (only back up what has changed).

#### **Instance Store (Ephemeral Storage)**
Think of this as the hard drive physically inside the computer.
*   **Physical Connection:** Physically attached to the host server. Very high I/O speed.
*   **Ephemeral (Temporary):** If you **Stop** or **Terminate** the instance, the data on this drive is **erased** forever.
*   *Use case:* Cache buffers, scratch data, temporary content.

---

### 4. Networking

#### **Elastic IP (EIP)**
*   When you stop and start an EC2 instance, its Public IP address usually changes.
*   An **Elastic IP** is a static Public IPv4 address that stays with you.
*   *Cost Rule:* If your EIP is attached to a running instance, it is free. If you hold an EIP and *don't* use it (it's not attached), AWS charges you (to prevent hoarding).

#### **Placement Groups**
This controls how your instances are placed on the physical hardware within an AWS data center.
1.  **Cluster:** Pack instances close together (same rack). Low latency, high network throughput. (Good for Big Data).
2.  **Spread:** Place instances on distinct hardware racks. Reduces risk of simultaneous failure. (Good for critical applications).
3.  **Partition:** Logical groups. Instances in one partition do not share hardware with instances in another partition. (Good for Hadoop/Cassandra).

---

### 5. Scalability and High Availability

#### **Elastic Load Balancing (ELB)**
The "Traffic Cop" of AWS. Even if you have 10 servers, you want your users to go to a single URL.
*   The ELB sits in front of your EC2 instances.
*   It distributes incoming traffic across multiple targets (instances) in multiple Availability Zones.
*   **Health Checks:** The ELB periodically checks if your instances are working. If an instance fails, the ELB stops sending traffic to it.

#### **Auto Scaling Groups (ASG)**
This allows your application to handle changes in traffic by dynamically adding or removing EC2 instances.
*   **Scale Out:** CPU usage goes > 80%? Add 2 new servers automatically.
*   **Scale In:** 4:00 AM and traffic is low? Terminate the extra servers to stop paying for them.
*   **Self-Healing:** If an instance crashes (fails an ELB health check), the Auto Scaling Group destroys it and launches a fresh replacement automatically.
