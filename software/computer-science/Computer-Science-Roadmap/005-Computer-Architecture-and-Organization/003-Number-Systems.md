Based on the roadmap provided, **Part V (Computer Architecture), Section C (Number Systems)** is fundamental to understanding how computers perceive, store, and manipulate data. Unlike humans who process information abstractly or in base-10, computers work strictly with electrical signals representing On/Off states.

Here is a detailed explanation of each concept mentioned in that section:

---

### 1. Binary, Decimal, Hexadecimal, Octal
These are different **bases** (or radixes) for representing numbers.

*   **Binary (Base-2):**
    *   **The Language of Computers:** Uses only two digits `0` and `1`.
    *   **Why?** Physically implemented using transistors (switches) that are either Off (0) or On (1).
    *   *Example:* The number 5 is written as `101` ($1\times2^2 + 0\times2^1 + 1\times2^0$).

*   **Decimal (Base-10):**
    *   **The Language of Humans:** Uses digits `0-9`.
    *   **Why?** Likely because we have ten fingers. Computer science focuses heavily on converting human-readable Decimal to machine-readable Binary.

*   **Hexadecimal (Base-16):**
    *   **The "Shorthand" for Binary:** Uses digits `0-9` and letters `A-F` (where A=10, F=15).
    *   **Why?** Binary strings get very long and hard for humans to read (e.g., `11111111`). Hex compacts 4 bits into 1 character.
    *   *Example:* `1111 1111` (binary) = `255` (decimal) = `FF` (hex).
    *   *Use Case:* Memory addresses, CSS colors (#FFFFFF), MAC addresses.

*   **Octal (Base-8):**
    *   **Legacy/Specific Use:** Uses digits `0-7`.
    *   **Why?** Represents 3 bits per digit. It was popular in early computing (like the PDP-8) but is less common now than Hex.
    *   *Use Case:* Unix/Linux file permissions (e.g., `chmod 755`).

---

### 2. Signed vs. Unsigned Representation
This concept deals with how we represent specific integer ranges, specifically negative numbers, within a fixed number of bits (like 8-bit or 32-bit).

*   **Unsigned Representation:**
    *   Only represents non-negative numbers (0 to positive infinity).
    *   All bits are used for the magnitude (value).
    *   *Example (8-bit):* `00000000` is 0, `11111111` is 255.

*   **Signed Representation:**
    *   Can represent both positive and negative numbers. To do this, we must sacrifice one bit to perform the role of a "sign."
    *   There are three common ways to do this:
        1.  **Sign-Magnitude:** The first bit is the sign (0=+, 1=-), the rest is the number. (Flawed because it allows +0 and -0).
        2.  **1’s Complement:** To get a negative, simply flip all bits of the positive number. (Also allows +0 and -0).
        3.  **2’s Complement (The Standard):** To represent a negative number, flip all bits of the positive number and **add 1**.
            *   *Why use it?* It eliminates the "double zero" problem and makes hardware arithmetic (addition/subtraction) extremely efficient.
            *   *Example:* If `00000001` is 1, then `11111111` is -1 in 2's complement.

---

### 3. Endianness: Big vs. Little Endian
Endianness describes the **order** in which a sequence of bytes is stored in computer memory. This matters when data spans multiple bytes (like a 32-bit integer, which requires 4 bytes).

Imagine you want to store the hexadecimal value `0x12345678`.
*   `12` is the Most Significant Byte (MSB).
*   `78` is the Least Significant Byte (LSB).

*   **Big Endian:**
    *   Stores the **Big end (MSB)** first (at the lowest memory address).
    *   *Memory layout:* `[12] [34] [56] [78]`
    *   *Analogy:* Like reading English numbers left-to-right.
    *   *Usage:* Network protocols (TCP/IP) use this, often called "Network Byte Order."

*   **Little Endian:**
    *   Stores the **Little end (LSB)** first (at the lowest memory address).
    *   *Memory layout:* `[78] [56] [34] [12]`
    *   *Analogy:* Like writing dates in Europe (Day-Month-Year) where the smallest unit comes first.
    *   *Usage:* Most modern CPUs (Intel x86, AMD, Apple Silicon/ARM) use this.

*   *Why this matters:* If a Big Endian server sends data to a Little Endian computer, the computer will read the numbers backwards unless the software converts it first.

---

### 4. Floating-Point Representation (IEEE 754)
Integers (1, 2, 500) are easy to store in binary. But how do we store numbers with decimals (3.14159) or incredibly large/small numbers (atoms in the universe)? We cannot use a fixed decimal point.

We use **Scientific Notation** for binary: $1.mantissa \times 2^{exponent}$. The **IEEE 754** standard defines how to pack this into 32 bits (single precision) or 64 bits (double precision).

**The 32-bit layout consists of:**
1.  **Sign Bit (1 bit):** 0 for positive, 1 for negative.
2.  **Exponent (8 bits):** Determines the magnitude (where the decimal point "floats"). It uses a "bias" (usually 127) to handle negative exponents without sign bits.
3.  **Mantissa / Significand (23 bits):** The actual digits of the number (the precision).

**Key Takeaways:**
*   **Trade-off:** Floating point math sacrifices *exactness* for *range*. You can represent huge numbers, but you might lose precision (e.g., $0.1 + 0.2$ often equals $0.30000000000000004$ in computers due to binary rounding errors).
*   **Special values:** IEEE 754 has special bit patterns reserved for Infinity (`INF`) and Not-a-Number (`NaN`).
