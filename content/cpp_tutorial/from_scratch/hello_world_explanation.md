---
layout: article
---

### Basic structure

Every C++ (and C) program consists of **statements** and **functions** (note: if you heard the term *class* already it can be seen as a definition statement). Statements consist of **expressions**.

Statements are analogic to human language sentences and expressions are analogic to words and punctuation.

```c++
int x = 5; // this code is a statement
// "x = 5" is an expression, just like "a + b" 
```

**Every statement ends with `;`.** Statements may be empty or contain multiple expressions.

```c++
; // This is a valid empty statement. This instruction does nothing (may trigger a compiler warning because it's useless)
int i = x + y + z; // this statement has multiple (sub)expressions
```

Other example expressions:

```c++
1 + 2
3 * 4
5 % 6
[](){}
struct s
foo::bar
3.14 * (r * r)
y = f(x)
(x - a) + (y - b)
std::cout << "hello, world"
```

Generally whitespace characters (spaces, tabs, new lines, ...) are ignored by the compiler. This means that `x+y` works the same as `x + y` or `x   +y`. Obviously whitespace separates names so `ab` will be one name "ab" while `a b` will represent 2 names "a" and "b".

Whitespace characters are not ignored in quoted strings such as `" "` or `' '` (these are the text you put inside the program).

**Functions**

Multiple statements can be grouped to form a **function**. 

```c++
//(1) (2)   (3)  
int square(int x)
{ // <- (4)
    int result = x * x;
    return result;
}
```

- (1) (`int`) - function return type. Indicates what type of result the function *returns*. Functions which do not return any meaningful value can be declared to have `void` return type.

- (2) (`square`) - the name of the function
- (3) (`(int x)`) - function arguments and their types
- (4) (everything between `{` and `}`) - function body. This groups multiple statements

Functions form a reusable pieces of code. Function `square` can be called as many times as wanted without the need to write it's body again.

**Every executable C++ program must have a main function** (you can build non-executable libraries but that's not the scope of this tutorial).

**Identifiers**

Everything than can be later referred to has an **identifier**. It's just the name of the entity.

Valid names can consist of:

- lowercase latin letters (a - z)
- uppercase latin letters (A - Z)
- underscore symbol (_)
- digits (0 - 9), with the exception that the name can not start with a digit

Actually there are more possible characters but REALLY NO ONE uses them and tools, including compilers many not support them.

Example valid identifiers:

```c++
func
x1
x2
y
foo_bar
a_b_c_d_e_f
XABCDX
WeIrD_nAmE
```

Example invalid identifiers:

```c++
if  // (this is a language keyword)
1x  // this is a number, not an identifier
x@y // symbol @ is reserved
```

Additionally, the C++ standard reserves following names (you should not use them):

- `_X*` - anything beginning with an underscore followed by an uppercase letter
- `__*` - anything beginning with 2 underscores
- anything containing 2 underscores
- anything in the namespace `std`
- anything in the namespace `posix`

More about namespaces later. For now, simply remember to not start names with `_` character.

**Libraries**

Libraries are just code bases (compiled or not) with multiple functions (and classes and templates and other...) than can be reused. This tutorial uses various parts of C++ **standard library** (which comes with the compiler). Additional codebases which you can download from the internet will be **external libraries**.