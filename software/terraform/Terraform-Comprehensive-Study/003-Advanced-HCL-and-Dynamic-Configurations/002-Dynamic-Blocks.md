Here is a detailed explanation of **Part III, Section B: Dynamic Blocks**.

---

# 003 — Advanced HCL: Dynamic Blocks

In Terraform, most configurations are static: you write a resource block, define its arguments, and Terraform creates it. However, sometimes you need to configure a specific section of a resource **repeatedly** based on input data.

**Dynamic Blocks** allow you to generate nested configuration blocks (like ingress rules, disk attachments, or listeners) dynamically based on a collection (list or map), rather than hardcoding them one by one.

### 1. The Problem: Hardcoded Repetition
Imagine you are creating an AWS Security Group. A security group has `ingress` (incoming traffic) rules. Without dynamic blocks, if you wanted to open ports 80, 443, and 8080, you would have to write this:

```hcl
resource "aws_security_group" "example" {
  name = "web-server-sg"

  # Rule 1: HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule 2: HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule 3: Jenkins/App
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**Why this is bad:**
1.  **Violation of DRY:** You are repeating the same structure over and over.
2.  **Not Reusable:** If you turn this code into a module, the user cannot easily change the number of ports. They are stuck with exactly 3 rules unless you hardcode more.

---

### 2. The Solution: Dynamic Blocks syntax
Dynamic blocks act like a `for` loop *inside* a resource.

#### The Syntax
```hcl
dynamic "name_of_block" {
  for_each = collection_to_loop_over
  
  content {
    # arguments using the current item
    some_attribute = name_of_block.value
  }
}
```

#### Key Components:
1.  **`dynamic "label"`**: The name of the block usually expected by the provider (e.g., `ingress`, `tag`, `lifecycle_rule`).
2.  **`for_each`**: The complex value (list, set, or map) you want to iterate over.
3.  **`content`**: The actual body of the nested block that will be generated for every item in `for_each`.

---

### 3. Practical Example: Dynamic Ingress Rules
Let's refactor the Security Group example above using Dynamic Blocks.

**Step 1: Define the Variable**
We define the ports as a list variable.

```hcl
variable "allowed_ports" {
  description = "List of ports to open"
  type        = list(number)
  default     = [80, 443, 8080]
}
```

**Step 2: Use the Dynamic Block**

```hcl
resource "aws_security_group" "dynamic_sg" {
  name = "dynamic-web-sg"

  # Start the loop
  dynamic "ingress" {
    for_each = var.allowed_ports # Loop over [80, 443, 8080]
    
    content {
      from_port   = ingress.value 
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

**How it works:**
*   Terraform looks at `var.allowed_ports`. It sees 3 items.
*   It generates the `ingress` block 3 times.
*   Inside the content, we access the current item using `<BLOCK_NAME>.value` (in this case `ingress.value`).

---

### 4. Advanced Usage: Iterators and Complex Objects

Often, a simple list of numbers isn't enough. You might need to configure the port, the protocol, and the description for every rule.

**Variable with Objects:**
```hcl
variable "ingress_rules" {
  type = list(object({
    port        = number
    description = string
    protocol    = string
  }))
  default = [
    { port = 80,  description = "HTTP Traffic",  protocol = "tcp" },
    { port = 53,  description = "DNS Traffic",   protocol = "udp" }
  ]
}
```

**Dynamic Block with Custom Iterator:**
By default, you refer to the current item as `<block_name>.value` (e.g., `ingress.value`). You can change this name using the `iterator` argument to make the code more readable.

```hcl
resource "aws_security_group" "complex_sg" {
  name = "complex-dynamic-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = rule # <--- Renaming the iterator object

    content {
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = rule.value.protocol
      description = rule.value.description
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

*Note: If you use `iterator = rule`, you access data via `rule.value`. If you don't use it, you would access data via `ingress.value`.*

---

### 5. Nested Dynamic Blocks vs. Resource `for_each`
It is crucial to understand the difference between these two concepts:

| Feature | `for_each` (Meta-Argument) | `dynamic` Block |
| :--- | :--- | :--- |
| **Where it gets placed** | At the top level of a `resource` | Inside a `resource` block |
| **What it creates** | Multiple distinct instances of the **Resource** (e.g., 5 EC2 instances) | Multiple nested configuration blocks inside **one** Resource (e.g., 1 Security Group with 5 rules) |
| **State File Impact** | Creates `aws_instance.web["server1"]`, `aws_instance.web["server2"]` | Creates one resource `aws_security_group.web` containing multiple internal rules |

---

### 6. Best Practices and Warnings

1.  **Don't Overuse Them:** Dynamic blocks make code harder to read. If you only have one or two static blocks, write them out manually. Only use `dynamic` if the data varies significantly based on inputs.
2.  **Avoid Excessive Nesting:** You *can* put a dynamic block inside another dynamic block, but it becomes very difficult to debug.
3.  **Use `for_each` over `count`:** When feeding data into a dynamic block, try to ensure your list order doesn't matter, or use a map/set.

### Summary Checklist
*   **Purpose:** To generate repeated nested blocks (like `ingress`, `listener`, `origin`) within a resource.
*   **Input:** Requires a list, set, or map passed to `for_each`.
*   **Access:** Use the `<name>.value` syntax or a custom `iterator`.
