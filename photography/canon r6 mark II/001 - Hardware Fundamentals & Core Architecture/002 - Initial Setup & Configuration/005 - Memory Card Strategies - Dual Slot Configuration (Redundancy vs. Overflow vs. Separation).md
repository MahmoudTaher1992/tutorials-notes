Here is the detailed breakdown for the next file in your structure.

**Target File:** `001 - Hardware Fundamentals & Core Architecture/002 - Initial Setup & Configuration/005 - Memory Card Strategies - Dual Slot Configuration (Redundancy vs. Overflow vs. Separation).md`

***

# Memory Card Strategies: Dual Slot Configuration

The Canon R6 Mark II features **two matching UHS-II SD card slots**. This is a critical professional feature that distinguishes it from entry-level bodies. However, simply inserting two cards does not automatically protect your data. You must explicitly tell the camera how to manage the data flow via the **Setup Menu (Yellow Wrench) > Record func+card/folder sel.**

### 1. Mode 1: Standard / Auto Switch Card (Overflow)
This is the default setting.
*   **Behavior:** The camera writes to Card 1 until it is full. Once Card 1 reaches capacity, the camera automatically switches to Card 2 and continues recording.
*   **Use Case:** Long-form video recording (interviews, conferences) or heavy sports days where total capacity matters more than redundancy.
*   **Risk:** If Card 1 corrupts, you lose everything on Card 1. There is no backup.

### 2. Mode 2: Rec. to Multiple (Redundancy / Mirroring)
This is the standard setting for **Wedding and Event Photographers**.
*   **Behavior:** Every photo taken is written to *both* Card 1 and Card 2 simultaneously.
*   **Benefit:** Instant backup. If one card fails, you lose zero data. You can hand one card to a client immediately after the shoot and keep the other for archiving.
*   **The Speed Penalty:** The camera writes at the speed of the **slowest** card.
    *   *Scenario:* If Slot 1 has a fast V90 card and Slot 2 has a slow, old SD card, the camera will choke and buffer because it has to wait for the slow card to finish writing before it can take more photos. Always use matching speeds for redundancy.
*   **Video Limitation:** While you can record video to both cards for backup, high-bitrate video (4K 60p) generates massive heat and data. Dual-recording video puts extra strain on the processor and may slightly reduce battery life or overheat times.

### 3. Mode 3: Rec. Separately (Separation by Format)
This mode offers the highest flexibility for Hybrid Shooters. It allows you to sort files as they are created.

*   **Configuration A: RAW vs. JPEG**
    *   *Setup:* Card 1 records RAW (CR3). Card 2 records JPEG.
    *   *Use Case:* "Shoot and Share." You can hand the JPEG card to a social media editor or client for immediate posting, while keeping the RAW files on Card 1 for editing later.
*   **Configuration B: Stills vs. Video**
    *   *Setup:* You can map "Stills" to Card 1 and "Movies" to Card 2.
    *   *The "Hybrid" Strategy:* This is brilliant for file organization. It keeps your video clips from getting buried between thousands of burst photos.
    *   *Budget Optimization:* Video often requires expensive V90 cards. Stills often do fine on cheaper V60 cards. By splitting them, you can buy one expensive card (Slot 2 for Video) and one cheaper card (Slot 1 for Stills) and save money without sacrificing performance.

### 4. Playback Management (The Confusion Point)
A common frustration with dual slots is hitting the "Play" button and not seeing your photos because the camera is looking at the empty card.
*   **Play Setting:** Inside the same menu, there is a "Playback" option.
    *   **Card 1/2:** Forces the camera to always open a specific card.
    *   **Auto:** Logic-based selection.
*   **Switching During Playback:** If you are reviewing images and need to see the other card, you cannot just use the dial. You must change the active card via the menu or a custom button assignment.

### 5. Formatting Discipline
When using two slots, you must be careful when formatting.
*   **The Interface:** When you select "Format Card," the R6 Mark II will ask "Card 1" or "Card 2."
*   **The Warning:** If you are using "Rec. to Multiple" (Redundancy), formatting Card 1 does **not** format Card 2. You must format them individually.
*   **Best Practice:** Before every professional shoot, format *both* cards to ensure a clean file allocation table (FAT), reducing the risk of corruption.

### Summary
*   **Events/Weddings:** Use **Rec. to Multiple** (Redundancy) with two identical V60 or V90 cards.
*   **Hybrid/Video:** Use **Rec. Separately** to put Stills on Card 1 and Video on Card 2 for organization and cost-saving on media.
*   **Sports:** Use **Standard (Overflow)** only if you need massive capacity, or **Rec. Separately (JPEG/RAW)** to speed up ingestion times.