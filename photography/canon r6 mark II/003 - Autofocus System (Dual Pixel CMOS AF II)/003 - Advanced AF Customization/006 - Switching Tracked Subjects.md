Here is the detailed breakdown for the final file in the "Advanced AF Customization" directory.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/003 - Advanced AF Customization/006 - Switching Tracked Subjects.md`

***

# Switching Tracked Subjects: Setting Stickiness (0, 1, 2)

There is a hidden menu setting often confused with "Tracking Sensitivity," but it does something completely different. It is located in **AF Menu (Magenta) > Page 2 > Switching tracked subjects**. This controls the behavior of the Subject Detection AI specifically.

### 1. The Variable: What does it control?
This setting dictates how easily the camera abandons a detected Subject (like a Face) to look for a different one.
*   **0 (Initial Priority):** The "Loyal" setting.
*   **1 (On Subject):** The "Balanced" setting.
*   **2 (Switch Subject):** The "Promiscuous" setting.

### 2. Setting 0 (Initial Priority)
*   **Behavior:** Once the camera draws a box around a specific face (Face A), it will hold onto Face A with extreme prejudice. Even if Face A turns away, goes into shadow, or walks behind Face B, the camera will hunt for Face A.
*   **Use Case:**
    *   **Weddings:** The Bride walking down the aisle. You do *not* want the focus jumping to the guests' faces in the foreground.
    *   **Sports:** Tracking a specific player (e.g., Leo Messi) through a crowd of defenders.

### 3. Setting 1 (On Subject)
*   **Behavior:** This is the default. The camera tries to stay on the current subject, but if that subject leaves the frame or becomes heavily obscured, the camera will give up and look for the next available face.
*   **Use Case:** General purpose. It balances tenacity with the reality that sometimes you actually *do* want to switch targets.

### 4. Setting 2 (Switch Subject)
*   **Behavior:** The camera is constantly scanning for "Better" subjects.
    *   If Face A moves to the edge of the frame and Face B enters the center, the camera will likely jump to Face B because it is more prominent.
*   **Use Case:**
    *   **Red Carpets / Parties:** Where you are just trying to get sharp photos of *whoever* is in front of you. You don't care about a specific person; you just want "A Face" in focus.
    *   **Street Photography:** Where you are scanning a crowd and want the camera to grab onto the nearest/clearest face instantly.

### 5. Interaction with "Subject Tracking"
This setting works in tandem with the **AF Area**.
*   If you use **1-Point AF** to select a specific face, setting "Switching Tracked Subjects" to **0** effectively locks that choice in. The camera understands, "You picked *this* human, and I will ignore all other humans until *this* human is gone."

### Summary
*   **Set to 0 (Initial Priority)** for Sports and Weddings where identifying a specific VIP is critical.
*   **Set to 1 (Default)** for general use.
*   **Set to 2 (Switch Subject)** for chaotic events where any face in focus is a good photo.

***
**This concludes the "Advanced AF Customization" directory.**
We are now ready to move to **Part IV: Drive Modes & Burst Shooting**.