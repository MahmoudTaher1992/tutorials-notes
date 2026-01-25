# 📊 Visualization techniques

*   🔍 Used to detect bottlenecks and abnomalities from hugh profiling data results

***

## 🔥 Flame Graphs

*   📌 commonly used for analyzing CPU profiling results
*   **👀 What it looks like:**
    *   **↕️ Y-Axis**
        *   represents stack depth
        *   in the bottom, you will find the caller function
        *   on top of it, you will find the function it called
    *   **↔️ X-Axis**
        *   represents population, not time
        *   lists the function called in the same level
        *   sorts the function alphabetically
    *   **📏 Bar width**
        *   CPU time consumption
*   **🎯 What to look for**
    *   **📉 Troughs with not piles over it**
        *   it indicates CPU consumption without calling other functions
        *   Optimization will speed up those parts and close the gaps

***

## ❄️ Icicle Graphs

*   🙃 inverted Flame Graphs.
*   🔄 Same as Flame Graphs

***

## 🌳 The Call Tree

*   📑 hierarchical list.
*   🔝 shows the main function on top, when you open it, you find the function called by main
*   ⛏️ you can drill down through the depth of the call tree
*   ⏱️ gives you self time (time spent by the function)
*   ⏳ gives you total time (time spent by the function and its children)

***

## 📞 Caller / Callee (Inverted / Bottom-Up)

*   ❓ gives you the answers of, who called a specific function
*   🕶️ give you the view of a blind spot in the flame graph
*   🔎 detects the functions that are of small CPU usage but called a lot, to the level of causing a significant CPU usage when accumulated
*   ⏱️ gives you self time (time spent by the function)
*   ⏳ gives you total time (time spent by the function and its children)

***

## 🌡️ Heatmaps for Latency Analysis

*   **👀 What it looks like:**
    *   **↔️ X-Axis**
        *   Time
    *   **↕️ Y-Axis**
        *   Latency duration
    *   **🎨 Color Intensity**
        *   The darker the color, the more requests happened at that specific time and duration