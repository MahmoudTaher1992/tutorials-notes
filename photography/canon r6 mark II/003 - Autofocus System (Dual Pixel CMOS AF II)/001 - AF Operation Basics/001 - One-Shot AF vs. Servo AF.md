Here is the detailed breakdown for the first file in Part III.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/001 - AF Operation Basics/001 - One-Shot AF vs. Servo AF.md`

***

# One-Shot AF vs. Servo AF (Statics vs. Dynamics)

The Canon R6 Mark II's autofocus system is built on **Dual Pixel CMOS AF II** technology. Before diving into advanced subject detection (eyes/cars), you must fundamentally choose how the focus engine behaves regarding time and movement. This choice is between **One-Shot** and **Servo**.

### 1. The Core Distinction
*   **One-Shot AF:** Designed for **Stationary Subjects** (Landscapes, Still Life, Posed Portraits).
*   **Servo AF:** Designed for **Moving Subjects** (Sports, Wildlife, Candid Events, Video).

In the era of mirrorless cameras, the line has blurred, but the mechanical logic remains distinct.

### 2. One-Shot AF (Green Box)
When set to One-Shot:
*   **The Lock:** When you half-press the shutter (or AF-ON button), the camera calculates focus once. Once it achieves focus, it **Locks**.
*   **The Indicator:** The AF point turns **Green** and the camera beeps (if enabled).
*   **Focus Priority:** By default, the camera operates in "Focus Priority."
    *   *Meaning:* The shutter will **refuse to fire** unless the camera confirms the image is in focus. If the lens is hunting, you can mash the button all you want; no photo will be taken.
*   **The Risk:** If you lock focus on a person, and they lean forward 2 inches *after* the beep but *before* you fully click, the photo will be slightly out of focus. The camera does not update the distance after the lock.

### 3. Servo AF (Blue Box)
When set to Servo:
*   **The Tracking:** When you engage AF, the camera calculates focus continuously. It updates the lens position dozens (or hundreds) of times per second.
*   **The Indicator:** The AF point turns **Blue**. It never turns Green because focus is never "finished"; it is always working.
*   **Release Priority:** By default, the camera operates in "Release Priority."
    *   *Meaning:* The shutter will fire whenever you press the button, even if the image is blurry. The camera assumes capturing the "moment" is more important than perfect sharpness.
*   **Prediction:** Servo AF uses predictive algorithms. If a car is moving toward you at 50mph, the camera doesn't focus on where the car *is*; it focuses on where the car *will be* when the shutter curtains actually open milliseconds later.

### 4. Subject Detection in Both Modes
A common misconception is that "Eye Tracking" only works in Servo. This is false.

*   **In One-Shot:** The camera *will* find the eye and lock onto it. However, if the person walks toward you, the focus stays stuck at the original distance.
*   **In Servo:** The camera finds the eye and follows it in 3D space, adjusting focus distance in real-time.
*   **Recommendation:** For 95% of human subjects (even posed portraits), **Servo AF is superior**. Humans effectively never stay perfectly still; they sway, breathe, and adjust weight. Servo corrects for this micro-movement; One-Shot does not.

### 5. AI Focus AF (The "Auto" Mode)
There is a third mode called **AI Focus AF**.
*   **Behavior:** The camera starts in One-Shot. If it detects significant subject movement, it automatically switches itself to Servo.
*   **Pro Tip:** Avoid this mode. It adds a delay. The camera has to "think" about whether the subject is moving before it starts tracking. It is faster and more reliable to manually select Servo or One-Shot based on your intent.

### 6. Configuration for Professionals (Back Button Focus)
If you use **Back Button Focus** (removing AF start from the Shutter button and assigning it only to the AF-ON button):

*   **You rarely need One-Shot mode.**
*   **Why:** If you are in Servo mode and holding the AF-ON button, the camera tracks (Servo behavior). If you want to lock focus (One-Shot behavior), you simply **let go** of the AF-ON button. The focus stops moving (locks).
*   **Result:** You get the benefits of both modes without ever entering the menu to switch them.

### Summary
*   **Use One-Shot AF** for Landscapes, Architecture, and Product photography where nothing moves and you want the "Focus Priority" guarantee that the image is sharp.
*   **Use Servo AF** for literally everything else (People, Animals, Sports).
*   **Visual Check:** Green Box = Locked (Static). Blue Box = Tracking (Active).