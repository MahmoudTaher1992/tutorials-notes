Here is the detailed breakdown for the next file in your structure.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/003 - Advanced AF Customization/004 - Case 4 Accelerating Subjects.md`

***

# AF Case 4: For Subjects That Accelerate or Decelerate Quickly

**Case 4** deals with **Speed Changes**, not obstacles. While Cases 1, 2, and 3 mostly care about *where* the subject is (Obstacles), Case 4 cares about the *math* of movement (Velocity).

### 1. The Core Logic: "Predictive Math"
The defining characteristic of Case 4 is its **Accel./Decel. Tracking** setting, which is set to **+1** or higher.
*   **Behavior:** Standard autofocus assumes linear movement (Constant Velocity). If a car is moving at 50mph, the camera predicts it will be at X position in the next frame.
*   **The Conflict:** If that car slams on the brakes or suddenly accelerates, it won't be at X. It will be short or long.
*   **Case 4 Solution:** It tells the processor to re-calculate velocity *more frequently* per second. It tolerates erratic speed changes.

### 2. Ideal Use Cases
*   **Motorsports (Corners):** Cars approach a corner at 180mph, brake hard to 60mph (Deceleration), turn, and blast out at 100mph (Acceleration). Case 4 is mandatory here. Case 1 would overshoot the braking zone.
*   **Soccer/Basketball:** Players sprint, stop dead, juke left, and sprint again. The constant stop-start motion requires Case 4.
*   **Birds in Flight (Erratic):** A hummingbird or a swallow that darts and hovers. Linear prediction fails here.

### 3. The Downside: Battery and Stability
Why not use this all the time?
*   **Instability:** If you use Case 4 on a subject moving at a steady speed (like a marathon runner), the focus might "jitter" slightly because the camera is constantly looking for speed changes that aren't happening. It makes the focus slightly less confident on steady subjects.
*   **Computational Load:** It requires more intensive calculation from the DIGIC X processor, though the impact on battery is negligible compared to screen brightness or 40fps shooting.

### Summary
**Use Case 4 when:**
*   The subject is changing speed rapidly (Braking/Accelerating).
*   The subject is moving in erratic, non-linear patterns (Sports, frantic wildlife).

**Avoid Case 4 when:**
*   The subject is moving steadily (Track and Field running, Trains, Birds gliding). Use Case 1 instead for smoother tracking.