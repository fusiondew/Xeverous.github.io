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
arr[k] = v
std::cout << "hello, world"
```

Generally whitespace characters (spaces, tabs, new lines, ...) are ignored by the compiler. This means that `x+y` works the same as `x + y` or `x   +y`. Obviously whitespace separates names so `ab` will be one name "ab" while `a b` will represent 2 names "a" and "b".

Whitespace characters are not ignored in quoted strings such as `" "` or `' '`.

### Identifiers

Everything than can be later referred to has an **identifier**. It's just the name of the entity.

Valid names can consist of:

- lowercase latin letters (a - z)
- uppercase latin letters (A - Z)
- underscore symbol (_)
- digits (0 - 9), with the exception that the name can not start with a digit

Actually there are more possible characters (from unicode) but REALLY NO ONE uses them and tools, including compilers many not support them.

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
- [keywords](https://en.cppreference.com/w/cpp/keyword)

More about namespaces later. For now, simply remember to not start names with `_` character.

### name styles

There have been established few core naming styles, these conventions are broadly used in the entire IT, not just programming.

```
lowercase_name_style (sometimes referred to as snake case)
UPPERCASE_NAME_STYLE
PascalCaseNameStyle
camelCaseNameStyle (in camelCase first letter is lowercase)
```

It's bad to mix these styles - any of the follwoing names are against convention:

```
Account_Manager
Accountmanager
PrintHTTPDocument
print_HTTP_document
```

correct names:

```
account_manager
AccountManager
accountManager
print_http_document
PrintHttpDocument
printHttpDocument
```

C++ (following C convention) standard library uses `UPPERCASE_NAME_STYLE` for macros and `snake_case_style` for almost everything else.