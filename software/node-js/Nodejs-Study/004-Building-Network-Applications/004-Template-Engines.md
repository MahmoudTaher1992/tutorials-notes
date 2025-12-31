Based on the roadmap provided, **Part IV, Section D: Template Engines (Server-Side Rendering)** focuses on how Node.js generates HTML dynamically on the server before sending it to the user's browser.

Here is a detailed explanation of this section.

---

### What is a Template Engine?

In a static website, you write an `.html` file, and the server sends that exact file to every user. However, most modern applications need to display **dynamic data** (e.g., "Welcome, *Alice*" vs. "Welcome, *Bob*", or a list of products from a database).

A **Template Engine** allows you to mix static HTML structure with dynamic data. It functions like a "Mad Libs" game:
1.  **The Template:** An HTML-like file with placeholders (e.g., `<h1>Hello, {{name}}</h1>`).
2.  **The Data:** A JavaScript object (e.g., `{ name: "Alice" }`).
3.  **The Result:** The engine combines them to produce a final HTML string: `<h1>Hello, Alice</h1>`.

---

### 1. When to use SSR vs. SPAs

This distinction is crucial in modern web development.

#### **SSR (Server-Side Rendering)**
*   **How it works:** The user requests a page. The Node.js server queries the database, uses a **Template Engine** to build the full HTML page, and sends the finished HTML to the browser.
*   **When to use Template Engines (SSR):**
    *   **SEO is critical:** Search engines (Google) and social media bots (Twitter cards/OpenGraph) can read the content immediately because the HTML is fully populated when it arrives.
    *   **Performance on low-end devices:** The server does the heavy lifting. The browser just has to paint the HTML.
    *   **Simple Applications:** Blogs, portfolios, or internal dashboards where setting up a complex React/Vue build pipeline is overkill.
    *   **Transactional Emails:** You cannot send React apps via email. You *must* use a template engine (like EJS or Handlebars) to generate the HTML for "Password Reset" or "Order Confirmation" emails.

#### **SPAs (Single Page Applications)**
*   **How it works:** The server sends an empty HTML shell and a large JavaScript bundle (React, Vue, Angular). The browser executes the JS, fetches data via JSON APIs, and builds the UI *in the browser*.
*   **When to use SPAs:**
    *   **High Interactivity:** Applications like Trello, Gmail, or Facebook where the user stays on the page and things update instantly without reloading.
    *   **Decoupled Backend:** You want one API that serves both a Web App and a Mobile App (iOS/Android).

---

### 2. Popular Template Engines

Node.js has a vast ecosystem of engines. Here are the most common ones mentioned in your roadmap:

#### **A. EJS (Embedded JavaScript)**
*   **Philosophy:** "Just HTML with JavaScript sprinkled in."
*   **Syntax:** Uses `<% %>` tags.
*   **Pros:** Very low learning curve. If you know HTML and JS, you know EJS.
*   **Cons:** Can get messy (spaghetti code) if you put too much logic in your HTML.

**Example:**
```html
<!-- index.ejs -->
<ul>
  <% users.forEach(function(user) { %>
    <li><%= user.name %></li>
  <% }); %>
</ul>
```

#### **B. Pug (Formerly Jade)**
*   **Philosophy:** "Write less code." Minimalist.
*   **Syntax:** Relies on **indentation** (whitespace) rather than closing tags (`</div>`). It looks similar to Python or YAML. It uses CSS syntax for IDs and classes.
*   **Pros:** extremely clean code; saves typing; prevents "unclosed tag" errors.
*   **Cons:** Steep learning curve; you cannot copy-paste standard HTML into a Pug file; whitespace errors can break the app.

**Example (compiles to the same HTML as the EJS example):**
```pug
// index.pug
ul
  each user in users
    li= user.name
```

#### **C. Marko**
*   **Philosophy:** High performance and streaming.
*   **Details:** Developed by eBay. It is unique because it supports streaming HTML to the browser immediately (before the whole page is ready), which makes the site feel incredibly fast. It allows for building UI components similar to React but renders on the server.

---

### 3. How to use a Template Engine in Express.js

This is how you practically implement this in a Node.js/Express app.

1.  **Install the engine:**
    ```bash
    npm install ejs
    ```

2.  **Configure Express:**
    ```javascript
    const express = require('express');
    const app = express();

    // 1. Set the view engine to EJS
    app.set('view engine', 'ejs');

    // 2. Tell Express where the template files are located
    app.set('views', './views');

    app.get('/', (req, res) => {
        const data = {
            title: "My Shop",
            items: ["Book", "Pen", "Laptop"]
        };
        // 3. Render the file 'views/index.ejs' using the data
        res.render('index', data);
    });

    app.listen(3000);
    ```

### Summary of Part IV.D
In this section of your roadmap, you are learning how to move away from sending simple text responses and start building **visual websites**. You will learn to weigh the pros and cons of generating HTML on the server (Template Engines) versus doing it in the browser (React/Vue), and you will master the syntax of tools like **Pug** or **EJS** to generate dynamic content.
