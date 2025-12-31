Here is the bash script to generate your study structure.

I have formatted the script to use **Heredocs** (`cat << 'EOF'`) instead of simple `echo` commands. This ensures that the Markdown syntax (like backticks \` used for code code snippets in your TOC) is preserved perfectly without being interpreted as shell commands.

### Instructions:
1.  Copy the code block below.
2.  Save it as a file (e.g., `setup_tanstack_study.sh`).
3.  Make it executable: `chmod +x setup_tanstack_study.sh`
4.  Run it: `./setup_tanstack_study.sh`

```bash
#!/bin/bash

# Root Directory Name
ROOT="TanStack-Query-Study"

# Create Root Directory
echo "Creating study environment in: $ROOT"
mkdir -p "$ROOT"
cd "$ROOT" || exit

# Function to create a file with content
# Usage: create_file "Directory" "Filename" "Header" "BodyContent"
create_file() {
    local DIR="$1"
    local FILE="$2"
    local HEADER="$3"
    local CONTENT="$4"

    mkdir -p "$DIR"
    
    # Using 'EOF' (quoted) prevents the shell from trying to interpret 
    # backticks or special characters inside the content.
    cat << 'EOF' > "$DIR/$FILE"
# ${HEADER_PLACEHOLDER}

${CONTENT_PLACEHOLDER}
EOF

    # We use sed to replace the placeholders because passing variables 
    # directly into a quoted heredoc is tricky.
    # Note: Using distinct delimiters for sed to handle slashes in text.
    sed -i "s|\${HEADER_PLACEHOLDER}|$HEADER|g" "$DIR/$FILE"
    
    # For the multi-line content, we append it directly to ensure formatting stays
    echo "$CONTENT" >> "$DIR/$FILE"
    
    # Clean up the placeholder line
    sed -i "/\${CONTENT_PLACEHOLDER}/d" "$DIR/$FILE"
}

# ==============================================================================
# PART I: Fundamentals & The Problem of Server State
# ==============================================================================
DIR="001-Fundamentals-and-Server-State"

# A
CONTENT="* The \"Human UI\" vs. the \"Data-Driven UI\"
* The Challenge of Server State vs. Client State
* Traditional Approach: \`useEffect\` + \`useState\` for Fetching
    * Common Pitfalls: Race conditions, managing loading/error states, caching, re-fetching."
create_file "$DIR" "001-Introduction-to-Client-Side-Data-Fetching.md" "Introduction to Client-Side Data Fetching" "$CONTENT"

# B
CONTENT="* Philosophy: Treating Server State as a First-Class Citizen
* Core Principles: Declarative, Zero-Configuration, and Opinionated yet Configurable
* Key Concepts: Queries, Mutations, and the Query Cache"
create_file "$DIR" "002-Introducing-TanStack-Query.md" "Introducing TanStack Query" "$CONTENT"

# C
CONTENT="* \`QueryClient\`: The heart of the library, managing the cache.
* \`QueryClientProvider\`: Connecting the client to your application tree.
* \`useQuery\`: The primary hook for fetching, caching, and tracking data.
* \`ReactQueryDevtools\`: Your indispensable debugging companion."
create_file "$DIR" "003-Core-Architectural-Components.md" "Core Architectural Components" "$CONTENT"

# D
CONTENT="* Setting up the \`QueryClient\` and \`Provider\`
* The Three Pillars of a Query
    * \`queryKey\`: The unique, serializable identifier for data.
    * \`queryFn\`: The asynchronous function that resolves the data (e.g., a \`fetch\` call).
    * The Returned Data & State: \`data\`, \`status\`, \`isLoading\`, \`isError\`, \`error\`."
create_file "$DIR" "004-Your-First-Query.md" "Your First Query: A 'Hello, World!' Example" "$CONTENT"


# ==============================================================================
# PART II: The useQuery Hook in Depth
# ==============================================================================
DIR="002-useQuery-Hook-in-Depth"

# A
CONTENT="* Understanding the State Machine: \`pending\` -> \`success\` or \`error\`
* Distinguishing States: \`isLoading\` vs. \`isFetching\`
* Cache States: \`fresh\`, \`stale\`, \`inactive\`, \`paused\`"
create_file "$DIR" "001-Query-Lifecycle-and-Statuses.md" "Query Lifecycle and Statuses" "$CONTENT"

# B
CONTENT="* \`enabled\`: Conditional and dependent queries.
* \`staleTime\`: The duration until \`fresh\` data becomes \`stale\`.
* \`cacheTime\` (formerly \`cacheTime\`): The duration until inactive data is garbage collected.
* \`refetchOnWindowFocus\`, \`refetchOnMount\`, \`refetchOnReconnect\`: Automatic background re-fetching.
* \`retry\` & \`retryDelay\`: Automatic error recovery.
* \`select\`: Transforming or selecting a partial piece of data.
* \`initialData\` vs. \`placeholderData\`: Providing data before the first fetch."
create_file "$DIR" "002-Essential-useQuery-Options.md" "Essential useQuery Options (Configuration)" "$CONTENT"

# C
CONTENT="* Primary State: \`data\`, \`error\`, \`status\`
* Derived Boolean Flags: \`isSuccess\`, \`isPending\`, \`isError\`, \`isLoading\`, \`isFetching\`, \`isStale\`, \`isRefetching\`
* Functions: \`refetch\` for manual query execution.
* Metadata: \`dataUpdatedAt\`, \`errorUpdatedAt\`"
create_file "$DIR" "003-useQuery-Return-Object.md" "The useQuery Return Object (Derived State)" "$CONTENT"


# ==============================================================================
# PART III: Data Modification with Mutations
# ==============================================================================
DIR="003-Data-Modification-with-Mutations"

# A
CONTENT="* The Purpose of Mutations: Creating, updating, or deleting data.
* Basic Usage: The \`mutate\` and \`mutateAsync\` functions.
* Tracking Mutation State: \`isPending\`, \`isSuccess\`, \`isError\`, \`data\`, \`error\`."
create_file "$DIR" "001-Introduction-to-useMutation.md" "Introduction to useMutation" "$CONTENT"

# B
CONTENT="* The Mutation Lifecycle: \`onMutate\`, \`onSuccess\`, \`onError\`, \`onSettled\`.
* Passing Variables to \`mutate\` and using them in callbacks."
create_file "$DIR" "002-Mutation-Side-Effects-and-Callbacks.md" "Mutation Side Effects and Callbacks" "$CONTENT"

# C
CONTENT="* The \"Invalidate and Refetch\" Pattern
* Using \`queryClient.invalidateQueries\` in \`onSuccess\`.
* Fine-grained invalidation using Query Keys and Filters."
create_file "$DIR" "003-Core-Invalidation-Strategies.md" "Core Invalidation Strategies" "$CONTENT"

# D
CONTENT="* Concept and Motivation: Making the UI feel instantaneous.
* The Step-by-Step Process:
    1. \`onMutate\`: Cancel outgoing refetches and snapshot the previous value.
    2. Optimistically update the cache with \`queryClient.setQueryData\`.
    3. Return the context with the snapshot.
    4. \`onError\`: Rollback to the previous value using the context.
    5. \`onSettled\`: Invalidate and refetch to ensure server state consistency."
create_file "$DIR" "004-Optimistic-Updates.md" "Optimistic Updates: The Ultimate UX Pattern" "$CONTENT"

# E
CONTENT="* Using \`queryClient.setQueryData\` in \`onSuccess\` for simple updates (e.g., creating a new item in a list).
* Comparing Invalidation vs. Direct Cache Updates."
create_file "$DIR" "005-Updating-Cache-Directly.md" "Updating the Cache Directly Post-Mutation" "$CONTENT"


# ==============================================================================
# PART IV: Advanced Querying Patterns & Techniques
# ==============================================================================
DIR="004-Advanced-Querying-Patterns"

# A
CONTENT="* Managing page state.
* Using \`keepPreviousData\` to prevent UI flickering on page changes."
create_file "$DIR" "001-Paginated-Queries.md" "Paginated Queries" "$CONTENT"

# B
CONTENT="* The \`useInfiniteQuery\` Hook.
* Configuration: \`queryFn\` with \`pageParam\`, \`initialPageParam\`, \`getNextPageParam\`.
* Return Object: \`data.pages\`, \`fetchNextPage\`, \`hasNextPage\`, \`isFetchingNextPage\`."
create_file "$DIR" "002-Infinite-Loading.md" "Infinite Loading & Load More UIs" "$CONTENT"

# C
CONTENT="* Parallel Queries: Simply using multiple \`useQuery\` hooks.
* The \`useQueries\` hook for a dynamic number of parallel queries.
* Dependent Queries: Chaining requests using the \`enabled\` option."
create_file "$DIR" "003-Parallel-and-Dependent-Queries.md" "Parallel and Dependent Queries" "$CONTENT"

# D
CONTENT="* Prefetching with \`queryClient.prefetchQuery\`: Fetching data on hover/intent.
* Pre-populating the cache with \`queryClient.setQueryData\`."
create_file "$DIR" "004-Proactive-Data-Fetching.md" "Proactive Data Fetching" "$CONTENT"


# ==============================================================================
# PART V: The Query Cache & Client Configuration
# ==============================================================================
DIR="005-Query-Cache-and-Configuration"

# A
CONTENT="* Deep Dive: \`staleTime\` vs. \`cacheTime\` with diagrams.
* The Garbage Collector: How inactive queries are removed."
create_file "$DIR" "001-Mastering-the-Cache.md" "Mastering the Cache" "$CONTENT"

# B
CONTENT="* Setting \`defaultOptions\` for queries and mutations on the \`QueryClient\`.
* Custom \`queryCache\` and \`mutationCache\` for global event handling (\`onSuccess\`, \`onError\`)."
create_file "$DIR" "002-Global-Configuration.md" "Global Configuration" "$CONTENT"

# C
CONTENT="* Reading from the cache: \`queryClient.getQueryData\`.
* Writing to the cache: \`queryClient.setQueryData\`.
* Manual removal: \`queryClient.removeQueries\`.
* Resetting the cache: \`queryClient.resetQueries\`."
create_file "$DIR" "003-Direct-Cache-Interaction.md" "Direct Cache Interaction" "$CONTENT"

# D
CONTENT="* Best Practices for Key Structure (Arrays, strings, objects).
* Using Query Keys for both specific and partial matching (Query Filters)."
create_file "$DIR" "004-Query-Keys.md" "Query Keys: The Foundation of Caching" "$CONTENT"


# ==============================================================================
# PART VI: Integration, Testing & Developer Experience
# ==============================================================================
DIR="006-Integration-Testing-DX"

# A
CONTENT="* Server-Side Rendering (SSR) & Static Site Generation (SSG) with Next.js.
* The Hydration Pattern: \`HydrationBoundary\`, \`dehydrate\`, and \`hydrate\`."
create_file "$DIR" "001-Framework-Specific-Integration.md" "Framework-Specific Integration" "$CONTENT"

# B
CONTENT="* Setting up tests: Wrapping components with a \`QueryClientProvider\`.
* Mocking API calls (e.g., with MSW - Mock Service Worker).
* Testing loading, success, and error states.
* Controlling query behavior in tests (\`setQueryDefaults\`)."
create_file "$DIR" "002-Testing-Strategies.md" "Testing Strategies" "$CONTENT"

# C
CONTENT="* Per-query handling with \`isError\` and \`error\`.
* Using React Error Boundaries for centralized error display.
* Global error handling via \`queryCache.config.onError\`."
create_file "$DIR" "003-Error-Handling-Strategies.md" "Error Handling Strategies" "$CONTENT"

# D
CONTENT="* Creating custom hooks to encapsulate \`useQuery\`/\`useMutation\` logic.
* Centralizing query key management (Query Key Factories).
* Structuring API client functions (the \`queryFn\`)."
create_file "$DIR" "004-Code-Organization.md" "Code Organization & Best Practices" "$CONTENT"


# ==============================================================================
# PART VII: Advanced & Ecosystem Topics
# ==============================================================================
DIR="007-Advanced-and-Ecosystem"

# A
CONTENT="* Using \`persistQueryClient\` with official persister plugins.
* Strategies for \`localStorage\`, \`sessionStorage\`, or AsyncStorage."
create_file "$DIR" "001-Persisting-the-Cache.md" "Persisting the Cache" "$CONTENT"

# B
CONTENT="* \`useIsFetching\` and \`useIsMutating\` for global loading indicators.
* \`useQueryClient\` to get access to the client instance."
create_file "$DIR" "002-Advanced-Hooks-and-Utilities.md" "Advanced Hooks and Utilities" "$CONTENT"

# C
CONTENT="* Request Cancellation with \`AbortSignal\`.
* Comparing TanStack Query with other state management libraries (Redux/RTK Query, Zustand, Apollo Client)."
create_file "$DIR" "003-Network-and-Performance.md" "Network & Performance" "$CONTENT"

# D
CONTENT="* The Framework-Agnostic Core (\`@tanstack/query-core\`).
* Adapters for other frameworks: Solid, Vue, Svelte."
create_file "$DIR" "004-Beyond-React.md" "Beyond React" "$CONTENT"

echo "Directory structure created successfully!"
```
