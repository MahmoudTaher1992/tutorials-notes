This section of the Table of Contents focuses on high-level patterns documented primarily in Martin Fowler’s seminal book, *Patterns of Enterprise Application Architecture* (PoEAA).

While the **Gang of Four (GoF)** patterns usually deal with how small groups of objects relate to each other (e.g., "How do I create this specific object?"), **Enterprise Patterns** deal with how to organize the massive layers of an application: **The User Interface**, **The Business Logic**, and **The Database**.

Here is a detailed breakdown of each concept in that section:

---

### 1. Domain Logic Patterns
*How do we organize the business rules? (i.e., calculating taxes, validating inventory, authorizing users)*

#### **Transaction Script**
*   **The Concept:** This is the simplest approach. You write a single procedure (script) that handles a single request from the presentation layer. It allows logic to be procedural.
*   **How it works:** User clicks "Checkout" $\to$ `checkout()` function runs $\to$ It validates inputs, calculates total, updates DB, sends email, returns success.
*   **Pros:** Fast to write, easy to understand for simple apps.
*   **Cons:** Becomes a "Spaghetti Code" nightmare as complexity grows. Duplicate code is common.

#### **Domain Model**
*   **The Concept:** The Object-Oriented approach. Instead of one big script, you create objects that mimic the real world (e.g., an `Order` object, a `Customer` object). These objects verify their own rules.
*   **How it works:** The `Order` object knows how to calculate its own total. The `Customer` object knows how to validate its address. The code mimics the business conceptual map.
*   **Pros:** Highly reusable, easier to manage in complex systems, encapsulates logic.
*   **Cons:** steeper learning curve; requires an object-relational mapper (ORM) to talk to the database effectively.

#### **Table Module**
*   **The Concept:** A middle ground mostly used in environments like older .NET applications. Instead of an object per *row* (like standard OOP), you have a class that represents the entire *table*.
*   **How it works:** You have a `Orders` class (plural). You pass it an ID, and it calculates data based on the dataset it holds.
*   **Context:** Less common in modern web development, but useful when dealing with strict tabular data structures.

---

### 2. Data Source Architectural Patterns
*How do our objects talk to the database?*

#### **Active Record**
*   **The Concept:** An object wraps a row in a database table *and* includes the database access logic.
*   **Example:** `user.save()`, `user.delete()`.
*   **Context:** Heavily used in Ruby on Rails, Django, and Laravel.
*   **Pros:** very fast development speed; intuitive for CRUD apps.
*   **Cons:** Violates the Single Responsibility Principle (the object holds data *and* talks to the DB). Harder to unit test.

#### **Data Mapper**
*   **The Concept:** The objects in your code (Domain Objects) know *nothing* about the database. A separate "Mapper" layer moves data between the objects and the database.
*   **Context:** Used in Hibernate (Java), TypeORM (Node/TS), Entity Framework (dotNET).
*   **Pros:** Pure logic. Your business objects are clean and testable. You can change the DB without changing the business logic.
*   **Cons:** More boilerplate code; harder to set up initially.

#### **Repository**
*   **The Concept:** An abstraction that makes the database look like an in-memory collection. The application asks the Repository for data, and the Repository decides how to get it (SQL, API, Cache).
*   **Philosophy:** "Give me all users where age > 20." (The code doesn't care *how* that happens).
*   **Pros:** Decouples the app from the database technology; makes testing easier (you can swap a Fake Repository for the Real Repository).

#### **Unit of Work**
*   **The Concept:** Maintains a list of objects affected by a business transaction and coordinates the writing out of changes.
*   **Analogy:** A Shopping Cart. You don't pay for every item you pick off the shelf individually. You pick 10 items (add/update/delete), and then you go to the register and pay once (Commit).
*   **Benefit:** Ensures data integrity. Either all changes happen (Commit), or none happen (Rollback).

---

### 3. Presentation Patterns
*How do we organize the UI code so it doesn't get messy?*

#### **Model-View-Controller (MVC)**
*   **Structure:**
    *   **Model:** The data/business logic.
    *   **View:** What the user sees (HTML/CSS).
    *   **Controller:** The "Traffic Cop." It takes user input, tells the Model to update, and selects the correct View to display.
*   **Classic Use:** Spring Boot Web, Ruby on Rails, ASP.NET MVC.

#### **Model-View-Presenter (MVP)**
*   **Structure:** Similar to MVC, but the **View** is completely passive (dumb). It has zero logic. The **Presenter** sits in the middle and pushes data into the View.
*   **Key Difference:** In MVC, the View might see the Model. In MVP, the View only talks to the Presenter.
*   **Classic Use:** Android development (historically), Windows Forms.

#### **Model-View-ViewModel (MVVM)**
*   **Structure:**
    *   **Model:** Data.
    *   **View:** UI.
    *   **ViewModel:** A specialized object that holds the state of the View.
*   **Key Feature:** **Two-way Data Binding**. If the text in the View changes, the ViewModel updates automatically (and vice-versa) without writing "glue" code.
*   **Classic Use:** React (conceptually similar), Vue.js, Angular, WPF, Mobile development.

---

### Summary Table

| Category | Pattern | Simple Explanation |
| :--- | :--- | :--- |
| **Domain Usage** | **Transaction Script** | Step-by-step procedure (Procedural). |
| | **Domain Model** | Smart objects with data & behavior (OOP). |
| **Data Source** | **Active Record** | Object `save()`s itself. Ties logic to DB. |
| | **Data Mapper** | Separate layer translates DB to Objects. |
| | **Repository** | "Collection-like" interface for accessing data. |
| | **Unit of Work** | Tracks all changes and commits them at once. |
| **Presentation** | **MVC** | Controller splits input, model, and view. |
| | **MVVM** | Two-way binding between UI and Data state. |
