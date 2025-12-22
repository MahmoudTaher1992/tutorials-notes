Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/001 - Shutter Mechanisms/005 - Fully Electronic Shutter (40 fps) - Impact on Flash Sync.md`

***

# Fully Electronic Shutter: Impact on Flash Sync

One of the most significant technical upgrades of the R6 Mark II over its predecessor (the original R6) is the ability to fire a flash while using the Fully Electronic Shutter. However, this feature comes with severe physical limitations imposed by the sensor's readout speed.

### 1. The Physics of Synchronization
To understand the limitation, you must understand how "Sync" works.
*   **Flash Duration:** A typical Speedlite pop is incredibly fast (approx. 1/10,000th of a second). It is effectively instantaneous.
*   **The Window of Opportunity:** For the flash to light the entire image, the **entire sensor must be open (exposing)** at the exact moment the flash fires.
*   **The Electronic Problem:** As discussed in previous sections, the Electronic Shutter is a "Scanner." It scans line-by-line. At no point during a high-speed scan is the entire sensor "open" simultaneously *unless the shutter speed is slow enough to cover the scan time.*

### 2. The 1/50s Speed Limit
Because the R6 Mark II takes roughly 1/70s to scan the sensor electronically:
*   **Max Sync Speed:** The camera limits your shutter speed to roughly **1/50th of a second** (or slower) when using flash in Electronic Shutter mode.
*   **Comparison:**
    *   **Mechanical Shutter:** Syncs at **1/200s** (or 1/250s).
    *   **Electronic Shutter:** Syncs at **1/50s**.
*   **The Consequence:** 1/50s is notoriously slow for handheld photography. It allows significant "ambient ghosting" (motion blur from the room lights) to mix with the sharp flash image.

### 3. No High-Speed Sync (HSS)
This is the deal-breaker for outdoor portrait photographers.
*   **HSS Mechanism:** High-Speed Sync works by pulsing the flash thousands of times per second to act like a continuous light, allowing you to shoot at 1/4000s or 1/8000s.
*   **R6 Mark II Limitation:** The R6 Mark II **disables High-Speed Sync** when in Fully Electronic Shutter mode.
*   **Implication:** You cannot use the Silent Shutter (Electronic) to take a portrait at f/1.2 in bright sunlight with fill flash. You **must** switch to Mechanical or EFCS to use HSS.

### 4. Why Use Flash with Electronic Shutter?
If the sync speed is slow and HSS is disabled, why did Canon add this feature?

*   **1. Macro Photography (Focus Stacking):**
    *   When shooting insects or jewelry, you often need flash.
    *   You also need zero vibration (Electronic Shutter).
    *   The subject is usually still, so the 1/50s shutter speed is acceptable.
*   **2. Continuous Shooting Volume:**
    *   Mechanical shutters wear out. If you are doing a high-volume studio product shoot (e.g., e-commerce, photographing 500 pairs of shoes), using Electronic Shutter saves the life of your mechanical mechanism.
*   **3. Absolute Silence:**
    *   In very specific scenarios (e.g., a film set taking still photos where a silent flash trigger is used), this allows for flash capture without the "Clack" sound.

### 5. Setup and Compatibility
Not all flashes work seamlessly with this mode.
*   **Canon Speedlites (EL-1, EL-5, 600EX-RT):** These communicate perfectly with the camera. When you switch to Electronic Shutter, the camera will automatically cap your shutter speed range in the menu so you cannot accidentally set 1/200s.
*   **Third-Party Triggers (Godox/Profoto):**
    *   Some older triggers do not recognize that the camera is in Electronic mode.
    *   *The Risk:* If you force the camera to 1/200s manually and the trigger fires, you will see a **black band** covering 75% of your image. This is the visual proof of the rolling shutter scan not matching the flash timing.

### Summary
The ability to use Flash with the Electronic Shutter is a specialized tool, not a general one.
*   **DO NOT** use it for Event/Party photography (1/50s is too slow to freeze dancing people).
*   **DO NOT** use it for daylight fill-flash (No HSS).
*   **DO** use it for tripod-based Macro or Product photography to eliminate vibration and shutter wear.