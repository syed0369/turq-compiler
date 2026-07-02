# TURQ

![Turq-logo](turq.png)

An implementation of a turing based compiler in lex and yacc

# Running the Turq Compiler

## Prerequisites

Ensure the following tools are installed:

* GCC
* LEX
* YACC
* NASM
* GNU Linker (`ld`)

On Ubuntu/WSL:

```bash
sudo apt update
sudo apt install build-essential flex bison nasm
```

Verify the installation:

```bash
gcc --version
lex --version
yacc --version
nasm -v
ld --version
```

---

## Step 1: Build the Compiler

Compile the lexer, parser, and compiler:

```bash
make
```

Or manually:

```bash
yacc -d yacc.y
lex lex.l
gcc lex.yy.c y.tab.c -o turq
```

---

## Step 2: Write a Turq Program

Create a source file, for example `first.tq`:

```text
inc 65
print
halt
```

---

## Step 3: Compile to Assembly

Generate x86-64 NASM assembly:

```bash
./turq first.tq > first.asm
```

This produces an assembly file named `first.asm`.

---

## Step 4: Assemble the Program

Convert the assembly into an object file:

```bash
nasm -f elf64 first.asm -o first.o
```

---

## Step 5: Link the Object File

Create the executable:

```bash
ld first.o -o first
```

---

## Step 6: Run the Program

Execute the generated program:

```bash
./first
```

If the program expects input from standard input:

```bash
echo "(())" | ./parent_check
```

or

```bash
./paren_check
```

and type the input manually.

---

## Complete Compilation Pipeline

```bash
make
./turq first.tq > first.asm
nasm -f elf64 first.asm -o first.o
ld first.o -o first
./first
```

Another option is to change the INPUT variable in `Makefile` to the turq source code file and run 
```bash
make run
```
