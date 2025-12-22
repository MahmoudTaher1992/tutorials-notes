Here is the detailed breakdown for the next file in your structure.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/003 - Advanced AF Customization/002 - Case 2 Ignore Obstacles.md`

***

# AF Case 2: Continue Tracking, Ignore Obstacles

**Case 2** is specifically engineered for "dirty" visual environments—situations where trees, pillars, referees, or other players constantly pass between your camera and your target. It prioritizes **Stickiness** over acquisition speed.

### 1. The Core Logic: "Locked On"
The defining characteristic of Case 2 is its **Tracking Sensitivity** setting, which is set to **-1 (Locked On)** or lower.
*   **Behavior:** Once the camera locks onto a subject (Subject A), it tells the AF algorithm: "Do not refocus on anything else, even if Subject A disappears for a second."
*   **The Scenario:** You are tracking a tennis player. She runs behind the net post.
    *   *Case 1 Behavior:* Might panic, see the net post, and focus on the net post.
    *   *Case 2 Behavior:* Ignores the net post. It assumes the player is still there and waits for her to re-emerge on the other side.

### 2. Ideal Use Cases
*   **Team Sports (Soccer/Rugby/Football):** This is the "Sports Standard." When focusing on a striker, you don't want the focus to jump to the defender who runs across your frame for a split second.
*   **Wildlife in Nature:** A bird flying through trees. Case 2 ignores the branches flashing in the foreground and keeps the focus plane on the bird.
*   **Swimming:** The swimmer constantly disappears under splashing water. Case 2 tells the camera to ignore the water droplets and wait for the head to surface.

### 3. The Downside: Reluctance to Switch
Because Case 2 is "stubborn," it creates a specific problem.
*   **The Issue:** If you *want* to switch subjects, the camera fights you.
    *   *Example:* You are photographing Player A, but he passes the ball to Player B. You move your camera to Player B.
    *   *Result:* The camera might refuse to focus on Player B immediately because it is still trying to hold onto the depth plane of Player A (or the background where Player A was). It feels "sluggish" or unresponsive to new targets.

### 4. Fine-Tuning Case 2
Inside the menu, you can make Case 2 even more aggressive.
*   **Tracking Sensitivity:** The default is -1. You can lower it to **-2**.
    *   *Effect:* Maximum stickiness. The camera will almost never let go of the original subject depth. Use this for swimming or shooting through chain-link fences where the fence is constantly interfering.

### Summary
**Use Case 2 when:**
*   There is visual clutter in the foreground.
*   Your subject is momentarily blocked by obstacles.
*   You intend to stay on **one specific subject** for a long time.

**Avoid Case 2 when:**
*   You need to rapidly switch focus between different targets (e.g., a chaotic fight scene or a bird that changes direction suddenly toward a new flock).