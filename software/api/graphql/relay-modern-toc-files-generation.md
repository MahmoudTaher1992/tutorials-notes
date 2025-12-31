Here is the bash script generated based on your Table of Contents.

It uses `cat <<'EOF'` blocks to safely write the Markdown content (including backticks and special characters) into the files.

```bash
#!/bin/bash

# Name of the root directory
ROOT_DIR="Relay-Modern-Study"

# Create root directory and enter it
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure for: $ROOT_DIR"

# ==============================================================================
# Part I: Relay Modern Fundamentals & Core Principles
# ==============================================================================
PART_DIR="001-Relay-Modern-Fundamentals"
mkdir -p "$PART_DIR"

# A. Introduction to Relay Modern
cat <<'EOF' > "$PART_DIR/001-Introduction-to-Relay-Modern.md"
# Introduction to Relay Modern

- **Motivation and Philosophy**: Understanding why Relay was created, its focus on performance, and its declarative approach to data fetching.
- **Core Concepts**: An overview of Relay's key principles, including its use of a compiler, a normalized cache, and GraphQL best practices.
- **Relay vs. Other GraphQL Clients**: A comparison of Relay with other popular clients like Apollo Client and urql, highlighting their different philosophies and trade-offs.
- **The Role of the Relay Compiler**: Understanding how the ahead-of-time compilation of GraphQL queries optimizes performance and enables powerful features.
EOF

# B. Setting Up a Relay Modern Project
cat <<'EOF' > "$PART_DIR/002-Setting-Up-Project.md"
# Setting Up a Relay Modern Project

- **Prerequisites**: A foundational understanding of React and GraphQL is essential before diving into Relay.
- **Project Initialization**: Step-by-step guidance on setting up a new project using tools like Create React App or Vite.
- **Installing Dependencies**: A comprehensive list of necessary packages, including `react-relay`, `relay-runtime`, and the `relay-compiler`.
- **Configuring the Relay Compiler**: Detailed instructions on how to configure the compiler to work with your project's structure and GraphQL schema.
- **Setting up the Relay Environment**: Learn how to create and configure the Relay Environment, which is responsible for networking and caching.
- **TypeScript Integration**: Best practices for using TypeScript with Relay to ensure type safety in your application.
EOF

# ==============================================================================
# Part II: Core Components & Data Fetching
# ==============================================================================
PART_DIR="002-Core-Components-Data-Fetching"
mkdir -p "$PART_DIR"

# A. Queries
cat <<'EOF' > "$PART_DIR/001-Queries.md"
# Queries

- **`QueryRenderer`**: The primary API for fetching and rendering data in a Relay application.
- **Loading and Error States**: How to effectively handle loading and error states within the `QueryRenderer`.
- **Render Props**: Utilizing render props to customize the rendering of your components based on the query state.
EOF

# B. Fragments
cat <<'EOF' > "$PART_DIR/002-Fragments.md"
# Fragments

- **`createFragmentContainer`**: Learn how to use fragments to declare the data requirements of your components in a declarative and co-located manner.
- **Data Masking**: Understand how Relay's data masking prevents components from accessing data they haven't explicitly requested.
- **Composition**: Best practices for composing fragments together to build complex UIs from smaller, reusable components.
EOF

# C. Mutations
cat <<'EOF' > "$PART_DIR/003-Mutations.md"
# Mutations

- **`commitMutation`**: A step-by-step guide to performing data mutations with Relay.
- **Optimistic Updates**: How to provide immediate feedback to users by updating the UI before the server responds.
- **Updater Functions**: Learn how to manually update the local data store after a mutation.
EOF

# D. Subscriptions
cat <<'EOF' > "$PART_DIR/004-Subscriptions.md"
# Subscriptions

- **`requestSubscription`**: How to subscribe to real-time data updates from your GraphQL server.
- **Configuration**: A guide to configuring subscriptions to handle incoming data and update the UI accordingly.
EOF

# ==============================================================================
# Part III: Advanced Data Management
# ==============================================================================
PART_DIR="003-Advanced-Data-Management"
mkdir -p "$PART_DIR"

# A. Pagination
cat <<'EOF' > "$PART_DIR/001-Pagination.md"
# Pagination

- **`createPaginationContainer`**: A comprehensive guide to implementing pagination for lists of data.
- **Cursor-Based Pagination**: Understanding the principles of cursor-based pagination and how Relay leverages it for efficient data fetching.
- **Connection Model**: How to structure your GraphQL schema to support Relay's pagination features.
EOF

# B. Refetching and Refreshing Data
cat <<'EOF' > "$PART_DIR/002-Refetching-and-Refreshing-Data.md"
# Refetching and Refreshing Data

- **`createRefetchContainer`**: Learn how to refetch data for a component with new variables.
- **Polling**: Techniques for periodically refetching data to keep your UI up-to-date.
- **Data Invalidation**: Strategies for invalidating cached data to ensure freshness.
EOF

# C. Local State Management
cat <<'EOF' > "$PART_DIR/003-Local-State-Management.md"
# Local State Management

- **Client Schema Extensions**: How to extend your GraphQL schema on the client to manage local state with Relay.
- **Local Data Updates**: Techniques for updating local data in the Relay store.
EOF

# ==============================================================================
# Part IV: The Relay Compiler in Depth
# ==============================================================================
PART_DIR="004-Relay-Compiler-In-Depth"
mkdir -p "$PART_DIR"

# A. Compiler Architecture
cat <<'EOF' > "$PART_DIR/001-Compiler-Architecture.md"
# Compiler Architecture

- **Static Analysis and Optimization**: An in-depth look at how the Relay compiler analyzes your queries and optimizes them for performance.
- **Generated Artifacts**: Understanding the files generated by the compiler and their role in the Relay runtime.
EOF

# B. Advanced Compiler Features
cat <<'EOF' > "$PART_DIR/002-Advanced-Compiler-Features.md"
# Advanced Compiler Features

- **Persisted Queries**: Learn how to use persisted queries to reduce network overhead and improve security.
- **Custom Directives**: How to create and use custom directives to extend the functionality of the Relay compiler.
EOF

# ==============================================================================
# Part V: Performance & Optimization
# ==============================================================================
PART_DIR="005-Performance-Optimization"
mkdir -p "$PART_DIR"

# A. Caching Strategies
cat <<'EOF' > "$PART_DIR/001-Caching-Strategies.md"
# Caching Strategies

- **Normalized Cache**: A deep dive into Relay's normalized cache and how it ensures data consistency.
- **Garbage Collection**: Understanding how Relay's garbage collection helps manage memory usage by evicting unused data from the cache.
- **Cache Invalidation and Updates**: Advanced techniques for managing the cache to ensure your UI always displays the most up-to-date information.
EOF

# B. Code Splitting and Lazy Loading
cat <<'EOF' > "$PART_DIR/002-Code-Splitting-Lazy-Loading.md"
# Code Splitting and Lazy Loading

- **Route-based Code Splitting**: How to split your code based on routes to improve initial load times.
- **Component-based Code Splitting**: Techniques for lazy loading components and their associated data.
EOF

# C. Performance Profiling
cat <<'EOF' > "$PART_DIR/003-Performance-Profiling.md"
# Performance Profiling

- **Relay DevTools**: A guide to using the Relay DevTools to inspect the cache, network requests, and component updates.
- **Performance Monitoring**: How to identify and address performance bottlenecks in your Relay application.
EOF

# ==============================================================================
# Part VI: Testing & Tooling
# ==============================================================================
PART_DIR="006-Testing-Tooling"
mkdir -p "$PART_DIR"

# A. Testing Strategies
cat <<'EOF' > "$PART_DIR/001-Testing-Strategies.md"
# Testing Strategies

- **Unit Testing Components**: Best practices for writing unit tests for your Relay components.
- **Integration Testing**: How to test the interaction between your components and the Relay data layer.
- **Mocking the Relay Environment**: A guide to creating a mock Relay environment for testing purposes.
EOF

# B. Developer Experience
cat <<'EOF' > "$PART_DIR/002-Developer-Experience.md"
# Developer Experience

- **GraphQL Editor Integration**: How to set up your editor for a better development experience with features like autocompletion and go-to-definition.
- **Linting and Formatting**: Best practices for maintaining a consistent and high-quality codebase.
EOF

# ==============================================================================
# Part VII: Advanced Topics & Ecosystem
# ==============================================================================
PART_DIR="007-Advanced-Topics-Ecosystem"
mkdir -p "$PART_DIR"

# A. Server-Side Rendering (SSR) with Relay
cat <<'EOF' > "$PART_DIR/001-SSR-with-Relay.md"
# Server-Side Rendering (SSR) with Relay

- **Isomorphic Relay**: An introduction to the concepts of isomorphic and universal web applications.
- **SSR Setup**: A step-by-step guide to setting up server-side rendering with Relay.
EOF

# B. Relay and React Native
cat <<'EOF' > "$PART_DIR/002-Relay-React-Native.md"
# Relay and React Native

- **Relay in a Mobile Environment**: Considerations for using Relay in a React Native application.
- **Offline Support**: Strategies for building offline-first applications with Relay.
EOF

# C. The Relay Ecosystem
cat <<'EOF' > "$PART_DIR/003-Relay-Ecosystem.md"
# The Relay Ecosystem

- **Community and Resources**: An overview of the Relay community and where to find help and resources.
- **Future of Relay**: A look at the future direction of Relay and upcoming features.
EOF

echo "Done! Directory structure created in: $(pwd)"
```
