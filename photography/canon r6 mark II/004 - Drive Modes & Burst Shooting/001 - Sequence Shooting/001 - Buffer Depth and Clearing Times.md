Here is the detailed breakdown for the first file in Part IV.

**Target File:** `004 - Drive Modes & Burst Shooting/001 - Sequence Shooting/001 - Buffer Depth and Clearing Times.md`

***

# Buffer Depth and Clearing Times

The R6 Mark II is a speed demon, capable of 40 frames per second. However, speed is useless if the camera chokes after 1 second. Understanding the **Buffer**—the temporary memory that holds photos before they are written to the card—is critical for managing bursts.

### 1. The Physical Hardware
*   **The Pipeline:** Sensor -> DIGIC X Processor -> **Buffer (RAM)** -> Memory Card.
*   **The Constraint:** The R6 Mark II has a decent buffer size, but it is not infinite. Once the buffer fills, the frame rate drops from 40fps to almost zero (or whatever speed your SD card can write).

### 2. Buffer Capacity (How many shots?)
The number of shots you can take before the camera slows down depends entirely on the **File Format** and **Card Speed**.

*   **Mechanical Shutter (12 fps):**
    *   **RAW:** ~110 shots (~9 seconds of continuous holding).
    *   **C-RAW:** ~1,000+ shots (Effectively infinite).
    *   **JPEG:** Infinite (Until card is full).
    *   *Verdict:* In Mechanical mode, buffer is rarely an issue.

*   **Electronic Shutter (40 fps):**
    *   **RAW:** ~75 shots.
        *   *Duration:* **Less than 2 seconds** of shooting. This is the danger zone. If you press the button too early, the buffer fills before the action finishes.
    *   **C-RAW:** ~190 shots.
        *   *Duration:* **Approx. 4.5 seconds**. This is why C-RAW is recommended for sports.
    *   **JPEG:** ~190+ shots (varies by card).

### 3. Clearing Times (The Recovery)
Once the buffer is full, you cannot view images or change certain settings until it clears. This depends on your **SD Card Speed**.

*   **Scenario:** You shot 75 RAW images (full buffer). Total data = ~2.2 GB.
*   **V60 Card (60 MB/s Write):**
    *   Time to clear: **35+ seconds**.
    *   *Impact:* You are effectively locked out of the camera for half a minute. You will miss the next play.
*   **V90 Card (250 MB/s Write):**
    *   Time to clear: **8-9 seconds**.
    *   *Impact:* You are back in the game much faster.
*   **Recommendation:** If you plan to shoot 40fps RAW, you **must** buy V90 cards. If you shoot 40fps C-RAW or JPEG, V60 cards are acceptable.

### 4. The "Busy" Indicator
*   **Visual:** When the buffer is writing, a small green light flickers on the back, and a "Busy" bar may appear in the viewfinder.
*   **Functionality:**
    *   You *can* continue to shoot short bursts if there is *any* space left in the buffer.
    *   You *cannot* switch to Video mode or enter the main Menu until the buffer is fully clear.

### Summary
*   **Shoot C-RAW** to double your shooting duration at 40fps.
*   **Shoot Mechanical (12fps)** if you need to hold the button down for 10 seconds straight (e.g., a long celebration run).
*   **Invest in V90 Cards** to minimize the "penalty box" time waiting for the buffer to clear.
*   **Discipline:** At 40fps, learn to shoot in "micro-bursts" (0.5 seconds). Do not "spray and pray," or you will hit the wall instantly.