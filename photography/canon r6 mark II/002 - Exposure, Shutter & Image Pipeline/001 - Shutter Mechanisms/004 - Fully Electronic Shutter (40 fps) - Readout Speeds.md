Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/001 - Shutter Mechanisms/004 - Fully Electronic Shutter (40 fps) - Readout Speeds.md`

***

# Fully Electronic Shutter (40 fps): Readout Speeds & Data Depth

While "Rolling Shutter" describes the *visual artifact*, **Readout Speed** describes the *technical cause*. Furthermore, using the electronic shutter on the R6 Mark II involves a hidden trade-off regarding **Bit Depth** and **Dynamic Range** that Canon does not advertise on the box.

### 1. What is Readout Speed?
Readout speed is the time it takes for the image sensor to offload data from the top pixel row to the bottom pixel row.

*   **Mechanical Shutter:** The sensor is exposed all at once (effectively), then read out in the dark.
*   **Electronic Shutter:** The sensor is "open" and reading simultaneously.
*   **The R6 Mark II Benchmark:**
    *   **Original R6:** Approx. 50ms - 60ms (Very slow).
    *   **R6 Mark II:** Approx. **14ms - 15ms** (~1/70th of a second).
    *   **EOS R3 (Stacked):** Approx. 5ms (1/200th of a second).
*   **Significance:** The R6 Mark II is roughly **4x faster** than its predecessor. This massive jump in readout speed is what makes the 40fps mode usable for sports, whereas the original R6's electronic shutter was mostly for static subjects.

### 2. The Hidden Cost: 12-bit vs. 14-bit RAW
To achieve the blistering speed of 40 frames per second, the DIGIC X processor has to make a compromise in data volume.

*   **Mechanical / EFCS:** The camera captures **14-bit RAW** files.
    *   *Data:* 16,384 tonal values per channel.
    *   *Result:* Maximum Dynamic Range, cleanest shadows, best recovery potential.
*   **Electronic Shutter (High Speed):** The camera drops to **12-bit RAW** files.
    *   *Data:* 4,096 tonal values per channel.
    *   *Result:* You lose data in the deep shadows.
*   **Practical Impact:**
    *   If you are shooting Sports/Wildlife at ISO 1600+, you will **not notice** the difference. The noise floor at high ISO masks the bit-depth loss.
    *   If you are shooting a Landscape at ISO 100 with the Electronic Shutter and try to lift the shadows by 5 stops, you will see more noise and posterization than if you had used the Mechanical Shutter.

### 3. Frame Rate Options (H+, H, Low)
The readout speed (~14ms) is constant regardless of how many frames per second you shoot.

*   **High Speed Continuous + (40 fps):**
    *   The camera reads the sensor, waits a tiny fraction of a millisecond, and reads it again.
    *   *Buffer Fill:* Fills the buffer in roughly 1.5 - 2 seconds (depending on card speed).
*   **High Speed Continuous (20 fps):**
    *   Often the "Smart" choice. 20fps is still incredibly fast (faster than the 1D X Mark III), but it doubles your shooting duration before the buffer fills and makes culling (selecting) photos much easier later.
*   **Low Speed:**
    *   Useful for casual shooting where you want silence but don't want 400 photos of a single smile.

### 4. Variable Shutter Speed Limits
Because the sensor takes ~1/70th of a second to read, there are hard limits on shutter speeds.

*   **Longest Exposure:** In Electronic Shutter mode, the longest exposure is often limited (typically 0.5 seconds), though recent firmware allows longer times.
*   **Shortest Exposure:** The R6 Mark II can reach **1/16,000s** in Electronic Shutter (compared to 1/8,000s in Mechanical).
    *   *Advantage:* This allows you to shoot f/1.2 lenses in blindingly bright sunlight without a Neutral Density (ND) filter, provided you accept the potential bokeh artifacts.

### 5. Artificial Lighting and Banding
The Readout Speed dictates how the camera handles flickering artificial lights (LEDs, Fluorescents).

*   **The Issue:** If the light flickers at 100Hz (twice the mains frequency of 50Hz) and the readout takes 14ms, the light might turn on and off *during* the scan of a single image.
*   **The Look:** This creates thick horizontal bands of color or exposure across the image.
*   **Mitigation:** The fast 14ms readout of the R6 Mark II reduces the *severity* of banding compared to older cameras, but it does not eliminate it. In difficult lighting (stadiums, gyms), Mechanical Shutter is still safer.

### Summary
The Electronic Shutter on the R6 Mark II is an engineering marvel of efficiency, offering 40fps by accelerating the readout to ~14ms. However, this speed comes at a price: **Files drop to 12-bit depth**, reducing dynamic range recoverability.
*   **Strategy:** Use Electronic Shutter for speed and silence. Use Mechanical Shutter for maximum image quality (14-bit) and dynamic range.