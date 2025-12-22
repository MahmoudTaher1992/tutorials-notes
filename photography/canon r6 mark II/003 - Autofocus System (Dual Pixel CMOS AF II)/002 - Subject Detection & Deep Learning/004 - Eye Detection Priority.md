Here is the detailed breakdown for the final file in the "Subject Detection & Deep Learning" directory.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/002 - Subject Detection & Deep Learning/004 - Eye Detection Priority.md`

***

# Eye Detection: Left/Right Priority

Within the hierarchy of subject detection, finding an "Eye" is the gold standard. However, simply finding *an* eye is not always enough. In portrait photography, the rule is strict: **The eye closest to the camera must be in focus.** The R6 Mark II gives you granular control over exactly which eye the camera selects.

### 1. The Default Behavior (Auto)
When Eye Detection is enabled (inside the Subject Detection menu), the default behavior is **Auto**.
*   **The Algorithm:** The camera calculates the distance and size of both eyes.
*   **The Choice:** It automatically places the focus box on the eye that appears larger (closest to the lens).
*   **Success Rate:** For 90% of headshots and 3/4 angle portraits, this works perfectly. The camera is smart enough to know that the near eye is the critical one.

### 2. The Problem Scenarios
Where does "Auto" fail?
*   **Scenario A: The Hair Curtain:** The subject has bangs or hair sweeping across one side of their face. The camera might struggle to see the "Near" eye through the hair and mistakenly jump to the "Far" eye, which is clearly visible.
*   **Scenario B: Profile Confusion:** At extreme side angles, the eyelashes of the near eye might confuse the sensor, causing it to grab the high-contrast white of the far eye.
*   **Scenario C: Creative Intent:** Sometimes, you *want* to break the rules. You might want to focus on the far eye for an artistic "short lighting" look. "Auto" will fight you on this.

### 3. Manual Eye Selection (The Toggle)
You can manually force the camera to switch eyes.
*   **Method 1: The Joystick (Multi-Controller)**
    *   When the camera detects a face, you will see a box around the active eye and a grey arrow pointing to the other eye.
    *   **Action:** Flick the joystick Left or Right. The focus box jumps instantly to the other eye.
*   **Method 2: The Touch Screen**
    *   Tap on the specific eye you want on the LCD.

### 4. Advanced Customization: The "Eye Detection" Button
Digging into the **Customize Buttons** menu (Orange Tab), you can assign a specific button to **"Eye Detection: Right/Left"**.
*   **Function:** Pressing this button cycles through:
    *   **Auto** -> **Right Eye Only** -> **Left Eye Only**.
*   **Use Case:** This is incredibly powerful for studio portrait photographers.
    *   If you are shooting a model who is consistently posing with their left side to the camera, you can lock the camera to **"Left Eye Only"**.
    *   Now, even if the model turns her head or hair covers her face, the camera will *never* mistakenly jump to the wrong eye. It will hunt for that left eye until it finds it.

### 5. Eye Detection in Animals
This Left/Right logic also applies to **Animal AF**.
*   **Scenario:** Photographing a dog running diagonally toward you.
*   **Logic:** The camera attempts to focus on the near eye.
*   **Override:** You can flick the joystick to switch to the far eye, though this is harder to do in real-time with fast-moving animals compared to posed humans.

### Summary
*   **Leave it on Auto** for most candid and event situations. The R6 Mark II is very good at identifying the near eye.
*   **Use Joystick Override** to fix temporary errors (e.g., hair blocking the eye).
*   **Map a "Right/Left" Button** if you are doing a formal portrait session and want to guarantee absolute consistency on a specific eye without the focus point ever jumping.

***
**This concludes the "Subject Detection & Deep Learning" directory.**
We are now ready to move to **003 - Advanced AF Customization (Servo AF Cases)**.