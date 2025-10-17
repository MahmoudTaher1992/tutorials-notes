Here is a detailed Table of Contents for studying TypeScript, mirroring the structure and depth of the REST API TOC you provided, incorporating all your keywords and expanding on them for a comprehensive learning path.

---

*   **Part I: Introduction and Setup**
    *   **A. Introduction to TypeScript**
        *   1. What is TypeScript? (Superset of JavaScript, benefits, goals)
        *   2. Why TypeScript? (Type Safety, Better Tooling, Scalability, Readability, Refactoring)
        *   3. **TypeScript vs JavaScript**: Key Differences and Advantages
            *   a. Static vs. Dynamic Typing
            *   b. Compile-time vs. Runtime Checks
            *   c. Feature Parity and Transpilation
    *   **B. Installation and Configuration**
        *   1. **Installation and Configuration**
            *   a. Global Installation (`npm install -g typescript`)
            *   b. Local Project Installation
        *   2. **Running TypeScript** Code
            *   a. **`tsc`**: The TypeScript Compiler
                *   i. Compiling single files and projects
                *   ii. Watching for file changes (`--watch`)
            *   b. **`ts-node`**: Executing TypeScript Directly
            *   c. **TS Playground**: Online Sandbox for Learning and Experimentation
        *   3. **`tsconfig.json`**: The Project Configuration File
            *   a. Understanding **Compiler Options** (`compilerOptions`)
                *   i. `target`, `module`, `lib`
                *   ii. `strict` (all strict mode options), `noImplicitAny`, `strictNullChecks`
                *   iii. `esModuleInterop`, `allowSyntheticDefaultImports`
                *   iv. `forceConsistentCasingInFileNames`, `skipLibCheck`
                *   v. `outDir`, `rootDir`, `declaration`, `sourceMap`
                *   vi. `resolveJsonModule`, `isolatedModules`
            *   b. `include`, `exclude`, `files`: Defining Project Scope
    *   **C. Fundamental Concepts**
        *   1. **Type Inference**: Automatic Type Detection by the Compiler
        *   2. **Type Compatibility**: Understanding Structural Typing
        *   3. The `declare` Keyword: Ambient Declarations for External JavaScript

*   **Part II: Core Types and Type System Fundamentals**
    *   **A. Primitive Types**
        *   1. **`boolean`**: True or False values
        *   2. **`number`**: All Numeric values (integers, floats, hex, binary, octal)
        *   3. **`string`**: Textual data
        *   4. **`void`**: The absence of any type (often for function return types)
        *   5. **`undefined`**: A variable that has not been assigned a value
        *   6. **`null`**: An intentional absence of any object value
    *   **B. Object Types**
        *   1. **`Array`**: Collections of a single type (`Type[]` or `Array<Type>`)
        *   2. **`Tuple`**: Fixed-length, ordered arrays with specific types at each position
        *   3. **`Object`**: Non-primitive type (any value not a primitive)
    *   **C. Special Types**
        *   1. **`Enum`**: Enumerated types for sets of named constants (Numeric and String enums)
    *   **D. Top and Bottom Types**
        *   1. **`any`**: Opt-out of type checking (a "Top Type")
        *   2. **`unknown`**: A type-safe alternative to `any` (a "Top Type")
        *   3. **`never`**: A type that represents values that never occur (a "Bottom Type")
        *   4. Understanding **Top Types** vs. **Bottom Types** in the Type Hierarchy

*   **Part III: Advanced Types and Type Operations**
    *   **A. Combining Types**
        *   1. **Union Types**: A value can be one of several types (`Type1 | Type2`)
        *   2. **Intersection Types**: A value must possess all properties of several types (`Type1 & Type2`)
    *   **B. Type Aliases**
        *   1. Defining new names for any type
        *   2. **Types vs Interfaces**: Key Differences and Use Cases
    *   **C. Type Guards / Narrowing**
        *   1. **`typeof`** Operator: Narrowing primitives
        *   2. **`instanceof`**: Narrowing class instances
        *   3. **Type Predicates**: User-Defined Type Guards (`param is Type`)
        *   4. Truthiness Narrowing
        *   5. Equality Narrowing
    *   **D. Type Assertions**
        *   1. **`as [type]`**: Informing the compiler about a type
        *   2. **`as any`**: Bypassing type checking with a cast
        *   3. **`as const`**: Creating literal, immutable values
        *   4. **Non-null Assertion** (`!`) Operator: Asserting a value is not `null` or `undefined`
        *   5. **`satisfies` keyword**: Checking a type without casting (from TS 4.9)
    *   **E. Literal Types**
        *   1. String Literal Types
        *   2. Numeric Literal Types
        *   3. Boolean Literal Types
    *   **F. Template Literal Types**: String interpolation at the type level (from TS 4.1)
    *   **G. Recursive Types**: Types that refer to themselves (e.g., JSON structure)
    *   **H. `keyof` Operator**: Creating a union of literal types representing an object's keys
    *   **I. Indexed Access Types (Lookup Types)**: Accessing a property's type by its key (`Type['key']`)
    *   **J. Conditional Types**: `T extends U ? X : Y`
        *   1. Distributive Conditional Types
    *   **K. Mapped Types**: Creating new types by iterating over existing types' properties
    *   **L. Utility Types (Built-in Mapped and Conditional Types)**
        *   1. **`Partial<T>`**: Makes all properties of `T` optional
        *   2. **`Required<T>`**: Makes all properties of `T` required
        *   3. **`Readonly<T>`**: Makes all properties of `T` read-only
        *   4. **`Pick<T, K>`**: Constructs a type by picking a set of properties `K` from `T`
        *   5. **`Omit<T, K>`**: Constructs a type by omitting a set of properties `K` from `T`
        *   6. **`Exclude<T, U>`**: Excludes from `T` those types that are assignable to `U`
        *   7. **`Extract<T, U>`**: Extracts from `T` those types that are assignable to `U`
        *   8. **`NonNullable<T>`**: Excludes `null` and `undefined` from `T`
        *   9. **`Record<K, T>`**: Constructs an object type with properties `K` of type `T`
        *   10. **`Parameters<T>`**: Extracts the parameter types of a function type `T`
        *   11. **`ReturnType<T>`**: Extracts the return type of a function type `T`
        *   12. **`Awaited<T>`**: Extracts the awaited type of a Promise (from TS 4.5)
        *   13. **`InstanceType<T>`**: Extracts the instance type of a constructor function type `T`

*   **Part IV: Organizing Code with Functions, Interfaces, and Classes**
    *   **A. **TypeScript Functions**
        *   1. **Typing Functions**: Parameters, Return Types
        *   2. Optional and Default Parameters
        *   3. Rest Parameters
        *   4. Function Call Signatures
        *   5. **Function Overloading**: Multiple type signatures for a single function implementation
    *   **B. **TypeScript Interfaces**
        *   1. **Interface Declaration**: Defining the "shape" of objects
        *   2. Optional Properties (`?`)
        *   3. Read-only Properties (`readonly`)
        *   4. Function Types within Interfaces
        *   5. Index Signatures (for dictionary-like objects)
        *   6. **Extending Interfaces**: Inheritance of object shapes
        *   7. **Hybrid Types**: Interfaces describing objects with both call and construct signatures
        *   8. Declaration Merging for Interfaces
    *   **C. **Generics**
        *   1. Introduction: Building Reusable Components with Type Parameters
        *   2. Generic Functions
        *   3. Generic Interfaces and Type Aliases
        *   4. Generic Classes
        *   5. **Generic Constraints**: Limiting Type Parameters (`extends`)
        *   6. Using `keyof` with Generics for type-safe property access
    *   **D. **Classes** in TypeScript
        *   1. Class Declaration and Instantiation
        *   2. Properties and Methods
        *   3. **Constructor Params**: Parameter Properties (e.g., `public name: string`)
        *   4. **Access Modifiers**: `public`, `private`, `protected`
        *   5. Read-only Properties (`readonly`)
        *   6. Getters and Setters
        *   7. Inheritance (`extends`, `super()`)
            *   a. **Method Overriding**
            *   b. **Inheritance vs Polymorphism**
        *   8. **Abstract Classes**: Defining base classes with abstract members
        *   9. Implementing Interfaces (`implements`)
        *   10. **Constructor Overloading** (simulated via method overloading)
        *   11. Static Members
        *   12. **Decorators** (Experimental Feature, Stage 2 Proposal)
            *   a. Class Decorators
            *   b. Method Decorators
            *   c. Property Decorators
            *   d. Parameter Decorators

*   **Part V: Modularity and Namespaces**
    *   **A. **TypeScript Modules** (ES Modules)
        *   1. `import` and `export` statements
        *   2. Default vs. Named Exports
        *   3. Re-exporting
        *   4. Module Resolution Strategies (`baseUrl`, `paths` in `tsconfig.json`)
        *   5. **External Modules**: Working with Node.js modules and commonJS
    *   **B. **Namespaces** (Internal Modules)
        *   1. Declaring and Using Namespaces (Legacy approach, often for global augmentation)
        *   2. Nested Namespaces
        *   3. Referencing Namespaces (`/// <reference path="..." />`)
        *   4. **Namespace Augmentation** (Declaration Merging)
        *   5. **Global Augmentation** (Extending global types)
    *   **C. Declaration Merging**
        *   1. Interfaces
        *   2. Modules (ES Modules)
        *   3. Namespaces

*   **Part VI: Tooling, Ecosystem, and Interoperability**
    *   **A. **TS and JS Interoperability**
        *   1. Using JavaScript Libraries in TypeScript
            *   a. Type Declaration Files (`.d.ts`)
            *   b. DefinitelyTyped (`@types/`)
            *   c. Authoring `.d.ts` files
        *   2. Migrating JavaScript Projects to TypeScript
        *   3. Mixing JS and TS in a Single Project
    *   **B. **Ecosystem** & Development Workflow
        *   1. **Build Tools**
            *   a. Webpack, Rollup, Parcel (with `ts-loader` or `awesome-typescript-loader`)
            *   b. Vite, Esbuild (modern, faster build tools)
            *   c. Babel with `@babel/preset-typescript`
        *   2. Code Quality
            *   a. **Linting**: ESLint with TypeScript
            *   b. **Formatting**: Prettier integration
        *   3. **Useful Packages** and Libraries
            *   a. Type-safe ORMs (e.g., TypeORM, Prisma, DrizzleORM)
            *   b. Libraries with strong TypeScript support (e.g., React, Angular, Vue, Express, NestJS)
            *   c. Utility Libraries (e.g., `lodash-es` with types)