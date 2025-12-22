Here is the detailed breakdown for the next file in your structure.

**Target File:** `003 - Autofocus System (Dual Pixel CMOS AF II)/002 - Subject Detection & Deep Learning/002 - Subject Types.md`

***

# Subject Types: Humans, Animals, and Vehicles

The "Deep Learning" engine in the R6 Mark II is trained on specific datasets. It doesn't just look for "movement"; it looks for shapes it recognizes. Knowing exactly *what* shapes are in the database allows you to predict when the autofocus will succeed and when it might fail.

### 1. People (Humans)
This is the most robust model, trained on millions of human faces.
*   **Capabilities:**
    *   **Eyes:** Detects pupils and iris shapes. Works even with glasses (unless there is heavy glare).
    *   **Faces:** Detects facial structures even in profile (side view) or when partially obscured by a hand or microphone.
    *   **Heads:** Recognizes the shape of a human head from behind, regardless of hair color or hats.
    *   **Bodies:** Recognizes the torso and limbs of a human, even in strange postures (e.g., a gymnast mid-flip or a basketball player crouching).
*   **Limitations:**
    *   Heavy makeup (clowns/theatrical) or full-face masks (fencing/paintball) can sometimes confuse the Face/Eye detection, forcing the camera to rely on Head/Body detection.

### 2. Animals
The "Animal" setting is a unified model trained on specific creature families.
*   **Priority 1: Dogs & Cats (Domestic):**
    *   Incredibly sticky. Can track a black dog's eye against a dark background.
    *   Recognizes pointy ears and muzzles as "Head" indicators.
*   **Priority 2: Birds:**
    *   The "Bird Eye AF" is a game-changer. It detects the tiny bead-like eyes of birds.
    *   *Body Tracking:* It recognizes wing shapes and flight postures.
    *   *Challenge:* Small birds deep in branches. If the camera can't see the eye or head clearly, it might grab the branch in front. Use **Spot AF** to punch through.
*   **Priority 3: Horses (New to R6 II):**
    *   Specifically added for equestrian sports. It tracks the horse's head and eye.
    *   *Interaction:* If a human is riding the horse, the camera often defaults to the **Horse's eye** (because it is larger and has more contrast). If you want the Rider, you may need to switch back to "People" mode.
*   **Unofficial Support:** The "Animal" algorithm often works on unauthorized subjects like Bears, Foxes, Deer, and even some Reptiles/Insects (Dragonflies), because their eyes/heads share geometric similarities with cats/birds. However, Canon does not guarantee this.

### 3. Vehicles
This mode is strictly for motorsports and transport.
*   **Cars (Motorsports):**
    *   Trained on Formula 1, GT cars, and Rally cars.
    *   **Spot Detection:** It looks for the **Driver's Helmet** in open-cockpit cars. If the helmet is visible, focus locks there. If not, it locks on the front grill/headlight.
*   **Motorcycles:**
    *   Prioritizes the Rider's Helmet. If the rider leans (knee dragging), the focus stays glued to the helmet, not the bike tire.
*   **Trains:**
    *   Recognizes the cockpit/cab of modern and steam trains. Useful for railway enthusiasts shooting trains coming head-on.
*   **Aircraft (Planes/Helicopters):**
    *   **Cockpit Priority:** If the plane is close enough, it locks onto the cockpit windows/pilot.
    *   **Whole Body:** If far away, it tracks the fuselage.
    *   *Note:* It handles the rolling shutter of propellers (if using electronic shutter) but does not specifically "track" the propeller blades.

### 4. None (Disable Subject Detection)
Why would you ever turn it off?
*   **Landscapes:** You don't want the camera hunting for faces in rock formations (Pareidolia).
*   **Architecture:** You want straight lines focused, not a statue in the niche.
*   **Macro (Flowers/Insects):** Sometimes the "Animal" AI gets confused by the complex patterns of a flower center. Disabling AI allows for pure contrast-based precision.

### Summary
*   **Action/Sports:** Match the setting to the sport. Use **Vehicle** for F1, **People** for Basketball.
*   **Wildlife:** Use **Animals**. It covers everything from Eagles to Lions.
*   **"Auto" Warning:** While "Auto" mode (discussed next) tries to guess, if you *know* you are shooting a horse race, set it to **Animals** (or Vehicles depending on if you want the horse or the bike). Don't make the processor guess if you already know the answer.