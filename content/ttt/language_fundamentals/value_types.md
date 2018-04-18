---
layout: article
---

### First glance - simple explanation

I will start with simplified explanation in regards to C to grasp the concept of value types. C has only lvalues and rvalues. Then I will move onto C++ and why it has more complex system.

Note: the formal terms are *lvalue expression*, *rvalue expression* and such.

#### lvalue (left value)

An **lvalue** is something that can appear **both** on the left and right side of an assignment.

Suppose we have integers `a`, `b` and `c`.

All of the following expressions are valid:

```c++
a = b;
b = a;
a = a + 1;
c = a + b;
```

Don't overthink it, it's that simple. `a`, `b` and `c` can be on both sides.

Thus, all of `a`, `b` and `c` are **lvalue expressions**.

#### rvalue (right value)

Am **rvalue** is something that can appear **only** on the right side of an assignment.

The following expressions are valid:

```c++
a = a + 1;
c = a + b;
```

But the following are not:

```c++
a + 1 = a;
a + b = c;
```

Thus, `a + 1` and `a + b` are **rvalue expression**s. They can not be put on the left.

In other words, rvalues are temporary objects. You can not assign to temporaries.

`1` is also an rvalue expression:

```c++
1 = a; // does not compile
```

#### Short summary

- **lvalue expressions** can appear on both left and right side of an assignment
- **rvalue expressions** can appear only on the right side of an assignment
- lvalues have well-defined scope and lifetime, as they are names of the variables
- rvalues are temporary objects, assigning to temporaries is both pointless and impossible

#### operator ++

You might already came up with this question: Is `++a` and `a++` an lvalue or an rvalue?

The answer is crossing boundary between C and C++.

Compare what is happening for `a++`:

```c++
int postincrement(int x)
{
    int temp = x;
    x = x + 1;
    return temp;
}
```

and what for `++a`:

```c++
int& preincrement(int& x)
{
    x = x + 1;
    return x;
}
```

You might already know that the expression `a++` does not have it's results visible immediately. `a` is changed but the old value is returned. However, `++a` changes `a` in-place.

The answer is:

- `++a` is an lvalue expression
- `a++` is an rvalue expression

The following expressions are valid:

```c++
b = ++a; // lvalue = lvalue
b = a++; // lvalue = rvalue
++a = b; // lvalue = lvalue
```

but the following is not:

```c++
a++ = b; // rvalue = lvalue
```

and produces such error message for GCC:

```c++
main.cpp: In function 'int main()':
main.cpp:9:11: error: lvalue required as left operand of assignment
     a++ = b;
           ^
```

#### functions

This drives to the question: How does function's return type impact valueness?

The answer for C is very simple: functions always return an rvalue.

The answer for C++ (due to references) is more complex - functions return:

- a prvalue if the function return type is `T`
- an lvalue if the function return type is `T&`
- an xvalue if the function return type is `T&&`

