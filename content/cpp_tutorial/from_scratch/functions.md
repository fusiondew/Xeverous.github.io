---
layout: article
---

Our journey starts from math. I assume you know what a *function* term means in math. In programming it's very similar.

**A function is a reusable piece of code which may have input parameters and output some value** It's a mapping from input to output.

Let's use a very simple quadratic function:

TODO make it LaTeX

```
f(x) = x^2
```

This is how it looks like in C and C++ (written using multiplication to avoid more complex stuff):

```c++
int f(int x)
{
    return x * x;
}
```

There are multiple noticeable things here:

- `int` is used to indicate return type (on the left) and argument type (inside parentheses); `int` means *integer* - this function works with whole numbers
- the function is named `f` (other names are also possible)
- the function takes 1 argument named `x` which is an `int`eger
- the function *returns* `x` multiplied by `x`

So how this function is used? It's surprisingly very similar:

TODO LaTeX

```
x = 5
y = f(x)
```

```c++
int x = 5;
int y = f(x);
```

The difference is that since we are using strongly typed language both `x` and `y` have to be given types - the compiler need to know we are working on numbers. The other thing you may have noticed is that statements end in `;`. This is a very normal thing is tons of programming languages - just like human language sentences end in `.` the programming sentences end in `;`.

#### Question: Why ; and not .?

Part of the reason is history and the other thing is that `.` has other purposes (eg writing fractional numbers: `3.14`).

### comments

It is possible to insert comments into the program. Such text will be completely ignored by the compiler.

There are 2 types of comments in C++:

```c++
// this is a single-line comment
// <- you need to start it with // and the comment will span to the end of line

/* this is a multiline comment - it can span multiple lines
notice the order of / and * a the beginning and end
multi-line comments must end with * and / as it is here: */
```

Single-line comments can start after code:

```c++
int x = 5; // this comment spans to the end of this line
```

<div class="note warning">
#### Warning
<i class="fas fa-exclamation-circle"></i>
Watch out for accidental `\` at the end of a single-line comment. It extends the comment to another physical line.

```c++
// text \
this text is also a part of the comment
``` 

It's adviced to just write 2 comments instead:

```c++
// text
// text
```
</div>

Multi-line comments can start and end any time - in such scenario they can be shorter than `//` comments:

```c++
int /* some comment */ x = /* other comment */ 5;
```

Often you can find asterisk-stylized multi-line comments:

```c++
/*
 * text
 * text
 * text
 */
```

Some IDEs do it automatically. If you have a comment that spans many lines it's recommended to start lines with `*`, just like in the example above.