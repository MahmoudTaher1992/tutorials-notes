Based on the Table of Contents you provided, here is a detailed explanation of **Part VIII, Section B: Loops**.

Loops are fundamental to automation. They allow you to tell the shell: "Do this specific task X number of times," or "Do this task for every single file in this folder."

Here are the three main types of loops in Bash and how to control them.

---

# 1. The `for` Loop
The `for` loop is effective when you have a specific list of items (like a list of numbers, a group of strings, or files in a directory) and you want to process them one by one.

### Syntax
```bash
for variable in list
do
    # Commands to run for each item
done
```

### Modes of Operation:

#### A. Iterating over a list of strings
The shell takes the first item in the list, assigns it to `item`, runs the code, then grabs the next item.
```bash
for fruit in apple banana cherry
do
    echo "I really like $fruit"
done
```

#### B. Iterating over files (Globbing)
This is the most powerful use of the `for` loop in system administration. You can use wildcards (`*`) to iterate over files.
```bash
# Rename all .txt files to .md
for file in *.txt
do
    mv "$file" "${file%.txt}.md"
done
```

#### C. Iterating over a Range (Brace Expansion)
Great for creating sequences.
```bash
# Create 5 backup folders
for i in {1..5}
do
    mkdir "backup_$i"
done
```

#### D. C-Style Syntax
If you come from C, Java, or C++, this looks familiar. It is mostly used for counting.
```bash
# (( initialize ; condition ; increment ))
for (( i=0; i<5; i++ ))
do
    echo "Counter is at: $i"
done
```

---

# 2. The `while` Loop
The `while` loop runs **as long as a condition is true**. It checks the condition *before* running the code block. If the condition is false initially, the code never runs.

### Syntax
```bash
while [ condition ]
do
    # Commands to run
done
```

### Common Use Cases:

#### A. Standard Condition Check
```bash
count=1
while [ $count -le 5 ]  # While count is Less than or Equal to 5
do
    echo "Count: $count"
    ((count++))         # Increment count
done
```

#### B. Reading a File Line-by-Line
This is a standard idiom in Bash for processing text files.
```bash
# Reads 'input.txt' one line at a time
while read -r line
do
    echo "Processing line: $line"
done < input.txt
```

#### C. Infinite Loops (Daemons/Monitoring)
Sometimes you want a script to run forever (until you stop it with Ctrl+C).
```bash
while true
do
    echo "Monitoring system..."
    sleep 5 # Wait 5 seconds before repeating
done
```

---

# 3. The `until` Loop
The `until` loop is the exact opposite of the `while` loop. It runs **until a condition becomes true**. In other words, it keeps looping **as long as the condition is false**.

### Syntax
```bash
until [ condition ]
do
    # Commands to run
done
```

### Common Use Case: Waiting for a resource
This is excellent for waiting for a server to come online or a file to be created.

```bash
# Keep trying to ping google.com until it works
until ping -c 1 google.com
do
    echo "Waiting for internet connection..."
    sleep 2
done
echo "We are online!"
```

---

# 4. Loop Logic Control (`break` and `continue`)
Sometimes you need to interfere with the standard flow of a loop.

### A. `break`
This **exits the loop completely** immediately. It stops all further iterations.

**Scenario:** You are searching for a specific file. Once you find it, you don't need to check the rest.

```bash
for file in *
do
    if [ "$file" == "target_file.txt" ]; then
        echo "Found the file!"
        break # Stop looping immediately
    fi
done
```

### B. `continue`
This **skips the rest of the current iteration** and jumps back to the top of the loop to start the next item.

**Scenario:** You want to process files, but you want to ignore "tmp" files.

```bash
for file in *
do
    # If the file name starts with "tmp", skip it
    if [[ "$file" == tmp* ]]; then
        continue # Don't run the code below, go to next file
    fi
    
    echo "Processing valuable file: $file"
done
```

---

# Summary of Differences

| Type | Best Used When... | Logic |
| :--- | :--- | :--- |
| **`for`** | You know exactly **what items** or **how many times** you want to iterate. | Iterate through a list. |
| **`while`** | You want to run **while** something is valid (or reading streams/files). | Run while True. |
| **`until`** | You are **waiting** for a specific event to happen. | Run while False (Run until True). |
