Here is the detailed breakdown for the next file in your structure.

**Target File:** `002 - Exposure, Shutter & Image Pipeline/001 - Shutter Mechanisms/002 - Electronic First Curtain (EFCS): Bokeh issues and high shutter speeds.md`

***

# Electronic First Curtain Shutter (EFCS): Pros, Cons & The Bokeh Trap

**Electronic First Curtain Shutter (EFCS)** is the "Middle Child" of shutter modes. It is often the **default setting** on the Canon R6 Mark II out of the box because it offers the best balance for general-purpose photography. However, it introduces specific optical artifacts that can ruin a portrait if you don't understand the physics behind it.

### 1. How It Works
As the name suggests, EFCS splits the difference between Mechanical and Electronic.

*   **The Start (Electronic):** To begin the exposure, the camera does **not** move a mechanical blade. Instead, the sensor simply turns on (line by line) electronically to start gathering light. This is silent and vibration-free.
*   **The Finish (Mechanical):** To end the exposure, the mechanical **Rear Curtain** physically slides down to cover the sensor.
*   **The Cycle:** No "Click" to start, only a "Clack" to end.

### 2. The Primary Advantages (Why it is Default)
Canon sets this as the default for good reason.

*   **Eliminates Shutter Shock:** Because there is no mechanical movement *before* the image is taken, there is no vibration to blur the image. This allows for incredibly sharp images at dangerous shutter speeds like 1/15s to 1/60s.
*   **Reduced Lag:** Since the camera doesn't have to wait for a physical blade to drop before starting the exposure, the "Shutter Lag" (time between button press and capture) is slightly lower than full Mechanical mode.
*   **Quieter Operation:** It makes half the noise of the Mechanical shutter because only one curtain moves.

### 3. The "Bokeh Issue" (The Optical Flaw)
This is the most technical and critical concept to understand about EFCS.

*   **The Physics:** The Electronic First Curtain sits on the sensor plane (0mm depth). The Mechanical Rear Curtain sits slightly in front of the sensor (a few millimeters).
*   **The Problem:** At very fast shutter speeds (typically **1/2000s or faster**) combined with very wide apertures (**f/1.2 to f/2.8**), this physical gap creates a shadow or parallax error. The mechanical curtain casts a shadow on the pixels before the electronic scan is finished.
*   **The Visual Result:**
    *   **Chopped Bokeh:** Out-of-focus highlights (bokeh balls) in the background will not look like circles. They will look like semi-circles or "D" shapes, as if someone took a bite out of the bottom of them.
    *   **Nervous Background:** The background blur can appear harsher and less creamy.
*   **The Solution:** If you are shooting a portrait at f/1.2 in bright sunlight (requiring 1/4000s or 1/8000s), **switch to Full Mechanical Shutter** or **Full Electronic Shutter** to preserve perfect bokeh.

### 4. Exposure Unevenness
At the extreme limit of the R6 Mark II’s shutter speed (**1/8000s**), EFCS can result in slight exposure unevenness.

*   Because the electronic start and mechanical stop are moving at slightly different velocities or distances, one side of the image might be slightly darker than the other.
*   This is rarely noticeable in real-world shooting unless you are photographing a plain blue sky or a grey wall, but it is technically present.

### 5. Flash Interaction
EFCS is generally safe for flash photography.

*   **Sync Speed:** On the R6 Mark II, EFCS supports the same max flash sync speed (~1/200s - 1/250s) as the Mechanical shutter.
*   **HSS:** It fully supports High-Speed Sync.
*   **Recommendation:** For event photography (Weddings/Parties), EFCS is excellent. It reduces vibration, is quieter, and handles flash perfectly. You rarely shoot flash at 1/4000s f/1.2, so the bokeh issue is moot.

### Summary
**Use Electronic First Curtain (EFCS) for:**
1.  **General Photography:** It is the best "set it and forget it" mode.
2.  **Landscape/Macro:** Critical for eliminating shutter shock vibrations.
3.  **Weddings/Events:** Quieter than mechanical, but fully flash compatible.

**Switch OFF EFCS (Go to Mechanical) when:**
1.  **Shooting Wide Open (f/1.2 - f/1.8):** specifically in bright light where shutter speeds exceed 1/2000s, to avoid "Chopped Bokeh."