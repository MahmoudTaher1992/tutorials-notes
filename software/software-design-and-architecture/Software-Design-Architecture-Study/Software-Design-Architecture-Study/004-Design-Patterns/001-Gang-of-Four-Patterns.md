This section covers the foundational knowledge of Object-Oriented Design. The term **"Gang of Four" (GoF)** refers to the four authors (Erich Gamma, Richard Helm, Ralph Johnson, and John Vlissides) of the seminal 1994 book *Design Patterns: Elements of Reusable Object-Oriented Software*.

These 23 patterns represent **time-tested solutions to recurring design problems**. They are not code libraries; they are blueprints for solving specific architectural issues.

Here is a detailed breakdown of the three categories found in this section of the study guide.

---

### 1. Creational Patterns
**Theme:** *Object Creation.*
These patterns abstract the instantiation process. They help make a system independent of how its objects are created, composed, and represented. Instead of hard-coding `new ClassName()`, you use these patterns to gain flexibility.

*   **Singleton:**
    *   **Goal:** Ensures a class has only one instance and provides a global point of access to it.
    *   **Use Case:** Database connections, Logging services, Configuration settings.
    *   **Look out for:** Can introduce global state problems and make testing difficult.

*   **Factory Method:**
    *   **Goal:** Defines an interface for creating an object but lets subclasses alter the type of objects that will be created.
    *   **Use Case:** A logistics app where a `Transport` class invokes a factory. If it's a road request, it creates a `Truck`; if it's a sea request, it creates a `Ship`.

*   **Abstract Factory:**
    *   **Goal:** A "Super-Factory." It produces *families* of related or dependent objects without specifying their concrete classes.
    *   **Use Case:** A UI library that needs to render buttons and checkboxes. If the theme is "Dark," the factory creates `DarkButton` and `DarkCheckbox` together to ensure visual consistency.

*   **Builder:**
    *   **Goal:** Separates the construction of a complex object from its representation, allowing the same construction process to create different representations.
    *   **Use Case:** Constructing a complex `SQL Query` object (adding `.select()`, `.where()`, `.join()` step-by-step) or building a `Pizza` (selecting varying toppings, crusts, and sizes).

*   **Prototype:**
    *   **Goal:** Creates new objects by copying (cloning) an existing instance.
    *   **Use Case:** When object creation is expensive (e.g., heavy database query required to build the object). Instead, you clone an existing one in memory and modify small details.

---

### 2. Structural Patterns
**Theme:** *Class and Object Composition.*
These patterns explain how to assemble objects and classes into larger structures while keeping these structures flexible and efficient. They focus on how classes inherit from or contain one another.

*   **Adapter:**
    *   **Goal:** Allows objects with incompatible interfaces to collaborate. It acts as a wrapper.
    *   **Real World Analogy:** An electrical plug adapter allowing a US plug to fit into a European socket.
    *   **Use Case:** Integrating a 3rd-party Analytics library that expects data in XML, while your app uses JSON. You write an Adapter to translate JSON to XML.

*   **Decorator:**
    *   **Goal:** Adds new functionality to an object dynamically without altering its structure (an alternative to subclassing).
    *   **Use Case:** A `Text` object. You wrap it in a `BoldDecorator` to make it bold, then wrap that in a `BorderDecorator` to give it a border.

*   **Facade:**
    *   **Goal:** Provides a simplified interface to a library, a framework, or any other complex set of classes.
    *   **Use Case:** A "Make Order" button. Behind the scenes, the Facade handles `InventoryCheck`, `PaymentProcessing`, `ShippingQueue`, and `EmailConfirmation`, but the frontend only sees `placeOrder()`.

*   **Proxy:**
    *   **Goal:** Provides a substitute or placeholder for another object to control access to it.
    *   **Use Case:** A "Virtual Proxy" for loading large images. The proxy displays a loading spinner until the real image is fully downloaded. Also used for access control (security proxies).

*   **Composite:**
    *   **Goal:** Composes objects into tree structures to represent part-whole hierarchies. It lets clients treat individual objects and compositions of objects uniformly.
    *   **Use Case:** A File System. A `Folder` contains `Files` and other `Folders`. You can call `.delete()` on a File or a Folder, and the system handles it regardless of complexity.

*   **Bridge:**
    *   **Goal:** Splits a large class or a set of closely related classes into two separate hierarchies—abstraction and implementation—which can be developed independently.
    *   **Use Case:** You have `Shape` (Circle, Square) and `Color` (Red, Blue). Instead of creating `RedCircle`, `BlueCircle`, `RedSquare`, etc., you separate Shape and Color so they can vary independently.

---

### 3. Behavioral Patterns
**Theme:** *Object Communication.*
These patterns are concerned with algorithms and the assignment of responsibilities between objects. They visualize not just the patterns of objects or classes but also the patterns of communication between them.

*   **Strategy:**
    *   **Goal:** Defines a family of algorithms, encapsulates each one, and makes them interchangeable at runtime.
    *   **Use Case:** A GPS app. It can calculate the route using a `WalkingStrategy`, `DrivingStrategy`, or `PublicTransportStrategy` based on user selection.

*   **Observer:**
    *   **Goal:** Defines a subscription mechanism to notify multiple objects about any events that happen to the object they’re observing.
    *   **Use Case:** The basis of MVC and React architecture. When the "Model" (data) changes, the "View" (UI) observes this change and updates automatically. Also: Newsletters, YouTube notifications.

*   **Command:**
    *   **Goal:** Turns a request into a stand-alone object that contains all information about the request.
    *   **Use Case:** Undo/Redo operations. If every action (Copy, Paste, Delete) is an object, you can store them in a history stack and pop them off to "Undo."

*   **Template Method:**
    *   **Goal:** Defines the skeleton of an algorithm in the superclass but lets subclasses override specific steps of the algorithm without changing its structure.
    *   **Use Case:** A Data Miner. The "Base" class defines the steps: 1. Open File, 2. Parse Data, 3. Analyze, 4. Close File. Subclasses (`PDFMiner`, `CSVMiner`) implement the specific "Parse Data" logic, while the Base handles the rest.

*   **Iterator:**
    *   **Goal:** Lets you traverse elements of a collection without exposing its underlying representation (list, stack, tree, etc.).
    *   **Use Case:** `foreach` loops in most programming languages.

*   **State:**
    *   **Goal:** Lets an object alter its behavior when its internal state changes. It appears as if the object changed its class.
    *   **Use Case:** A Document workflow (Draft -> Moderation -> Published). The behavior of the `Publish()` method changes depending on what state the document is currently in.

*   **Chain of Responsibility:**
    *   **Goal:** Passes a request along a chain of handlers. Upon receiving a request, each handler decides either to process the request or to pass it to the next handler in the chain.
    *   **Use Case:** Customer Support Ticketing. Level 1 support tries to fix it; if not, sends to Level 2; if not, sends to Manager. Also: Middleware in web frameworks (Express.js or ASP.NET Core pipelines).

### Summary of How to Study This
1.  **Don't memorize the code.** Memorize the *problem* each pattern solves.
2.  **Trade-offs matter.** Using a pattern adds complexity. Always ask, "Do I actually need a factory here, or is a simple `new Class()` sufficient?"
3.  **Recognize them in the wild.** React uses Observer concept; Java APIs use Iterators heavily; Hardware drivers use Adapters.
