Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/002 - Image Quality & Formats/002 - JPEG vs. HEIF (10-bit HDR workflow).md`

***

# JPEG vs. HEIF (10-bit HDR Workflow)

For decades, the standard choice for "ready-to-use" images has been JPEG. The R6 Mark II introduces a modern competitor: **HEIF (High Efficiency Image File)**. This is not just a different file extension; it is a fundamental shift in color science and dynamic range, unlocking the ability to capture true **HDR (High Dynamic Range)** still images for modern displays.

### 1. The Standard: JPEG (8-bit)
*   **Architecture:** JPEG is an 8-bit format. It can display 256 shades of Red, 256 shades of Green, and 256 shades of Blue.
    *   **Total Colors:** Approx. 16.7 million.
*   **Gamma:** It uses a standard gamma curve (sRGB or AdobeRGB) designed for standard monitors and paper prints.
*   **The Limitation:** Because it only has 8 bits of data, if you capture a sunset with a JPEG, the smooth transition from bright orange to dark blue often shows "Banding" (visible steps between colors) because there aren't enough shades to render the gradient smoothly.

### 2. The Challenger: HEIF (10-bit)
When you enable **HDR PQ** on the R6 Mark II, the camera stops saving .JPG files and starts saving .HIF (HEIF) files.
*   **Architecture:** HEIF is a 10-bit format. It can display 1,024 shades per channel.
    *   **Total Colors:** Approx. **1.07 Billion**.
*   **Efficiency:** Despite holding significantly more color and light data, HEIF files are often *smaller* than JPEGs because of superior compression algorithms (based on H.265 video tech).
*   **The Gamma (PQ):** It uses the **Perceptual Quantizer (PQ)** curve. This is designed for HDR TVs and bright displays (like newer iPhones or MacBook Pros). It can record highlights that are brighter than "Paper White" without clipping them.

### 3. Visual Difference: Why use HEIF?
*   **JPEG Reality:** If you shoot a bride in a white dress in bright sun, the bright details on the dress might clip to pure white #FFFFFF. Once clipped, that texture is gone forever in the JPEG.
*   **HEIF Reality:** The HEIF file can retain that texture because its "White Point" is much higher. On a compatible HDR screen, the dress will actually look *brighter* than the rest of the screen, glowing like real light, while retaining the texture of the lace.

### 4. The Workflow Trap (Compatibility)
HEIF is superior in technology but inferior in compatibility.
*   **The Problem:** If you send a raw .HIF file to a standard Windows PC, an old website, or a printer, it might look flat, grey, or simply fail to open. Most of the internet (Instagram, Facebook) still expects standard JPEGs.
*   **Conversion Required:** To share a HEIF file, you often have to convert it back to JPEG inside the camera or using Canon's software, which defeats the purpose of shooting it unless your final destination is an HDR TV.

### 5. Settings Configuration
To shoot HEIF on the R6 Mark II:
1.  Go to **Shoot Menu (Red) > Page 2 > HDR PQ Settings**.
2.  Set **HDR PQ** to **ON**.
    *   *Note:* As soon as you do this, the "JPEG" icon in your file format menu will change to "HEIF." You cannot shoot JPEG and HEIF simultaneously. It is one or the other.
3.  **Highlight Tone Priority (D+)** becomes mandatory/active to protect the dynamic range.

### Summary
*   **Stick to JPEG if:** You need files that work everywhere immediately (News, Social Media, delivery to clients who aren't tech-savvy). It is the safe, universal standard.
*   **Switch to HEIF if:** You are creating content specifically for HDR displays (modern phones/TVs) and want to future-proof your images with 1 billion colors and expanded dynamic range. Be prepared for a conversion step if you need to print them.