# 🎯 Mini Programming Language Compiler (Lexical, Syntax & Semantic Analyzer)

This project is a simplified compiler front-end for a **custom structured programming language**, similar to Pascal. It includes:

- **Lexical Analysis** with Flex
- **Syntax and Semantic Analysis** with Bison
- **Symbol Table Management**
- **Intermediate Code Generation** using Quadruples

---

## 📚 Features

✅ Lexical Analysis:
- Keywords, identifiers, constants, operators, etc.
- Tracks line/column positions
- Detects lexical errors (like long identifiers)

✅ Syntax Analysis:
- Program blocks (`PROGRAMME`, `VAR`, `BEGIN`, `END`)
- Declarations, assignments, expressions
- Control flow: `IF`, `ELSE`, `FOR`, `WHILE`
- Input/Output: `READLN`, `WRITELN`

✅ Semantic Analysis:
- Type checking
- Constant protection
- Range checking for arrays

✅ Intermediate Code Generation:
- Quadruplet representation of operations

---

## 🛠️ How to Compile and Run

### Requirements

- Linux (recommended)
- GCC, Flex, Bison installed

### Build & Run

```bash
bison -d syntaxique.y
flex lexical.l
gcc -o compiler syntaxique.tab.c lex.yy.c ts.c -lfl
./compiler < test.pas
