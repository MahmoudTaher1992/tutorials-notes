Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/001 - Shutter Mechanisms/003 - Fully Electronic Shutter (40 fps) - Rolling Shutter Artifacts.md`

***

# Fully Electronic Shutter (40 fps): Rolling Shutter Artifacts

The headline feature of the R6 Mark II is its ability to shoot **40 frames per second (fps)**. To achieve this, the camera must abandon physical curtains entirely and rely on the **Fully Electronic Shutter**. While this unlocks incredible speed and complete silence, it introduces a digital distortion known as "Rolling Shutter."

### 1. How the Electronic Shutter Works (The "Scanner" Analogy)
Unlike a Global Shutter (found in high-end cinema cameras like the RED Komodo or the Sony a9 III), which captures every pixel simultaneously, the R6 Mark II uses a **Rolling Shutter**.

*   **The Process:** The sensor activates row by row, starting from the top and scanning down to the bottom.
*   **The Time Gap:** It takes time for the readout signal to travel from the top line to the bottom line. On the R6 Mark II, this "scan time" is approximately **1/70th to 1/80th of a second** (~12-14 milliseconds).
*   **The Consequence:** By the time the camera records the bottom of the image, the subject has moved relative to where it was when the camera recorded the top of the image.

### 2. Visual Artifacts: What Does "Rolling Shutter" Look Like?
When using the 40fps Electronic Shutter, you must watch for three specific types of distortion:

**A. The Skew (The "Leaning Tower" Effect)**
*   **Scenario:** You are panning quickly to follow a car or a bird flying past you.
*   **The Artifact:** Vertical background objects (trees, fence posts, buildings) will appear slanted diagonally.
    *   *Why:* You moved the camera to the right while the sensor was still scanning down. The top of the tree was recorded at position A, but by the time the scan hit the bottom, the camera had moved, recording the bottom of the tree at position B.
*   **R6 II Performance:** Significantly better than the original R6 or EOS R, but still visible in aggressive pans.

**B. The Bend (The "Rubber Golf Club")**
*   **Scenario:** The camera is stationary, but the subject is moving incredibly fast (e.g., a golf swing, baseball bat, or tennis serve).
*   **The Artifact:** The golf club will look curved like a banana.
    *   *Why:* The club head is moving faster than the sensor scan. The sensor captures the handle, then slightly lower down the shaft, then the head, but the head has moved significantly in that split second.

**C. The Segmentation (The "Propeller" Problem)**
*   **Scenario:** Shooting airplanes or drones.
*   **The Artifact:** Propeller blades will look detached, warped, or completely invisible.
*   **Rule:** Never use Electronic Shutter for propeller aircraft unless you are specifically looking for abstract art.

### 3. R6 Mark II vs. The Competition
Understanding where the R6 Mark II sits in the hierarchy helps manage expectations.

*   **Standard Cameras (e.g., EOS R, RP, 5D IV Live View):** Very slow readout (~1/30s). Terrible rolling shutter.
*   **R6 Mark II:** Fast readout (~1/70s).
    *   *Verdict:* Usable for 90% of sports (Running, Football, Basketball). The distortion is there, but often subtle enough to be ignored.
*   **Stacked Sensors (e.g., EOS R3, Sony A9, Nikon Z9):** Ultra-fast readout (~1/200s or faster).
    *   *Verdict:* Virtually no rolling shutter.
*   **Conclusion:** The R6 Mark II is a "Speed Demon with an Asterisk." You get flagship frame rates (40fps), but you do not get flagship sensor readout speeds.

### 4. When to Accept the Risk
Despite the artifacts, the Electronic Shutter is often the best choice.

*   **Silence:** In a church, a golf tournament, or on a film set, the mechanical shutter is banned. You *must* use Electronic.
*   **Vibration Free:** For super-telephoto work (600mm+), the lack of mechanical vibration yields sharper images if the subject isn't moving fast enough to cause distortion.
*   **The "Moment":** 40fps gives you roughly 3x more frames than Mechanical (12fps). In sports, capturing the *exact* millisecond the ball hits the header is often worth a tiny bit of background skew.

### Summary
The **Fully Electronic Shutter** on the R6 Mark II is a powerful tool that requires a "Risk Assessment" before use.
*   **Safe:** Running humans, birds in flight (gliding/banking), candid portraits, weddings.
*   **Risky:** Golf swings, baseball bats, helicopter rotors, drive-by shots of architecture.

If you see the distortion, your only solution is to switch back to **Mechanical Shutter** (and drop to 12fps).