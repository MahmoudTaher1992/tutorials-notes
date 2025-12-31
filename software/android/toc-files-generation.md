Here is the bash script. You can copy this code, save it as `create_android_study.sh`, and run it.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Android-Development-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "Creating directory structure in $(pwd)..."

# ==============================================================================
# Part I: The Android Foundation & Setup
# ==============================================================================
DIR="001-Android-Foundation-Setup"
mkdir -p "$DIR"

# A. Introduction to the Android Platform
FILE="$DIR/001-Introduction-to-Android.md"
cat <<EOF > "$FILE"
# Introduction to the Android Platform

* History and Evolution of Android
* The Android Architecture Stack (Linux Kernel, HAL, Android Runtime, etc.)
* Understanding the Application Sandbox and Permissions Model
EOF

# B. Setting Up the Development Environment
FILE="$DIR/002-Setup-Environment.md"
cat <<EOF > "$FILE"
# Setting Up the Development Environment

* Installing Android Studio: The Official IDE
* Configuring the Android SDK, Build-Tools, and Platform-Tools
* Setting up the Android Emulator (AVD) vs. Using a Physical Device
EOF

# C. Core Language Proficiency
FILE="$DIR/003-Core-Language-Proficiency.md"
cat <<EOF > "$FILE"
# Core Language Proficiency

* **Kotlin (Recommended)**
    * Basic Syntax: Variables, Control Flow, Functions
    * Null Safety: The Billion-Dollar Mistake Solved
    * Object-Oriented Concepts: Classes, Objects, Inheritance, Interfaces
    * Functional Programming: Lambdas & Higher-Order Functions
    * Key Features: Extension Functions, Data Classes, Sealed Classes
* **Java (Legacy & Interoperability)**
    * Core Java concepts relevant to Android
    * Understanding Java-Kotlin Interoperability
EOF

# D. The Build System: Gradle
FILE="$DIR/004-Build-System-Gradle.md"
cat <<EOF > "$FILE"
# The Build System: Gradle

* What is Gradle and Why Does Android Use It?
* Structure of an Android Project: Modules and \`build.gradle\` files (app vs. project level)
* Understanding Dependencies, Plugins, and Repositories
EOF

# E. Your First Android Application
FILE="$DIR/005-First-Android-App.md"
cat <<EOF > "$FILE"
# Your First Android Application

* Creating a "Hello World" App using a Template
* Anatomy of an App Project: \`AndroidManifest.xml\`, Resources (\`res/\`), Source Code (\`java\`/\`kotlin\`)
* Running and Debugging the App on an Emulator or Device
EOF

# F. Version Control Systems (VCS)
FILE="$DIR/006-Version-Control.md"
cat <<EOF > "$FILE"
# Version Control Systems (VCS)

* Why Version Control is Essential
* Git Fundamentals: \`commit\`, \`push\`, \`pull\`, \`branch\`, \`merge\`
* VCS Hosting Platforms: GitHub, GitLab, Bitbucket
EOF


# ==============================================================================
# Part II: Core Application Components & Navigation
# ==============================================================================
DIR="002-Core-Components-Navigation"
mkdir -p "$DIR"

# A. The Four Main App Components
FILE="$DIR/001-Main-App-Components.md"
cat <<EOF > "$FILE"
# The Four Main App Components

* **Activity**: The UI Layer (A single screen)
* **Service**: Background Processing
* **Broadcast Receiver**: System and App Event Listener
* **Content Provider**: Data Sharing Between Apps
EOF

# B. The Activity Lifecycle
FILE="$DIR/002-Activity-Lifecycle.md"
cat <<EOF > "$FILE"
# The Activity Lifecycle

* Understanding States: \`onCreate\`, \`onStart\`, \`onResume\`, \`onPause\`, \`onStop\`, \`onDestroy\`
* Handling Configuration Changes (e.g., Screen Rotation) and State Restoration
* Distinguishing between App Kill, Process Death, and Activity Destruction
EOF

# C. Communication via Intents
FILE="$DIR/003-Communication-via-Intents.md"
cat <<EOF > "$FILE"
# Communication via Intents

* What is an \`Intent\`?
* **Explicit Intents**: Starting a specific component (e.g., \`startActivity(this, OtherActivity::class.java)\`)
* **Implicit Intents**: Requesting an action from any capable app (e.g., sharing text)
* **Intent Filters**: Declaring a component's capabilities in the Manifest
EOF

# D. Navigation & The Back Stack
FILE="$DIR/004-Navigation-Back-Stack.md"
cat <<EOF > "$FILE"
# Navigation & The Back Stack

* Understanding Tasks and the Back Stack
* **Jetpack Navigation Component (Modern Approach)**
    * Setting up the Navigation Graph
    * Using a \`NavHostFragment\` and \`NavController\`
    * Passing Arguments Safely Between Destinations
    * Implementing Deep Links
EOF


# ==============================================================================
# Part III: Building the User Interface (UI)
# ==============================================================================
DIR="003-Building-UI"
mkdir -p "$DIR"

# A. The Traditional View System (XML-based)
FILE="$DIR/001-Traditional-View-System.md"
cat <<EOF > "$FILE"
# The Traditional View System (XML-based)

* **Layouts**: Defining the structure of a UI
    * \`LinearLayout\`, \`RelativeLayout\` (Legacy)
    * \`ConstraintLayout\` (Modern, Flexible, and Recommended)
* **Common UI Widgets (Views)**
    * \`TextView\`, \`EditText\`, \`Button\`, \`ImageView\`
    * \`CheckBox\`, \`RadioButton\`, \`Switch\`, \`ProgressBar\`
* **Displaying Lists of Data**
    * \`RecyclerView\`: The essential, efficient way to display scrolling lists
    * Core Concepts: \`Adapter\`, \`ViewHolder\`, \`LayoutManager\`
* **UI Components & Patterns**
    * \`Fragments\`: Reusable, modular pieces of UI
    * Dialogs, Toasts, and \`Snackbar\`
    * App Bar, Bottom Navigation, Navigation Drawer
    * Handling User Input and Events
EOF

# B. The Modern Declarative UI: Jetpack Compose
FILE="$DIR/002-Jetpack-Compose.md"
cat <<EOF > "$FILE"
# The Modern Declarative UI: Jetpack Compose

* **Core Philosophy**: Declarative vs. Imperative UI
* **Fundamental Concepts**
    * Composable Functions (\`@Composable\`)
    * State and Recomposition (\`remember\`, \`mutableStateOf\`)
    * The role of \`Modifiers\`
* **Layout Composables**: \`Column\`, \`Row\`, \`Box\`, \`ConstraintLayout\`
* **Common UI Composables**: \`Text\`, \`Button\`, \`TextField\`, \`Image\`
* **Displaying Lists**: \`LazyColumn\` and \`LazyRow\`
* **State Management**: State Hoisting, ViewModels with Compose
* **Theming and Styling**: \`MaterialTheme\`
* **Interoperability**: Using Compose in XML layouts and vice-versa
EOF


# ==============================================================================
# Part IV: Data Persistence & Storage
# ==============================================================================
DIR="004-Data-Persistence-Storage"
mkdir -p "$DIR"

# A. Simple Key-Value Storage
FILE="$DIR/001-Simple-Key-Value-Storage.md"
cat <<EOF > "$FILE"
# Simple Key-Value Storage

* **Shared Preferences**: The traditional approach (synchronous, not type-safe)
* **Jetpack DataStore**: The modern replacement (asynchronous, type-safe, uses Coroutines/Flow)
EOF

# B. Structured Data with a Local Database
FILE="$DIR/002-Local-Database.md"
cat <<EOF > "$FILE"
# Structured Data with a Local Database

* **Room Persistence Library**: The recommended abstraction over SQLite
* Core Components: \`Entity\` (Table), \`DAO\` (Data Access Object), \`Database\`
* Performing Queries and Type Converters
EOF

# C. File System Storage
FILE="$DIR/003-File-System-Storage.md"
cat <<EOF > "$FILE"
# File System Storage

* Internal vs. External Storage
* Scoped Storage: Modern file access and permissions
EOF


# ==============================================================================
# Part V: Concurrency & Networking
# ==============================================================================
DIR="005-Concurrency-Networking"
mkdir -p "$DIR"

# A. Asynchronous Operations
FILE="$DIR/001-Asynchronous-Operations.md"
cat <<EOF > "$FILE"
# Asynchronous Operations

* Why Asynchronism is Critical (Avoiding "Application Not Responding" errors)
* **Kotlin Coroutines (Modern Standard)**
    * \`suspend\` functions, \`CoroutineScope\`, \`Dispatchers\` (\`Main\`, \`IO\`, \`Default\`)
    * Structured Concurrency
* **RxJava/RxKotlin (Reactive Approach)**
    * Observables, Subscribers, Schedulers
* **WorkManager**: For deferrable, guaranteed background work (even if the app closes)
EOF

# B. Networking
FILE="$DIR/002-Networking.md"
cat <<EOF > "$FILE"
# Networking

* **HTTP Client Libraries**
    * **OkHttp**: The underlying, powerful HTTP client
    * **Retrofit**: The type-safe REST client for Android (builds on OkHttp)
* **Data Serialization/Deserialization**: Parsing JSON with Moshi or Gson
* **GraphQL**: Using libraries like Apollo-Android
EOF


# ==============================================================================
# Part VI: Modern Android Architecture
# ==============================================================================
DIR="006-Modern-Android-Architecture"
mkdir -p "$DIR"

# A. Architectural Principles
FILE="$DIR/001-Architectural-Principles.md"
cat <<EOF > "$FILE"
# Architectural Principles

* Separation of Concerns
* Driving UI from Data Models
EOF

# B. Architectural Patterns
FILE="$DIR/002-Architectural-Patterns.md"
cat <<EOF > "$FILE"
# Architectural Patterns

* MVC, MVP (Legacy/Informational)
* **MVVM (Model-View-ViewModel)**: The Google-recommended pattern
* **MVI (Model-View-Intent)**: A unidirectional data flow pattern
EOF

# C. Key Jetpack Architecture Components
FILE="$DIR/003-Jetpack-Components.md"
cat <<EOF > "$FILE"
# Key Jetpack Architecture Components

* **ViewModel**: Stores and manages UI-related data, survives configuration changes
* **LiveData**: A lifecycle-aware, observable data holder
* **Kotlin Flow (StateFlow & SharedFlow)**: The modern, Coroutines-based alternative to LiveData
* The **Repository Pattern**: Mediating between data sources (network, database, cache) and the domain layer
EOF

# D. Dependency Injection (DI)
FILE="$DIR/004-Dependency-Injection.md"
cat <<EOF > "$FILE"
# Dependency Injection (DI)

* Why DI? (Decoupling components, improving testability)
* **Hilt (Recommended)**: The Jetpack-recommended DI framework, built on Dagger
* **Dagger**: The powerful, compile-time DI standard
* **Koin**: A simpler, service-locator alternative
EOF


# ==============================================================================
# Part VII: Quality, Debugging & Testing
# ==============================================================================
DIR="007-Quality-Debugging-Testing"
mkdir -p "$DIR"

# A. Debugging and Profiling
FILE="$DIR/001-Debugging-Profiling.md"
cat <<EOF > "$FILE"
# Debugging and Profiling

* Using Android Studio's Debugger, Logcat, and Breakpoints
* **Performance Profiling**: CPU, Memory, and Network Profilers
* **Layout Inspection**: Layout Inspector and Motion Editor
* **Helpful Libraries**: \`Timber\` (logging), \`LeakCanary\` (memory leaks), \`Chucker\` (network inspection)
EOF

# B. Static Analysis & Linting
FILE="$DIR/002-Static-Analysis.md"
cat <<EOF > "$FILE"
# Static Analysis & Linting

* Android Lint: Catching common errors and best practice violations
* **Ktlint / Detekt**: Enforcing Kotlin code style
EOF

# C. The Testing Pyramid
FILE="$DIR/003-Testing-Pyramid.md"
cat <<EOF > "$FILE"
# The Testing Pyramid

* **Unit Tests**: Testing individual classes/functions in isolation on the JVM (\`JUnit\`, \`Mockito\`/\`MockK\`)
* **Integration/Instrumentation Tests**: Testing components that require the Android framework, running on a device/emulator (\`AndroidX Test\`, \`Espresso\`)
* **UI Tests**: Automating UI interactions (\`Espresso\` for Views, \`Compose Test\` for Compose)
EOF


# ==============================================================================
# Part VIII: Distribution & Post-Launch
# ==============================================================================
DIR="008-Distribution-Post-Launch"
mkdir -p "$DIR"

# A. Preparing for Release
FILE="$DIR/001-Preparing-Release.md"
cat <<EOF > "$FILE"
# Preparing for Release

* Build Variants: Debug vs. Release builds
* App Signing: Generating a signing key
* Code Shrinking & Obfuscation with R8/ProGuard
* Android App Bundle (\`.aab\`) vs. APK
EOF

# B. Distribution Channels
FILE="$DIR/002-Distribution-Channels.md"
cat <<EOF > "$FILE"
# Distribution Channels

* **Google Play Store**: The primary distribution platform
    * Navigating the Google Play Console
    * Managing store listings, screenshots, and policies
* **Firebase App Distribution**: For internal testing and beta releases
* Direct Distribution (Sideloading APKs)
EOF

# C. Common Services & Maintenance
FILE="$DIR/003-Common-Services.md"
cat <<EOF > "$FILE"
# Common Services & Maintenance

* **Firebase Suite**:
    * Authentication, Firestore/Realtime Database, Cloud Messaging (for push notifications), Crashlytics (crash reporting), Remote Config
* **Google Play Services**: Accessing Google APIs like Maps and Location
EOF

echo "Done! Directory structure created in $ROOT_DIR"
```

### How to use this:
1.  Open your terminal.
2.  Create a new file: `nano create_study_guide.sh`
3.  Paste the code above into the file.
4.  Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).
5.  Make the script executable: `chmod +x create_study_guide.sh`
6.  Run it: `./create_study_guide.sh`
