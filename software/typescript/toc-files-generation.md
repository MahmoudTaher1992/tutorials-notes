Here is the bash script to generate the TypeScript study directory structure.

I have cleaned up the file names (removing special characters like `*`) and formatted the content inside the Markdown files to include the bullet points from your specific Table of Contents.

### Instructions
1.  Open your terminal in Ubuntu.
2.  Create a file named `setup_ts_study.sh`:
    ```bash
    nano setup_ts_study.sh
    ```
3.  Paste the code below into that file.
4.  Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).
5.  Make the script executable:
    ```bash
    chmod +x setup_ts_study.sh
    ```
6.  Run the script:
    ```bash
    ./setup_ts_study.sh
    ```

### The Script

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="TypeScript-Study-Notes"

# Create the root directory
if [ -d "$ROOT_DIR" ]; then
    echo "Directory $ROOT_DIR already exists. Please remove it or rename it to run this script."
    exit 1
fi

mkdir "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $ROOT_DIR..."

# ==========================================
# Part I: Introduction and Setup
# ==========================================
PART_DIR="001-Introduction-and-Setup"
mkdir "$PART_DIR"

# A. Introduction to TypeScript
cat <<EOF > "$PART_DIR/001-Introduction-to-TypeScript.md"
# Introduction to TypeScript

* 1. What is TypeScript? (Superset of JavaScript, benefits, goals)
* 2. Why TypeScript? (Type Safety, Better Tooling, Scalability, Readability, Refactoring)
* 3. **TypeScript vs JavaScript**: Key Differences and Advantages
    * a. Static vs. Dynamic Typing
    * b. Compile-time vs. Runtime Checks
    * c. Feature Parity and Transpilation
EOF

# B. Installation and Configuration
cat <<EOF > "$PART_DIR/002-Installation-and-Configuration.md"
# Installation and Configuration

* 1. **Installation and Configuration**
    * a. Global Installation (\`npm install -g typescript\`)
    * b. Local Project Installation
* 2. **Running TypeScript** Code
    * a. **\`tsc\`**: The TypeScript Compiler
        * i. Compiling single files and projects
        * ii. Watching for file changes (\`--watch\`)
    * b. **\`ts-node\`**: Executing TypeScript Directly
    * c. **TS Playground**: Online Sandbox for Learning and Experimentation
* 3. **\`tsconfig.json\`**: The Project Configuration File
    * a. Understanding **Compiler Options** (\`compilerOptions\`)
        * i. \`target\`, \`module\`, \`lib\`
        * ii. \`strict\` (all strict mode options), \`noImplicitAny\`, \`strictNullChecks\`
        * iii. \`esModuleInterop\`, \`allowSyntheticDefaultImports\`
        * iv. \`forceConsistentCasingInFileNames\`, \`skipLibCheck\`
        * v. \`outDir\`, \`rootDir\`, \`declaration\`, \`sourceMap\`
        * vi. \`resolveJsonModule\`, \`isolatedModules\`
    * b. \`include\`, \`exclude\`, \`files\`: Defining Project Scope
EOF

# C. Fundamental Concepts
cat <<EOF > "$PART_DIR/003-Fundamental-Concepts.md"
# Fundamental Concepts

* 1. **Type Inference**: Automatic Type Detection by the Compiler
* 2. **Type Compatibility**: Understanding Structural Typing
* 3. The \`declare\` Keyword: Ambient Declarations for External JavaScript
EOF

# ==========================================
# Part II: Core Types and Type System Fundamentals
# ==========================================
PART_DIR="002-Core-Types-and-Fundamentals"
mkdir "$PART_DIR"

# A. Primitive Types
cat <<EOF > "$PART_DIR/001-Primitive-Types.md"
# Primitive Types

* 1. **\`boolean\`**: True or False values
* 2. **\`number\`**: All Numeric values (integers, floats, hex, binary, octal)
* 3. **\`string\`**: Textual data
* 4. **\`void\`**: The absence of any type (often for function return types)
* 5. **\`undefined\`**: A variable that has not been assigned a value
* 6. **\`null\`**: An intentional absence of any object value
EOF

# B. Object Types
cat <<EOF > "$PART_DIR/002-Object-Types.md"
# Object Types

* 1. **\`Array\`**: Collections of a single type (\`Type[]\` or \`Array<Type>\`)
* 2. **\`Tuple\`**: Fixed-length, ordered arrays with specific types at each position
* 3. **\`Object\`**: Non-primitive type (any value not a primitive)
EOF

# C. Special Types
cat <<EOF > "$PART_DIR/003-Special-Types.md"
# Special Types

* 1. **\`Enum\`**: Enumerated types for sets of named constants (Numeric and String enums)
EOF

# D. Top and Bottom Types
cat <<EOF > "$PART_DIR/004-Top-and-Bottom-Types.md"
# Top and Bottom Types

* 1. **\`any\`**: Opt-out of type checking (a "Top Type")
* 2. **\`unknown\`**: A type-safe alternative to \`any\` (a "Top Type")
* 3. **\`never\`**: A type that represents values that never occur (a "Bottom Type")
* 4. Understanding **Top Types** vs. **Bottom Types** in the Type Hierarchy
EOF

# ==========================================
# Part III: Advanced Types and Type Operations
# ==========================================
PART_DIR="003-Advanced-Types-and-Operations"
mkdir "$PART_DIR"

# A. Combining Types
cat <<EOF > "$PART_DIR/001-Combining-Types.md"
# Combining Types

* 1. **Union Types**: A value can be one of several types (\`Type1 | Type2\`)
* 2. **Intersection Types**: A value must possess all properties of several types (\`Type1 & Type2\`)
EOF

# B. Type Aliases
cat <<EOF > "$PART_DIR/002-Type-Aliases.md"
# Type Aliases

* 1. Defining new names for any type
* 2. **Types vs Interfaces**: Key Differences and Use Cases
EOF

# C. Type Guards / Narrowing
cat <<EOF > "$PART_DIR/003-Type-Guards-Narrowing.md"
# Type Guards / Narrowing

* 1. **\`typeof\`** Operator: Narrowing primitives
* 2. **\`instanceof\`**: Narrowing class instances
* 3. **Type Predicates**: User-Defined Type Guards (\`param is Type\`)
* 4. Truthiness Narrowing
* 5. Equality Narrowing
EOF

# D. Type Assertions
cat <<EOF > "$PART_DIR/004-Type-Assertions.md"
# Type Assertions

* 1. **\`as [type]\`**: Informing the compiler about a type
* 2. **\`as any\`**: Bypassing type checking with a cast
* 3. **\`as const\`**: Creating literal, immutable values
* 4. **Non-null Assertion** (\`!\`) Operator: Asserting a value is not \`null\` or \`undefined\`
* 5. **\`satisfies\` keyword**: Checking a type without casting (from TS 4.9)
EOF

# E. Literal Types
cat <<EOF > "$PART_DIR/005-Literal-Types.md"
# Literal Types

* 1. String Literal Types
* 2. Numeric Literal Types
* 3. Boolean Literal Types
EOF

# F. Template Literal Types
cat <<EOF > "$PART_DIR/006-Template-Literal-Types.md"
# Template Literal Types

* String interpolation at the type level (from TS 4.1)
EOF

# G. Recursive Types
cat <<EOF > "$PART_DIR/007-Recursive-Types.md"
# Recursive Types

* Types that refer to themselves (e.g., JSON structure)
EOF

# H. keyof Operator
cat <<EOF > "$PART_DIR/008-keyof-Operator.md"
# keyof Operator

* Creating a union of literal types representing an object's keys
EOF

# I. Indexed Access Types
cat <<EOF > "$PART_DIR/009-Indexed-Access-Types.md"
# Indexed Access Types (Lookup Types)

* Accessing a property's type by its key (\`Type['key']\`)
EOF

# J. Conditional Types
cat <<EOF > "$PART_DIR/010-Conditional-Types.md"
# Conditional Types

* 1. \`T extends U ? X : Y\`
* 2. Distributive Conditional Types
EOF

# K. Mapped Types
cat <<EOF > "$PART_DIR/011-Mapped-Types.md"
# Mapped Types

* Creating new types by iterating over existing types' properties
EOF

# L. Utility Types
cat <<EOF > "$PART_DIR/012-Utility-Types.md"
# Utility Types (Built-in Mapped and Conditional Types)

* 1. **\`Partial<T>\`**: Makes all properties of \`T\` optional
* 2. **\`Required<T>\`**: Makes all properties of \`T\` required
* 3. **\`Readonly<T>\`**: Makes all properties of \`T\` read-only
* 4. **\`Pick<T, K>\`**: Constructs a type by picking a set of properties \`K\` from \`T\`
* 5. **\`Omit<T, K>\`**: Constructs a type by omitting a set of properties \`K\` from \`T\`
* 6. **\`Exclude<T, U>\`**: Excludes from \`T\` those types that are assignable to \`U\`
* 7. **\`Extract<T, U>\`**: Extracts from \`T\` those types that are assignable to \`U\`
* 8. **\`NonNullable<T>\`**: Excludes \`null\` and \`undefined\` from \`T\`
* 9. **\`Record<K, T>\`**: Constructs an object type with properties \`K\` of type \`T\`
* 10. **\`Parameters<T>\`**: Extracts the parameter types of a function type \`T\`
* 11. **\`ReturnType<T>\`**: Extracts the return type of a function type \`T\`
* 12. **\`Awaited<T>\`**: Extracts the awaited type of a Promise (from TS 4.5)
* 13. **\`InstanceType<T>\`**: Extracts the instance type of a constructor function type \`T\`
EOF

# ==========================================
# Part IV: Organizing Code with Functions, Interfaces, and Classes
# ==========================================
PART_DIR="004-Organizing-Code"
mkdir "$PART_DIR"

# A. TypeScript Functions
cat <<EOF > "$PART_DIR/001-TypeScript-Functions.md"
# TypeScript Functions

* 1. **Typing Functions**: Parameters, Return Types
* 2. Optional and Default Parameters
* 3. Rest Parameters
* 4. Function Call Signatures
* 5. **Function Overloading**: Multiple type signatures for a single function implementation
EOF

# B. TypeScript Interfaces
cat <<EOF > "$PART_DIR/002-TypeScript-Interfaces.md"
# TypeScript Interfaces

* 1. **Interface Declaration**: Defining the "shape" of objects
* 2. Optional Properties (\`?\`)
* 3. Read-only Properties (\`readonly\`)
* 4. Function Types within Interfaces
* 5. Index Signatures (for dictionary-like objects)
* 6. **Extending Interfaces**: Inheritance of object shapes
* 7. **Hybrid Types**: Interfaces describing objects with both call and construct signatures
* 8. Declaration Merging for Interfaces
EOF

# C. Generics
cat <<EOF > "$PART_DIR/003-Generics.md"
# Generics

* 1. Introduction: Building Reusable Components with Type Parameters
* 2. Generic Functions
* 3. Generic Interfaces and Type Aliases
* 4. Generic Classes
* 5. **Generic Constraints**: Limiting Type Parameters (\`extends\`)
* 6. Using \`keyof\` with Generics for type-safe property access
EOF

# D. Classes in TypeScript
cat <<EOF > "$PART_DIR/004-Classes.md"
# Classes in TypeScript

* 1. Class Declaration and Instantiation
* 2. Properties and Methods
* 3. **Constructor Params**: Parameter Properties (e.g., \`public name: string\`)
* 4. **Access Modifiers**: \`public\`, \`private\`, \`protected\`
* 5. Read-only Properties (\`readonly\`)
* 6. Getters and Setters
* 7. Inheritance (\`extends\`, \`super()\`)
    * a. **Method Overriding**
    * b. **Inheritance vs Polymorphism**
* 8. **Abstract Classes**: Defining base classes with abstract members
* 9. Implementing Interfaces (\`implements\`)
* 10. **Constructor Overloading** (simulated via method overloading)
* 11. Static Members
* 12. **Decorators** (Experimental Feature, Stage 2 Proposal)
    * a. Class Decorators
    * b. Method Decorators
    * c. Property Decorators
    * d. Parameter Decorators
EOF

# ==========================================
# Part V: Modularity and Namespaces
# ==========================================
PART_DIR="005-Modularity-and-Namespaces"
mkdir "$PART_DIR"

# A. TypeScript Modules
cat <<EOF > "$PART_DIR/001-TypeScript-Modules.md"
# TypeScript Modules (ES Modules)

* 1. \`import\` and \`export\` statements
* 2. Default vs. Named Exports
* 3. Re-exporting
* 4. Module Resolution Strategies (\`baseUrl\`, \`paths\` in \`tsconfig.json\`)
* 5. **External Modules**: Working with Node.js modules and commonJS
EOF

# B. Namespaces
cat <<EOF > "$PART_DIR/002-Namespaces.md"
# Namespaces (Internal Modules)

* 1. Declaring and Using Namespaces (Legacy approach, often for global augmentation)
* 2. Nested Namespaces
* 3. Referencing Namespaces (\`/// <reference path="..." />\`)
* 4. **Namespace Augmentation** (Declaration Merging)
* 5. **Global Augmentation** (Extending global types)
EOF

# C. Declaration Merging
cat <<EOF > "$PART_DIR/003-Declaration-Merging.md"
# Declaration Merging

* 1. Interfaces
* 2. Modules (ES Modules)
* 3. Namespaces
EOF

# ==========================================
# Part VI: Tooling, Ecosystem, and Interoperability
# ==========================================
PART_DIR="006-Tooling-Ecosystem-Interoperability"
mkdir "$PART_DIR"

# A. TS and JS Interoperability
cat <<EOF > "$PART_DIR/001-TS-and-JS-Interoperability.md"
# TS and JS Interoperability

* 1. Using JavaScript Libraries in TypeScript
    * a. Type Declaration Files (\`.d.ts\`)
    * b. DefinitelyTyped (\`@types/\`)
    * c. Authoring \`.d.ts\` files
* 2. Migrating JavaScript Projects to TypeScript
* 3. Mixing JS and TS in a Single Project
EOF

# B. Ecosystem & Development Workflow
cat <<EOF > "$PART_DIR/002-Ecosystem-and-Workflow.md"
# Ecosystem & Development Workflow

* 1. **Build Tools**
    * a. Webpack, Rollup, Parcel (with \`ts-loader\` or \`awesome-typescript-loader\`)
    * b. Vite, Esbuild (modern, faster build tools)
    * c. Babel with \`@babel/preset-typescript\`
* 2. Code Quality
    * a. **Linting**: ESLint with TypeScript
    * b. **Formatting**: Prettier integration
* 3. **Useful Packages** and Libraries
    * a. Type-safe ORMs (e.g., TypeORM, Prisma, DrizzleORM)
    * b. Libraries with strong TypeScript support (e.g., React, Angular, Vue, Express, NestJS)
    * c. Utility Libraries (e.g., \`lodash-es\` with types)
EOF

echo "Done! Hierarchy created in $ROOT_DIR"
```
