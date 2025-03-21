# Simple Calculator using Lex & Yacc

## Overview
This project implements a simple calculator that supports arithmetic expressions such as '+', '-', '*', '/', '^' using **Lex and Yacc**.


## Features
- Supports integer and floating-point numbers.
- Handles basic arithmetic operations: **+, -, *, /**.
- Supports **parentheses** for operation precedence.
- Implements **exponentiation (^)**. (Usage : 3^4 )
- Includes error handling for invalid syntax and division by zero.


## Installation
### Prerequisties
Ensure you have the following tools installed:
- **Flex** (Lex implementation)
- **Bison** (Yacc implementation)
- **GCC** (C compiler)

While the installation may differ, to install them on Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install flex bison gcc -y
```
### Compilation and Execution
Run the following commands while $pwd is the root directory(one of the version dir) of the project, to compile and execute the calculator:

1. Generate the lex scanner (using flex):
   ```bash
   flex calculator.l
   ```

2. Generate the Yacc parser (using bison):
   ```bash
   bison -d calculator.y
   ```

3. Compile everything seperately and bind them:
   ```bash
   gcc -c calculator.tab.c
   gcc -c lex.yy.c
   gcc -o calculator calculator.tab.o lex.yy.o -lm
   ```
   > `-lm` is required to link the math library for exponentiation. (Note that it is not required when compiling the version1.)

4. Run the calculator:
   ```bash
   ./calculator
   ```

5. Select Mode 0 to see the test case results.


# Grammar and Extensions
Initially, the grammar used was:
```
expr -> expr + expr  
expr -> expr - expr  
expr -> expr * expr  
expr -> expr / expr  
expr -> ( expr )  
expr -> NUMBER  
```
While this grammar was sufficient for basic arithmetic, it did not correctly handle **floating-point operations** because with this grammar we could only output int or we could output float if we design that way.  Additionally, some expressions should be processed as **integers** and others as **floating-point numbers** dynamically. If 2 input is an instance of int, it should not output float. 

To address this, the grammar was extended as follows:
```
expr -> FLOAT  
expr -> INTEGER  
```
Now, an expression can be either an **integer (INTEGER)** or a **floating-point number (FLOAT)**. However, since we do not know whether an incoming value is an integer or a float beforehand, we store the data using a **union structure**.  

**With this modification:**
- Integer operations remain as **integers** when needed.
- Floating-point operations are performed where required.
- Division (`/`) is automatically handled as integer division or floating-point division based on the input types.


## Limitations
Although the grammar allows for basic arithmetic operations, it has inherent **ambiguity** in its structure. Due to this ambiguity, users are expected to use **parentheses** for complex expressions to explicitly define the order of operations.  

For instance, an input like:
```
10 / 5 + 2 * 4
```
is **not supported** due to the grammar's limitations. Instead, users should explicitly structure their expressions as:
```
(10 / 5) + (2 * 4)
```
This assumption simplifies parsing and avoids potential precedence issues.

Also it is not recommended that using exponential operator within large order of operations due to the grammar's ambiguity and because of there is no precedence rule in our given grammar, there might be overflows or wrong calculations. So make sure use '(' and ')' when building large blocks of expressions.

Lastly it is assumed that integer processes take precedence over floating points so that for instance 8.0 / 3 or 8 / 3.0 or 8.0 / 3.0 equals to 8 / 3 ,because 8.0 or 3.0 can be stored as integers, which leads us to an integer division. 

## Versions
Two different versions of the calculator have been uploaded seperately since they have different grammars.

- **Version 1**: Implements only basic **integer arithmetic operations** using the initial grammar. It does not support floating-point numbers or exponentiation.
- **Version 2**: Extends the grammar to support **floating-point operations** and **exponentiation (^)**. This version properly distinguishes between integer and floating-point arithmetic.


## Error Handling
- **Invalid syntax**: Returns a syntax error message.
- **Division by zero**: Displays an error message and stops execution.


## Implementation Steps
The project was implemented in the following steps:

1. **Lexical Analysis with Lex**
   - Defined rules for numbers, operators, and parentheses.
   - Ignored whitespace.
   - Assigned appropriate tokens (`NUMBER`, `PLUS`, `MINUS`, etc.).

2. **Parsing with Yacc**
   - Defined grammar rules (`expr -> expr + expr`, etc.).
   - Set the rules and operations (parentheses, multiplication/division, addition/subtraction).
   - Added support for exponentiation (`^`).
   - Implemented actions (`$$ = $1 + $3;` etc.) for computations.

3. **Compilation and Linking**
   - Used `lex` and `yacc` to generate `lex.yy.c` and `y.tab.c`.
   - Compiled the program with `gcc -lm` to link the math library.

4. **Testing**
   - Evaluated arithmetic expressions.
   - Tested expressions with parentheses.
   - Checked division by zero handling.
   - Verified error handling for invalid syntax.


## Author Information
Korhan Sevinc  TOBB University of Economics and Technology