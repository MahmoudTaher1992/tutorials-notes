Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/001 - Shutter Mechanisms/006 - Anti-Flicker Shooting (50Hz/60Hz lights).md`

***

# Anti-Flicker Shooting (50Hz/60Hz Lights)

Indoor photography—specifically in gymnasiums, stadiums, and offices—is often plagued by inconsistent exposures and strange colors. This is caused by the invisible pulsing of artificial lights connected to AC power. The R6 Mark II features a dedicated **Anti-Flicker Shooting** mode to solve this.

### 1. The Physics of Light Flicker
To the naked eye, a gym light looks continuous. To a high-speed sensor, it is strobing.
*   **AC Power:** Electricity cycles at 60Hz (North America) or 50Hz (Europe/Asia).
*   **The Pulse:** Lights typically pulse at twice that frequency (120Hz or 100Hz). This means the light brightens and dims 120 times every second.
*   **The Problem:**
    *   If you take a photo at **Peak Brightness**, the image is white and properly exposed.
    *   If you take a photo in the **Valley (Dimness)**, the image is underexposed and often shifts color (green or magenta) depending on the bulb gas.
    *   *Result:* In a burst of 10 photos of a basketball player, 3 are perfect, 3 are dark/orange, and 4 are weirdly muddy.

### 2. How Canon's Anti-Flicker Works
When you enable **Anti-Flicker Shooting** (Shoot Menu > Page 2), the R6 Mark II utilizes its metering sensor to analyze the light source.

1.  **Detection:** The camera detects the rhythm of the flicker (e.g., 100Hz or 120Hz).
2.  **Timing Adjustment:** When you fully press the shutter button, the camera does **not** fire instantly. It waits a fraction of a millisecond.
3.  **Synchronization:** It forces the shutter to open *exactly* at the moment of peak brightness.
4.  **Consistency:** This ensures that every single frame in a burst has identical exposure and white balance, saving hours of post-processing correction.

### 3. The Trade-Off: Speed Lag
You cannot get something for nothing. Enabling Anti-Flicker introduces two penalties:

*   **Shutter Lag:** Because the camera has to "wait" for the peak of the light cycle, there is a tiny, perceptible delay between pressing the button and the shutter firing.
*   **Reduced Burst Rate:**
    *   In **Mechanical Shutter**, the 12 fps burst speed might drop to roughly **6-8 fps**.
    *   *Why:* The camera has to pause slightly between *every single frame* to re-sync with the light pulse. It breaks the mechanical rhythm.

### 4. Mode Compatibility
The R6 Mark II improves on previous cameras regarding which modes support this feature.

*   **Mechanical Shutter:** Fully Supported. This is the most reliable way to use Anti-Flicker.
*   **Electronic First Curtain:** Fully Supported.
*   **Electronic Shutter:** Supported (Basic).
    *   *Note:* In previous cameras (like the EOS R), you could not use Anti-Flicker with the Electronic Shutter. The R6 Mark II *can*, but it is generally less effective than Mechanical because the "Scan" of the electronic shutter takes longer than the "Pulse" of the light, potentially leading to banding even if timed correctly.

### 5. When to Turn It OFF
Anti-Flicker should not be left on permanently.

*   **Outdoors:** The sun uses DC (Direct Current) logic—it does not flicker. Leaving this setting on outdoors wastes battery processing power and might introduce unnecessary lag.
*   **Flash Photography:** If you are controlling the light with Speedlites, the ambient flicker matters less (unless you are dragging the shutter).
*   **Maximum Speed Required:** If catching the exact millisecond of action is more important than perfect color (e.g., the ball hitting the bat), turn Anti-Flicker OFF to minimize shutter lag.

### Summary
**Anti-Flicker Shooting** is a workflow savior for:
*   Indoor Sports (Basketball, Volleyball).
*   Corporate Events in fluorescent-lit offices.
*   Weddings in old churches with bad LED retrofits.

**Strategy:** Turn it on, take a test burst. If the exposure is consistent, keep it. If the frame rate drops too low for your subject, turn it off and accept the post-processing work later.




Here is the detailed breakdown for the final file in the "Shutter Mechanisms" directory.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/001 - Shutter Mechanisms/007 - High-Frequency Anti-Flicker (Fine-tuning shutter).md`

***

# High-Frequency Anti-Flicker (Fine-tuning Shutter)

While standard Anti-Flicker (discussed in the previous file) deals with 50Hz/60Hz mains power, modern venues are now using **High-Frequency LED** signage, billboards, and stage lighting. These pulse at erratic speeds (e.g., 780.4 Hz or 1500.2 Hz) causing severe horizontal banding that standard tools cannot fix. The R6 Mark II inherits a flagship feature from the EOS R3 called **High-Frequency Anti-Flicker** (HF Anti-Flicker) to solve this.

### 1. The Problem: LED Banding
Standard fluorescent lights pulse slowly. High-end LEDs pulse thousands of times per second.
*   **The Artifact:** Because the pulse is faster than the shutter speed, you get multiple bands of "Light/Dark/Light/Dark" across a single image.
*   **Standard Shutter Limits:** Standard cameras adjust shutter speed in 1/3 stops (e.g., 1/500 -> 1/640 -> 1/800).
*   **The Mismatch:** If the LED flickers at **1/666.6s**, neither 1/640s nor 1/800s will sync with it. You will *always* have banding.

### 2. The Solution: Variable Shutter Precision
HF Anti-Flicker unlocks the ability to adjust the shutter speed in incredibly fine increments—down to the decimal point.

*   **Mode Activation:** You must enable **HF Anti-Flicker Shooting** in the menu (Shoot Menu > Page 2).
    *   *Note:* This switches the camera into a special Tv or M mode behavior.
*   **Precision:** Instead of 1/3 stops, you can adjust the shutter to fit the light.
    *   Example: You can set the shutter to **1/666.6s** or **1/1204.5s**.
*   **The Result:** By matching the shutter speed *exactly* to the frequency of the LED pulse, the banding disappears completely.

### 3. Automatic Detection (The Magic Trick)
Manually guessing if a light is 800Hz or 805Hz is impossible for a human. The R6 Mark II can do this automatically.

1.  **Enable HF Anti-Flicker.**
2.  **Press the "Info" button** (or the mapped "Detect" button on screen).
3.  **Wait:** The camera will point the sensor at the scene and record a brief stream of data.
4.  **Calculation:** The DIGIC X processor analyzes the flicker pattern in the readout.
5.  **Application:** The camera will present you with suggested shutter speeds (e.g., "Yes, the lights are flickering at 1/803.4s").
6.  **Confirm:** Select the suggested speed, and the banding on the screen will vanish instantly.

### 4. Use Cases
This is a niche but professional-grade feature.

*   **Concerts:** Photographing a singer in front of a giant LED video wall. Without HF Anti-Flicker, the video wall will look striped or glitched.
*   **Sports with LED Perimeter Boards:** In soccer or basketball, the digital ads on the sidelines often band. This fixes the background distraction.
*   **Silent Shutter Banding:** If you are forced to use the Electronic Shutter (for silence) in an environment with tricky LEDs, this feature can sometimes mitigate the banding artifacts that Electronic Shutter usually exacerbates.

### 5. Limitations
*   **Video Mode:** HF Anti-Flicker is primarily a *stills* feature (Tv/M modes). For video, you use "Clear Scan" (a similar concept found in Cinema cameras, available as "Tv" fine-tuning in R6 II video mode).
*   **Light Changes:** If the venue changes the refresh rate of the lights (e.g., a concert lighting board changes scenes), your tuned shutter speed might stop working, and you have to re-detect.

### Summary
**High-Frequency Anti-Flicker** is the "Nuclear Option" for bad lighting.
*   Use **Standard Anti-Flicker** for old gym lights (100Hz/120Hz).
*   Use **HF Anti-Flicker** when dealing with LED Video Walls, digital signage, or stage lights that create thin, rapid horizontal stripes.
*   Let the camera's **Auto-Detect** do the math for you.

***
**This concludes the "Shutter Mechanisms" directory.**
We are now ready to move to **002 - Image Quality & Formats**.