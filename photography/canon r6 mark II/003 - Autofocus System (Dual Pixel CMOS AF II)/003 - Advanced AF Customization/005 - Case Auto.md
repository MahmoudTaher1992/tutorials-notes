Here is the detailed breakdown for the next file in your structure.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/003 - Advanced AF Customization/005 - Case Auto.md`

***

# AF Case "Auto": Letting the Algorithm Decide

In addition to the numbered Cases (1-4), the R6 Mark II features a setting labeled **Case A (Auto)**. This is distinct from "Subject Detection: Auto." While Subject Detection decides *what* to track (Human vs. Dog), **Case A** decides *how* to track it (Sensitivity vs. Speed).

### 1. How Case A Works
Case A is essentially a dynamic wrapper that switches between Cases 1, 2, 3, and 4 in real-time.
*   **Analysis:** The camera analyzes the scene's vector information.
    *   If the subject is moving steadily, it applies Case 1 logic.
    *   If the focus point suddenly loses the subject (obstacle), it momentarily applies Case 2 logic (Stickiness).
    *   If the subject starts changing speed erratically, it shifts to Case 4 logic.
*   **Integration:** This creates a "Smart" tracking system that adapts to the situation without user input.

### 2. The Pros (Why use it?)
*   **Variable Sports:** In a game like Rugby, play can transition from a steady run (Case 1) to a messy scrum (Case 2) to a sprint (Case 4) in seconds. Manually switching cases is impossible. Case A handles this fluidity.
*   **Beginner Friendly:** It removes the need to understand the complex parameters of Tracking Sensitivity.

### 3. The Cons (Why Pros avoid it?)
*   **Unpredictability:** Professional photographers hate variables they cannot control.
    *   *Scenario:* You are shooting a bird flying past a tree. You *expect* the camera to ignore the tree (Case 2 behavior). However, Case A might misinterpret the tree entering the frame as a new subject and switch to Case 3 logic, snapping focus to the tree.
    *   *Result:* You don't know why you missed the shot. Was it you? Was it the camera?
*   **Latency:** There is a theoretical lag (milliseconds) as the camera detects the change in scene dynamics and switches logic profiles.

### Summary
*   **Use Case A** if you are overwhelmed by the choices or shooting a sport with totally unpredictable dynamics.
*   **Stick to Manual Cases (1-4)** if you want consistent, repeatable behavior that you can learn and compensate for. Knowing that "My camera will always stick to the subject" (Case 2) allows you to shoot through obstacles with confidence.