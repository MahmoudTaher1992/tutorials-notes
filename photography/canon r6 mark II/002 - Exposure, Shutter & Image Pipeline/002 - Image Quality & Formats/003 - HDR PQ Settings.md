Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/002 - Image Quality & Formats/003 - HDR PQ Settings.md`

***

# HDR PQ Settings

**HDR PQ (Perceptual Quantizer)** is not just a "mode"; it is a distinct imaging pipeline that changes how the R6 Mark II processes light. It abandons the traditional "Scene-Referred" exposure logic of the last 100 years and adopts a "Display-Referred" logic designed for modern, high-brightness screens. Configuring this correctly is essential for getting the most out of 10-bit HEIF files and HDR video.

### 1. The Core Concept: What is PQ?
Standard cameras use "Gamma Correction" to squish the massive dynamic range of reality into a small file.
*   **Traditional Gamma:** Treats "White" as the brightness of a piece of paper. Anything brighter than paper is just clipped to white.
*   **PQ (Perceptual Quantizer):** An industry standard (SMPTE ST 2084) used in Dolby Vision and HDR10 movies. It treats "White" as actual light intensity (measured in nits). It can differentiate between a "White T-Shirt" (diffuse white) and the "Sun reflecting off a car" (specular highlight), making the latter significantly brighter on screen without losing color.

### 2. Enabling HDR PQ
To activate this pipeline:
*   **Menu Location:** Shoot Menu (Red) > Page 2 > **HDR PQ Settings**.
*   **Effect:** Turning this **ON** changes the following system behaviors immediately:
    1.  **Stills:** Changes output from 8-bit JPEG to **10-bit HEIF**.
    2.  **Video:** Changes output to 10-bit HDR PQ (H.265), ready for instant playback on HDR TVs without grading (unlike C-Log 3).
    3.  **ISO Base:** The base ISO shifts to **ISO 200** because the sensor needs extra headroom to protect the highlights.

### 3. Highlight Tone Priority (D+) Integration
When HDR PQ is active, the setting **Highlight Tone Priority** is often forced or strongly recommended.
*   **Why:** PQ is all about highlight retention. The camera intentionally underexposes the sensor slightly (analog gain) and boosts the mid-tones digitally to ensure that bright clouds or lamps don't clip.
*   **Visual Check:** You will see "D+" in the viewfinder, indicating this dynamic range protection is active.

### 4. Viewing Assist (The Most Critical Setting)
Since the EVF and rear LCD of the R6 Mark II are not perfectly calibrated 1,000-nit HDR reference monitors, the "Raw" PQ image can look flat and grey on the camera screen (because the camera is trying to show you a dynamic range the screen can't physically display).

*   **View Assist:** Found in the HDR PQ menu.
*   **Setting:** **View Assist: ON**.
*   **Function:** This applies a temporary LUT (Look Up Table) to the EVF/LCD feed so the image looks "Normal" (contrast and saturation) to your eye while shooting, even though the file being recorded is the flat/broad PQ data.
*   **Warning:** If you turn View Assist OFF, you might think your image is underexposed and mistakenly raise your ISO, ruining the highlight data.

### 5. Shooting HDR Video vs. HDR Stills
*   **For Stills:** Use HDR PQ if you want "Realism" on an iPhone screen. The photos will look incredibly lifelike with glowing lights.
*   **For Video:** HDR PQ acts as an "Instant HDR" workflow.
    *   *Difference from Log:* C-Log 3 requires heavy color grading in post. HDR PQ video looks good straight out of the camera *if viewed on an HDR TV*. If you upload HDR PQ video directly to standard YouTube or Instagram without conversion, it will look washed out and grey.

### Summary
**HDR PQ** is the "Future Mode."
*   **Enable it** to capture 10-bit images/video with 1 billion colors and blindingly bright highlights.
*   **Ensure "View Assist" is ON** so you can compose comfortably.
*   **Remember the ISO 200 floor:** You lose ISO 100, so you might need stronger ND filters in bright sunlight to maintain f/1.2 or f/1.8 apertures.