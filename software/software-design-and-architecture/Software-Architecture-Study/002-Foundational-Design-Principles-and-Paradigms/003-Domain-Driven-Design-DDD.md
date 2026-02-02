Here is a detailed explanation of section **002 / 003 - Domain-Driven Design (DDD)**.

---

# Domain-Driven Design (DDD)

**What is it?**
Domain-Driven Design, popularized by Eric Evans in his "Blue Book," is an approach to software development that centers on the **business problem** (the Domain) rather than the technology.

In many software projects, developers focus heavily on the database schema or the UI frameworks. in DDD, the focus is on modeling the real-world business rules and processes. The goal is to create a software model that is a direct reflection of the business reality.

DDD is generally split into two halves: **Strategic Design** (High-level architecture and team boundaries) and **Tactical Design** (Low-level coding patterns).

---

## 1. The Core Philosophy: Ubiquitous Language

Before you write code, DDD demands that developers and "Domain Experts" (business stakeholders, product managers) speak the same language.

*   **The Problem:** Business people talk about "Opening a Case" or "Charging a Ledger," while developers talk about "Inserting a Record" or "Updating the Table." Translation errors occur here.
*   **The Solution (Ubiquitous Language):** A shared vocabulary that is rigorous and strictly used in both verbal conversation and the code itself.
    *   If the business calls it a "ShoppingCart," the code class must be named `ShoppingCart`, not `UserSessionBasket`.
    *   A change in the business language implies a necessary refactoring of the code.

---

## 2. Strategic DDD (The Big Picture)

Strategic design is about defining boundaries to manage complexity. It prevents the creation of a massive, tangled "Big Ball of Mud" monolith.

### A. Bounded Context
This is the central pattern of DDD. Large systems are too complex to have a single, unified data model.
*   **Concept:** A "Bounded Context" is a specific boundary within which a particular domain model applies.
*   **Example:** Consider the word **"Customer."**
    *   In the **Sales Context**, a Customer is someone with a lead score and sales opportunities.
    *   In the **Shipping Context**, a Customer is just a name and a delivery address.
    *   In the **Billing Context**, a Customer is a credit card number and a payment history.
*   **Implementation:** Instead of creating one giant `Customer` class with 50 fields to satisfy everyone, you create three separate, smaller models, each living in its own Bounded Context (often deployed as separate Microservices).

### B. Context Mapping
This defines how different Bounded Contexts talk to each other.
*   **Upstream/Downstream:** Who depends on whom?
*   **Anti-Corruption Layer (ACL):** If a new, clean system needs to talk to an ugly legacy system, you build an adapter layer so the legacy "mess" doesn't leak into your clean domain model.
*   **Shared Kernel:** A small, specific set of code/logic shared by two teams (use sparingly).

---

## 3. Tactical DDD (The Building Blocks)

Once you have your boundaries, you use Tactical patterns to write the code *inside* a Bounded Context.

### A. Entities vs. Value Objects
This is the most fundamental distinction in DDD data modeling.

*   **Entities:** Objects defined by their **Identity**.
    *   *Example:* A `Person`. If a person changes their name or hair color, they are still the same person because they have a unique ID (Social Security Number or Database ID).
    *   *Mutable:* The data inside can change, but the identity remains.

*   **Value Objects:** Objects defined by their **Attributes**.
    *   *Example:* A `Color` (Red) or an `Address`. If you have two pieces of paper and write "123 Main St" on both, they are effectively the same address. You don't care about the "ID" of the address, only the data (Street, City, Zip).
    *   *Immutable:* You do not change a value object; you replace it. If you paint a wall, you don't change the `Red` object to `Blue`; you throw away `Red` and apply `Blue`.

### B. Aggregates
An Aggregate is a cluster of domain objects (Entities and Value Objects) that can be treated as a single unit.

*   **The Problem:** Data consistency. If you delete an `Order`, you must also delete all `OrderLines`.
*   **The Solution:** You group them together.
*   **Aggregate Root:** One entity is chosen as the "Root" (e.g., `Order`). Outside objects can holds references *only* to the Root, not to the internal objects (e.g., you cannot access an `OrderLine` directly; you must ask the `Order` to give it to you).
*   **Rule:** Transactions should ideally modify only one Aggregate at a time.

### C. Repositories
Repositories are the mechanism for saving and retrieving Aggregates.
*   **Abstraction:** It abstracts the database layer. The Domain model shouldn't know if you are using SQL, NoSQL, or a file system.
*   **Interface:** It should look like a collection. e.g., `OrderRepository.Add(order)` or `OrderRepository.GetById(id)`.
*   **Difference from DAO:** A DAO is usually creating generic CRUD for database tables. A Repository is specifically for loading/saving full Aggregates.

### D. Domain Events
A mechanism to handle side effects across the system.
*   **Concept:** Instead of the "Order" service calling the "Email" service directly (coupling), the Order service simply shouts: *"Order Placed!"*
*   **Result:** Other parts of the system (Email, Inventory, Shipping) listen for that event and react accordingly. This leads to **Eventual Consistency**.

---

## 4. When and Why to Apply DDD

DDD is not for every project.

*   **Do NOT use DDD for:** Simple CRUD applications (Create, Read, Update, Delete). If your app is just moving data from a screen to a database, DDD adds unnecessary complexity and "ceremony."
*   **DO use DDD for:** Complex business domains where the logic is intricate (e.g., Banking, Logistics, Insurance, Flight Scheduling).
*   **The "Core Domain":** In a large system, identify the "Core Domain"—the part of the system that actually makes money and is unique to the business. Apply DDD there. For generic parts (like Helpdesk or Authentication), buy off-the-shelf software or use simple CRUD designs.
