This section, **Browser Monitoring (RUM)**, focuses on the "Client-Side" of your application. While APM tells you what is happening on your server (Backend), Browser Monitoring tells you what is happening on the user's laptop or phone (Frontend).

**RUM** stands for **Real User Monitoring**. It is not a simulation; it gathers data from actual humans navigating your website.

Here is a detailed breakdown of each concept in this section:

---

### 1. Lite vs. Pro vs. SPA Agents
When you enable New Relic in the browser, you aren't installing a server application; you are injecting a small snippet of JavaScript code into the `<head>` of your HTML. There are three "levels" of depth for this agent:

*   **Lite:** This is the most basic version. It only measures basic page load times (how long until the page is ready). It has the lowest overhead but provides very little debugging detail.
*   **Pro:** This includes everything in Lite, plus it captures **JavaScript errors** and **AJAX requests** (network calls your frontend makes to backends/APIs). This is the standard for most traditional websites.
*   **SPA (Single Page Application):** This is critical for modern frameworks like **React, Angular, and Vue**.
    *   *The Problem:* In a React app, you might click a menu, and the content changes, but the browser never actually reloads the page. The "Pro" agent thinks you are still on the first page.
    *   *The Solution:* The SPA agent listens for "route changes" and treats them as new page views. It wraps the browser's History API to ensure accurate metrics for dynamic apps.

### 2. Page Load Timing (Navigation Timing API)
New Relic doesn't just guess how long a page took to load; it uses the browser's built-in **Navigation Timing API**. This breaks a "3-second load time" down into specific phases, usually visualized as a colored bar or waterfall:

*   **Network/DNS:** How long did it take the user's computer to find your server and establish a connection? (High times here indicate internet/ISP issues, not code issues).
*   **DOM Processing:** How long did the browser take to read the HTML and parse the structure?
*   **Page Rendering:** How long did the browser take to paint the pixels, process CSS, and execute initial scripts?

**Why this matters:** It tells you *who* to blame. If Network is high, it's a connectivity issue. If Rendering is high, your images are too big or your JavaScript is too heavy.

### 3. Core Web Vitals (LCP, FID, CLS)
These are specific metrics defined by **Google** that determine the "User Experience" quality of a site. Google uses these metrics for SEO ranking.

*   **LCP (Largest Contentful Paint):** Measures **Loading Performance**. It marks the time when the largest image or text block becomes visible.
    *   *Goal:* 2.5 seconds or less.
*   **FID (First Input Delay) / INP (Interaction to Next Paint):** Measures **Interactivity**. When the user clicks a button, how many milliseconds does the browser freeze before it starts processing that click? (Note: Google is transitioning from FID to INP, which is a more comprehensive metric).
    *   *Goal:* 100 milliseconds or less.
*   **CLS (Cumulative Layout Shift):** Measures **Visual Stability**. Have you ever tried to click a button, but an ad loaded and pushed the button down, making you click the wrong thing? That is a layout shift.
    *   *Goal:* A score of 0.1 or less.

### 4. JavaScript Error Analysis and Source Maps
When your React code crashes on a user's browser, New Relic catches that error.

*   **The Problem:** In production, your code is "minified" (compressed) to make it load faster. A crash report usually looks like: `Error at line 1, column 45093 of app.min.js`. This is useless to a developer.
*   **Source Maps:** You upload "map" files to New Relic that act as a decoder ring. New Relic translates that useless error back into: `Error at line 42 of LoginController.js`.
*   **Grouping:** New Relic will group 5,000 error occurrences into a single "Issue" so you can see which bug is affecting the most users (e.g., "This error is only happening to users on Safari on iPhones").

### 5. Session Replay
This is a powerful debugging tool that moves beyond charts and graphs.

*   **What it is:** It is a video-like recording of the user's actual session. It records mouse movements, clicks, scrolls, and rage-clicks (when a user clicks a button 10 times because it’s broken).
*   **How it works:** It doesn't actually record video (which would be too heavy). It records the "DOM mutations" (changes to the HTML) and reconstructs them like a movie in the New Relic UI.
*   **Privacy:** It automatically masks sensitive inputs (like password fields or credit card numbers) so developers don't see private user data.

---

### Summary of Data (NRQL Context)
When you query this data later in **Part V (NRQL)**, these are the tables you will look at:
*   `PageView`: Every time a page loads.
*   `PageAction`: Specific clicks or custom events you track.
*   `JavaScriptError`: Details on crashes.
*   `AjaxRequest`: Details on HTTP calls from the browser to your API.
