Here is the detailed breakdown for the first file in the "RAW Burst Mode" directory.

**Target File:** `004 - Drive Modes & Burst Shooting/002 - RAW Burst Mode/001 - Pre-Shooting Buffer.md`

***

# RAW Burst Mode: Pre-Shooting Buffer

**RAW Burst Mode** is a specialized container format separate from standard drive modes. Its headline feature is **Pre-Shooting**, a "Time Machine" function that allows you to capture images *before* you fully press the shutter button. This is a game-changer for wildlife and sports photographers reacting to unpredictable action.

### 1. How Pre-Shooting Works
*   **Activation:** You must specifically enable **RAW Burst Mode** in the Shoot Menu (Red > Page 2) and set **Pre-shooting** to **ON**.
*   **The Mechanism:**
    *   When you **Half-Press** the shutter button (acquire focus), the camera begins recording images silently into its internal buffer loop.
    *   It holds **0.5 seconds** worth of images (approx. 15 shots at 30fps) in memory.
    *   As new images come in, old ones are pushed out and deleted.
*   **The Trigger:**
    *   When you finally **Full-Press** the shutter, the camera takes the images *currently in the loop* (the past 0.5 seconds) and commits them to the memory card, followed by the images you capture normally while holding the button.

### 2. The Use Case: "Reaction Time Compensation"
Human reaction time is roughly 0.2 seconds (visual stimulus -> brain -> finger muscle).
*   **Scenario:** A bird sitting on a branch. You are waiting for takeoff.
    *   **Normal Camera:** You see the wings open. You press the button. By the time the shutter opens, the bird is already out of the frame. You missed the takeoff.
    *   **R6 II with Pre-Shooting:** You see the wings open. You press the button. The camera saves the 0.5 seconds *before* you pressed. You capture the exact moment the feet left the branch.

### 3. Technical Constraints
While powerful, this mode has limitations compared to standard shooting.
*   **Fixed Resolution:** Captures full 24MP images.
*   **Fixed Shutter:** Uses Electronic Shutter only (Rolling shutter risks apply).
*   **Frame Rate:** Generally locked to **30 fps** (not 40fps) in this specific mode.
*   **The File Format:** It does **not** save individual .CR3 files to the card. It saves one massive **"Roll" file** (extension .CR3, but containing a sequence). You must unpack this roll later (discussed in the next file).

### 4. Battery Drain
*   **Warning:** When Pre-Shooting is active and you are half-pressing the button, the camera is processing and buffering 30 full-resolution images every second continuously.
*   **Result:** This drains the battery significantly faster than normal standby. Do not walk around holding the half-press for hours. Use it only when the action is imminent.

### Summary
**Pre-Shooting** allows you to photograph the past.
*   **Enable it** for: Kingfishers diving, batters hitting a ball, arrows leaving a bow.
*   **Disable it** for: General shooting, to save battery and avoid dealing with complex "Roll" files.
*   **Key Stat:** It saves **0.5 seconds** (approx 15 frames) prior to the click.