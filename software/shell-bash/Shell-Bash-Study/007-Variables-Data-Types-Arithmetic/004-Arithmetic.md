Based on the Table of Contents item **007-Variables-Data-Types-Arithmetic / 004-Arithmetic.md**, here is a detailed explanation of how arithmetic works in Bash.

It is important to understand that natively, **Bash treats everything as a string.** If you type `a=1+1`, Bash doesn't see "2", it literally sees the string "1+1". Because of this, we need specific syntax to tell Bash to behave like a calculator.

Here are the three main topics covered in that section:

---

### 1. Arithmetic Expansion: `((...))`
This is the modern, preferred way to do math in Bash. It is fast, readable, and supports C-style syntax. Note that **Bash only supports integers (whole numbers)** natively. It cannot do decimals (1.5, 3.14) without external tools (see section 3).

There are two ways to use the double parenthesis syntax:

#### A. Substitution: `$(( expression ))`
Use this when you want to calculate a result and assign it to a variable or print it out.

```bash
num1=5
num2=10

# Calculate and save to a variable
sum=$(( num1 + num2 ))

# Calculate and print immediately
echo "The result is $(( num1 * num2 ))"
```
*Note: Inside the double parentheses, you don't need to use the `$` sign before variable names.*

#### B. Evaluation/Logic: `(( expression ))`
Use this without the leading `$` when you want to change variables or perform logic without printing the result. This is commonly used for incrementing loops or `if` statements.

```bash
i=0

# Increment i by 1 (C-style syntax)
(( i++ )) 

# Complicated assignment
(( i += 5 ))

# Using it in logic (returns true/success if result is non-zero)
if (( i > 3 )); then
  echo "i is greater than 3"
fi
```

### 2. Legacy Tools: `let` and `expr`
You will encounter these in older scripts (written 10-20 years ago). Ideally, you should not use them for new scripts, but you must know how to read them.

#### A. `let`
`let` is a shell builtin command. It behaves very similarly to `(( ))` but has a stricter syntax (no spaces around the `=` sign are allowed).

```bash
# Correct way
let result=5+5
echo $result  # Output: 10

# Wrong way (will error)
let result = 5 + 5
```

#### B. `expr`
`expr` is an external command (not built into the shell). It is old, slow, and clunky. It requires spaces between every distinct item and often requires escaping special characters.

```bash
# You must put spaces around the +
result=$(expr 5 + 5)

# You must escape the multiplication symbol (*) because Bash thinks it's a wildcard
result=$(expr 5 \* 5)
```
*Why we don't use it anymore:* It spawns a new process (slow), and the syntax is frustrating.

### 3. Floating Point Math: Using `bc`
As mentioned, Bash **cannot** calculate `5.5 + 1.2`. If you try `$(( 5.5 + 1.2 ))`, Bash will give you a syntax error.

To do decimal math, we pipe the math equation into a command called `bc` (Basic Calculator). `bc` is a separate specific language designed for arbitrary-precision arithmetic.

#### Basic Usage
We use `echo` to send a string to `bc`.

```bash
echo "5.5 + 1.2" | bc
# Output: 6.7
```

#### Handling Division (Scale)
By default, `bc` also truncates large divisions. You must set the `scale` (number of decimal places) to get distinct results for division.

```bash
# Without scale
echo "10 / 3" | bc
# Output: 3

# With scale (tell it to use 2 decimal places)
echo "scale=2; 10 / 3" | bc
# Output: 3.33
```

#### Using Variables with `bc`
Because `bc` doesn't know your Bash variables, you must let Bash expand them *before* sending them to `bc`.

```bash
num1=10.5
num2=2.5

result=$(echo "$num1 + $num2" | bc)
echo $result
# Output: 13.0
```

### Summary of Common Operators
When using `(( ))` or `let`, you have access to these standard operators:

| Operator | Description | Example `(( x... ))` |
| :--- | :--- | :--- |
| `+` | Addition | `sum = 1 + 1` |
| `-` | Subtraction | `sub = 5 - 2` |
| `*` | Multiplication | `mul = 5 * 5` |
| `/` | Division (Integer only!) | `div = 10 / 3` (Result is 3) |
| `%` | Modulo (Remainder) | ` mod = 10 % 3` (Result is 1) |
| `**`  | Exponentiation (Power of) | `pow = 2 ** 3` (Result is 8) |
| `++` | Increment | `i++` |
| `--` | Decrement | `i--` |
