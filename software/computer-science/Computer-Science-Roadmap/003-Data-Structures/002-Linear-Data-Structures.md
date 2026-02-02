Based on the roadmap you provided, **Part III-B: Linear Data Structures** is a foundational section of Computer Science.

Here is a detailed explanation of what Linear Data Structures are and a breakdown of every item listed in that section.

---

### **What is a Linear Data Structure?**
A data structure is considered **linear** if the data elements are arranged sequentially (one after the other). In a linear structure, every element has exactly one **predecessor** and one **successor**, except for the first and last elements.

Think of them like a train: the carriages are connected in a line. You traverse them one by one.

---

### **1. Arrays (1D, 2D, Multidimensional)**
An array is the most basic linear structure. It is a collection of elements of the **same data type** stored in **contiguous** (touching) memory locations.

*   **1D Arrays (One-Dimensional):**
    *   **Concept:** A simple list.
    *   **Example:** `[10, 20, 30, 40]`
    *   **Key Feature:** You can access any item instantly if you know its index (location). This is called **O(1)** access time.
    *   **Drawback:** The size is usually fixed. If you make an array of 5 slots, you cannot add a 6th item without creating a whole new, bigger array.

*   **2D Arrays (Matrix):**
    *   **Concept:** A grid with Rows and Columns (like an Excel spreadsheet or a chessboard).
    *   **Memory:** Computer memory is 1D (on a long tape), so 2D arrays are actually stored linearly in memory (either row-by-row or column-by-column), but the programming language abstracts this so you can access data like `Grid[row][col]`.

*   **Multidimensional Arrays:**
    *   **Concept:** Arrays with 3 or more dimensions (e.g., a 3D cube).
    *   **Use Case:** 3D is often used in graphics or physics simulations. 4D+ are used in complex mathematical computations and Deep Learning (tensors).

---

### **2. Linked Lists**
Unlike arrays, Linked Lists do **not** store data in contiguous memory. The data is scattered everywhere in memory. To keep the order, each element (called a **Node**) holds the data *and* a direction sign pointing to the next element.

*   **Singly Linked List:**
    *   **Structure:** `[Data | Next Pointer] -> [Data | Next Pointer] -> NULL`
    *   **Movement:** One-way street. You can only move forward.
    *   **Pros:** Dynamic size (you can keep adding nodes forever). Inserting/Deleting is fast (just change the pointers).
    *   **Cons:** To find the 10th element, you must start at the beginning and hop 10 times (**O(n)** access).

*   **Doubly Linked List:**
    *   **Structure:** `NULL <- [Prev | Data | Next] <-> [Prev | Data | Next] -> NULL`
    *   **Movement:** Two-way street. You can move forward and backward.
    *   **Pros:** Easier to delete a node effectively because the node knows who is behind it.
    *   **Cons:** Takes up more memory because every node needs to store an extra pointer.

*   **Circular Linked List:**
    *   **Structure:** The last node points back to the first node instead of pointing to NULL.
    *   **Use Case:** Repeating tasks, like a music playlist on "Loop" or a CPU scheduling tasks in a circle (Round Robin).

---

### **3. Stacks & Queues**
These are **Abstract Data Types (ADTs)**. This means they are defined by their *behavior* (rules of adding/removing), not necessarily how they are stored in memory. They can be built using Arrays or Linked Lists.

#### **Stacks (LIFO: Last In, First Out)**
*   **Analogy:** A stack of plates at a buffet. You put one on top, and you take the top one off. You cannot easily take the bottom plate.
*   **Main Operations:**
    *   **Push:** Add to the top.
    *   **Pop:** Remove from the top.
    *   **Peek:** Look at the top without removing.
*   **Use Cases:** The "Undo" button (Ctrl+Z) in text editors; how browsers manage the "Back" button; managing function calls in programming (Call Stack).

#### **Queues (FIFO: First In, First Out)**
*   **Analogy:** A line (queue) of people waiting for a bus. The first person to arrive is the first to get on.
*   **Main Operations:**
    *   **Enqueue:** Add to the back.
    *   **Dequeue:** Remove from the front.
*   **Use Cases:** Printer jobs (documents print in the order sent); streaming video buffers; handling requests on a web server.

*   **Implementations (Array vs. Linked):**
    *   *Array Implementation:* Faster, but size-limited. Tricky logic required for Queues (using "Circular Arrays") to prevent wasted space.
    *   *Linked Implementation:* Dynamic size, easier logic, but slightly slower due to memory scattering.

---

### **4. Deques & Priority Queues**
These are advanced variations of Queues.

*   **Deque (Double-Ended Queue):**
    *   **Pronunciation:** "Deck".
    *   **Concept:** A flexible queue where you can add or remove elements from **both** the front and the back.
    *   **Use Cases:** Checking if a word is a palindrome (reads same forward and back); Browsers (storing history for both Back and Forward buttons).

*   **Priority Queue:**
    *   **Concept:** Like a regular queue, but every element has a "Level of Importance" (VIP status).
    *   **Behavior:** Even if an element arrives last, if it has the highest priority, it cuts to the front of the line.
    *   **Analogy:** A hospital Emergency Room. A patient with a heart attack (High Priority) is treated before a patient with a cold (Low Priority), even if the cold patient arrived earlier.
    *   **How it works:** Under the hood, this is usually implemented using a **Heap** (a type of Tree), but it is often classified here because it behaves like a linear queue to the user.
