Here is the detailed breakdown for the next file in your structure.

**Target File:** `001 - Hardware Fundamentals & Core Architecture/002 - Initial Setup & Configuration/004 - Memory Card Strategies - UHS-II SD Card Speed Classes (V60 vs. V90 requirements).md`

***

# Memory Card Strategies: UHS-II SD Card Speed Classes (V60 vs. V90)

The Canon R6 Mark II relies on **Dual SD UHS-II** card slots. Unlike the EOS R5 or R3, which use the blazing-fast CFExpress Type B cards, the R6 Mark II is limited by the speed of SD technology. This makes card selection critical: buying the wrong card will physically prevent you from using certain video modes and will cripple your burst shooting experience.

### 1. Understanding the Hardware Interface (UHS-II)
First, ensure you are buying **UHS-II** cards.
*   **Physical Difference:** UHS-II cards have a **second row of metal pins** on the back.
*   **Performance:** UHS-I cards max out around 104 MB/s (Read). UHS-II cards can reach 300 MB/s (Read) and 260-290 MB/s (Write).
*   **The Bottleneck:** You *can* put a standard UHS-I card in the R6 Mark II, and it will work for single photos. However, if you attempt 40fps bursts or 4K 60p video, the camera's internal buffer will choke, causing the camera to freeze while it tries to "flush" the data to the slow card.

### 2. The Speed Class Ratings: V60 vs. V90
SD cards use "Video Speed Class" (V) ratings to guarantee a **minimum sustained write speed**.

*   **V60 (Minimum 60 MB/s Write):**
    *   The "Sweet Spot" for value.
    *   Can handle **Standard 4K 60p** (IPB Compression).
    *   Can handle **Standard Burst Shooting** (Mechanical shutter 12fps).
    *   *Limitation:* Cannot handle High Bitrate ALL-I video or clearing the 40fps buffer quickly.
*   **V90 (Minimum 90 MB/s Write):**
    *   The "Performance Ceiling."
    *   **Required for ALL-I Video:** If you want to shoot edit-friendly Intra-frame video.
    *   **Best for Sports:** Clears the image buffer significantly faster, allowing you to review images or resume shooting sooner after a 40fps burst.

### 3. Video Bitrates: The "Megabits vs. Megabytes" Math
To know which card you need, you must understand the data rates of the R6 Mark II. Camera menus show speeds in **Megabits per second (Mbps)**. Cards are sold in **Megabytes per second (MB/s)**.
*   *Conversion:* 8 Megabits = 1 Megabyte.

**Case A: 4K 60p (IPB - Standard Compression)**
*   Data Rate: Approx 230 Mbps.
*   Math: 230 / 8 = **28.75 MB/s**.
*   *Verdict:* A **V30** or **V60** card works fine.

**Case B: 4K 60p (ALL-I - High Quality Compression)**
*   *Note:* You must enable "High Frame Rate" or specific settings to access ALL-I.
*   Data Rate: Approx 470 Mbps to 600+ Mbps (depending on C-Log).
*   Math: 600 / 8 = **75 MB/s**.
*   *Verdict:* A V60 card (max 60 MB/s sustained) will **fail**. Recording will stop automatically after a few seconds. **You MUST use a V90 card.**

### 4. Photography Implications (The Buffer)
The R6 Mark II can shoot 40 Raw images per second.
*   **The Buffer:** The camera has fast internal memory (RAM) that holds these photos before writing them to the card.
*   **The Pipeline:**
    *   One second of 40fps RAW shooting generates roughly **1 Gigabyte of data**.
    *   A **V60 card** writes at ~60-80 MB/s. It will take **12+ seconds** to clear that one-second burst.
    *   A **V90 card** writes at ~250 MB/s (peak). It will take roughly **4 seconds** to clear that same burst.
*   *The Reality:* A faster card does not make the camera shoot faster; it minimizes the "Busy" light duration, allowing you to access menus or review photos sooner.

### 5. Summary Recommendation
*   **Buy V60 (e.g., ProGrade Gold, Lexar 1800x)** if: You are a wedding/event photographer who mostly shoots single shots or low burst, and you record video in standard IPB format (small file sizes).
*   **Buy V90 (e.g., ProGrade Cobalt, Sony Tough G, Lexar 2000x)** if: You shoot Sports/Wildlife (heavy bursts) or require ALL-I Video codecs for high-end post-production.

**Critical Warning:** Avoid "Micro-SD with Adapter" setups for professional work. The extra contact points add failure risk. Stick to full-size SDXC cards.