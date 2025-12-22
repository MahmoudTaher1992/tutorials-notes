Here is the detailed breakdown for the next file in your structure.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/001 - AF Operation Basics/002 - AF Area Modes.md`

***

# AF Area Modes (Spot, 1-point, Expand, Flexible Zone, Whole Area)

While "Servo vs. One-Shot" dictates *when* the camera focuses, the **AF Area Mode** dictates *where* it looks. The R6 Mark II offers a highly customizable array of zones. Choosing the right size box is critical: too small, and you'll lose a fast bird; too big, and the camera might focus on the tree branch in the foreground.

### 1. Spot AF vs. 1-Point AF
These are the precision tools.
*   **1-Point AF (Standard):** A single square box.
    *   *Use Case:* Standard portraits where you want to place the box specifically on an eye, or product photography.
*   **Spot AF (Pinpoint):** A tiny box inside the standard box.
    *   *Use Case:* Shooting through obstacles (e.g., a lion behind tall grass, or a bird deep in a bush).
    *   *Warning:* Spot AF is **slower**. Because the sample area is so small, the camera gets less contrast data to calculate distance. Do not use this for fast-moving sports; the lens will hunt.

### 2. Expand AF Area (Cross and Surround)
These are "Helper" modes. They look like a 1-Point box with smaller squares around it.
*   **Expand AF Area (Cross):** Uses the center point plus 4 adjacent points (Up/Down/Left/Right).
*   **Expand AF Area (Surround):** Uses the center point plus all 8 surrounding points.
*   **The Logic:** You aim the center point at the subject. If the subject moves slightly and leaves the center point, the "helper" points take over instantly to keep focus.
*   **Use Case:** Sports where the subject is erratic but mostly predictable (e.g., a runner coming toward you). It is more forgiving than 1-Point.

### 3. Flexible Zone AF (1, 2, and 3)
This is a massive upgrade in the R6 Mark II over the original R6. Instead of fixed "Zone" sizes, you can create custom rectangular shapes.
*   **Customization:** You can define the height and width of the zone.
    *   *Example 1 (The "Runway"):* A tall, thin vertical column. Perfect for a person walking down a specific aisle at a wedding.
    *   *Example 2 (The "Horizon"):* A wide, short horizontal band. Perfect for a sprinter running across the frame or a car on a track.
*   **Subject Tracking:** Inside these zones, the Subject Detection (Eye/Face) has priority. The camera will only look for eyes *inside* the box you drew. This prevents the camera from jumping to faces in the crowd background.

### 4. Whole Area AF (Tracking)
*   **The Logic:** The camera uses the entire sensor (100% x 100%) to find subjects.
*   **Behavior:**
    *   If Subject Detection is ON: It will scan the whole scene for people/animals/vehicles and lock onto the nearest/most prominent one.
    *   If Subject Detection is OFF: It effectively becomes "Auto Area," usually focusing on the nearest high-contrast object.
*   **Tracking Override:** Even in Whole Area mode, you will see a white tracking box. You can tap the screen or use the joystick to tell the camera, "Track *this* specific object," and it will follow it anywhere in the frame.

### 5. Subject Tracking Priority (The Global Setting)
There is a setting often confused with Area Modes called **"Subject Tracking"** (AF Menu > Page 1).
*   **ON (Default):** Even if you are using a small "1-Point AF" box, once the camera finds a subject (like a face) under that point, it can leave the box and follow the subject across the entire screen.
    *   *Advantage:* You use the point to "tag" the target, and the camera takes over.
*   **OFF:** The camera will **never** track the subject outside your selected AF Area.
    *   *Use Case:* If you are shooting a soccer game and want to focus *only* on the goal keeper. If players run in front of the goal, the camera won't follow them; it stays rigidly in your zone.

### Summary
*   **Static/Precise Work:** Use **1-Point AF**.
*   **Through Obstacles:** Use **Spot AF** (but beware of speed).
*   **Erratic Motion (Sports):** Use **Expand AF (Surround)** or custom **Flexible Zones**.
*   **"Trust the AI" Mode:** Use **Whole Area AF** and let the Deep Learning algorithms find the subject for you.