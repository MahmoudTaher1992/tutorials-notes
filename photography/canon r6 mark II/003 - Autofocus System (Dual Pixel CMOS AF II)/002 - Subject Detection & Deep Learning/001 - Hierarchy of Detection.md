Here is the detailed breakdown for the first file in the "Subject Detection & Deep Learning" directory.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/002 - Subject Detection & Deep Learning/001 - Hierarchy of Detection.md`

***

# Hierarchy of Detection (The AF Logic Tree)

The Canon R6 Mark II uses a "Deep Learning" algorithm (a type of Artificial Intelligence trained on millions of images) to identify subjects. However, the camera doesn't just "see" things randomly. It follows a strict **Hierarchy of Detection**. Understanding this priority list helps you understand why the camera focuses on what it focuses on—and how to override it when it's wrong.

### 1. The Pyramid of Priorities
When "Subject Detection" is enabled, the camera evaluates the scene in this order:

1.  **Level 1: The Eye** (Highest Priority)
    *   If the camera sees an eye (human or animal), it will pinpoint focus on the pupil. This ensures critical sharpness for portraits.
2.  **Level 2: The Face**
    *   If the eye is too small, turned away, or obscured by sunglasses/hair, the camera falls back to detecting the entire Face. It places a box around the head structure.
3.  **Level 3: The Head** (New to R6 II/R3)
    *   If the subject turns around (looking away from the camera) or wears a helmet/mask, the camera looks for the shape of a Head.
    *   *Significance:* This prevents the focus from jumping to the background the moment a soccer player spins around.
4.  **Level 4: The Body / Torso**
    *   If the head is obscured or the subject is too far away to distinguish a head, the camera draws a box around the entire Body.
5.  **Level 5: Contrast/Distance** (Lowest Priority)
    *   If no recognized subject is found, the camera reverts to standard autofocus logic: "Focus on the nearest object with high contrast under the AF point."

### 2. How the User Influences the Hierarchy
You are not a slave to the AI. You can direct it.

*   **The Initial Point:** If you use **1-Point AF** or **Zone AF**, the camera *only* runs the hierarchy inside or near that point.
    *   *Scenario:* A crowd of people.
    *   *Action:* Place your 1-Point box on the person on the far left.
    *   *Result:* The camera ignores the eyes of the 10 other people and runs the Eye > Face > Head logic *only* on the person you selected.
*   **Whole Area AF:** If you use Whole Area AF, the camera scans the entire frame.
    *   *Logic:* It typically prioritizes the **Central Subject** or the **Largest/Closest Subject**.
    *   *Override:* Touching the screen (Touch Tracking) overrides the AI's choice and forces the hierarchy onto the new target.

### 3. "Subject to Detect" Setting (The Filter)
You can filter the hierarchy by telling the camera *what* to look for (AF Menu > Page 1).

*   **People:** The hierarchy applies to Humans only. It will ignore a dog running through the frame.
*   **Animals:** Prioritizes Dogs, Cats, Birds, and Horses. If it sees a Human and a Dog, it chooses the Dog.
*   **Vehicles:** Prioritizes Cars, Motorcycles, Trains, and Aircraft.
    *   *Spot Detection:* Inside the Vehicle mode, there is a sub-hierarchy. It looks for the **Driver's Helmet** (on a motorcycle) or the **Cockpit** (on a Formula 1 car/Plane). If it can't find those, it focuses on the vehicle body.
*   **Auto:** The camera tries to guess. It runs all models simultaneously.
    *   *Risk:* In complex scenes (a rider on a horse), "Auto" might flicker between the Horse's eye and the Human's face. Manual selection is safer.

### 4. Eye Detection: Auto, Left, or Right
Even within the "Eye" level, there is a sub-priority.
*   **Auto (Default):** Focuses on the eye closest to the camera (standard photography rule).
*   **Manual Selection:** You can map a button to toggle **Right Eye / Left Eye**.
    *   *Use Case:* An artistic portrait where you deliberately want the *far* eye in focus, or if the camera keeps jumping to the wrong eye because of hair/bangs covering the near one.

### Summary
The R6 Mark II is always asking: **"Can I see an eye?"**
*   **Yes:** Focus on Eye.
*   **No:** **"Can I see a Face?"**
*   **No:** **"Can I see a Head?"**
*   **No:** **"Can I see a Body?"**

Your job as the photographer is to use the **AF Area** (the starting box) to tell the camera *which* hierarchy to care about in a busy scene.