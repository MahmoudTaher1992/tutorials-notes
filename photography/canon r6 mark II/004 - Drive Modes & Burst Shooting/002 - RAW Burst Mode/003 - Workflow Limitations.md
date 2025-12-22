Here is the detailed breakdown for the final file in Part IV.

**Target File:** `004 - Drive Modes & Burst Shooting/002 - RAW Burst Mode/003 - Workflow Limitations.md`

***

# RAW Burst Mode: Workflow Limitations

While **RAW Burst Mode** (Pre-Capture) is a technological marvel, it imposes strict limitations on the camera's ecosystem. Enabling this mode disables other features and changes how the camera behaves physically and electronically.

### 1. The Quality Ceiling (12-bit vs. 14-bit)
Just like the standard Electronic Shutter, **RAW Burst Mode drops the bit depth to 12-bit**.
*   **Implication:** You have slightly less dynamic range recoverability in deep shadows.
*   **Compression:** The files use standard C-RAW compression algorithms to manage the massive data throughput. You cannot shoot "Uncompressed RAW" inside a RAW Burst Roll.

### 2. Feature Blackout
When RAW Burst Mode is set to **Enable**, the following features are greyed out or disabled:
*   **Flash:** You generally cannot fire a Speedlite in this mode. The camera needs to cycle the electronic shutter at 30fps continuously for the buffer, and flash capacitors cannot keep up or sync with the rolling buffer logic.
*   **Multiple Exposures / HDR:** Disabled.
*   **Anti-Flicker Shooting:** Disabled. If you are shooting indoors under bad lights, you might get banding in your pre-captured frames.

### 3. Buffer Clearing Penalty
Because the camera is writing one gigantic container file instead of many small ones, the **Write Time** can feel different.
*   **Risk:** If you fill the buffer completely (e.g., holding the button for 4 seconds), the camera has to close and finalize that massive file structure.
*   **The Freeze:** You might experience a slightly longer "Busy" lockout before you can start the next burst compared to standard shooting.

### 4. Metadata and Organization
*   **Time Stamps:** All images in the burst might be tagged with the *start time* of the burst or have identical seconds-data, making chronological sorting in non-Canon software tricky if you extract them later.
*   **Culling Software:** Popular culling tools (Photo Mechanic, FastRawViewer) might not support previewing the contents of the burst roll efficiently. You effectively lose the ability to "Speed Cull" your shoot until you extract the files.

### 5. Strategy: When to Turn It ON
Because of these workflow headaches, RAW Burst Mode should **not** be your default drive mode.
*   **Default State:** Keep the camera in standard **H+ Drive Mode**.
*   **The Switch:** Map RAW Burst Mode to a **Custom Mode (C3)** or a specific button/My Menu item.
*   **The Tactic:**
    *   Walking around searching for birds? Use Standard Drive.
    *   Found a bird on a branch waiting to dive? Switch to C3 (Pre-Capture).
    *   Bird flies away? Switch back to Standard.

### Summary
**RAW Burst Mode** is a sniper rifle, not a shotgun.
*   Use it only for specific, predictable "reaction moments."
*   Do not use it for general sports coverage, or your post-processing workload will triple.
*   Accept the 12-bit quality and lack of flash as the price of capturing the past.

***
**This concludes Part IV: Drive Modes & Burst Shooting.**
We are now ready to move to **Part V: Video Production & Cinema Features**.