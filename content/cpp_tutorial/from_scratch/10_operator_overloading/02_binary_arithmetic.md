---
layout: article
---

Examples will start with the following class:

```c++
class integer
{
public:
    integer(int x = 0) : x(x) { }
    // whatever that needs to be added here

private:
    int x;
};
```

I know it's very trivial - it's just replication of integer behaviour. The purpose of first lessons is not to give real-world scenarios but familiarize you with the syntax.

We will start with binary arithmetic operators (`+`, `-`, `*`, `/` and `%`).

## member vs non-member

Binary operators can be defined in 2 ways:

- class member function (taking only 1 argument)
- global function (taking 2 arguments)

The member function variant takes only 1 argument because `*this` is already accessible (remember hidden first parameter?).

TODO `friend` - explain here or earlier?

**Adding 2 `integer`s - global function variant**

```c++
// declration (in header)
integer operator+(const integer& lhs, const integer& rhs);

// definition (in source)
integer operator+(const integer& lhs, const integer& rhs)
{
    return integer(lhs.x + rhs.x); // here + is the built-in operator for ints
}
```

Suddenly we encounter a problem - this function is a global function, it does not have access to private variables. We have 2 ways to solve this:

- write a getter
- use `friend`

With operator overloading, the second choice is preferred. It doesn't really break the encapsulation of a class because overloaded operators often have to access member variables (and sometimes modify them - getters are not enough) - treat overloaded operators as a part of class functionality.

So to fix this problem, we declare operator as a friend:

```c++
// inside any section (access specifiers does not matter here) of integer class
friend integer operator+(const integer& lhs, const integer& rhs);

// remainder: friends are declared in class scope but they are non-members (here: global function)
```

The body of the function can stay as written before.

**Adding 2 `integer`s - member function variant**

A different approach is to make it a member function - there is no need for friends but it looks kinda messy:

```c++
// inside class public section
integer operator+(const integer& rhs) const;

// definition - as usually, class_name::func_name
integer integer::operator+(const integer& rhs) const
{
    return integer(x + rhs.x);
}
```

`+` is a binary operator - it operates on 2 arguments. It doesn't look good as a member function - first argument is (implicitly) the current object so we need to take only the second one.

## in action

```c++
integer x1(5);
integer x2(10);
integer x3 = x1 + x2; // calls associated operator+ function 
```

Funny thing is, we can call these operators just like they were normal functions:

```c++
integer x3 = operator+(x1, x2); // if written using non-member function approach
integer x3 = x1.operator+(x2);  // if written using     member function approach
```

All other binary arithmetic operators (`-`, `*`, `/`, `%`) are written the same way. Just replace the symbol.

## member vs non-member

The following program compiles:

```c++
class integer
{
private:
    int x;
    
public:
    integer(int x = 0) : x(x) { }
    
    // global function approach
    friend integer operator+(const integer& lhs, const integer& rhs)
    {
        return integer(lhs.x + rhs.x);
    }
};

int main()
{
    integer x1(5);
    integer x2 = x1 + 5;
    integer x3 = 5 + x1;
}
```

There is no operator+ that takes 1 `integer` and 1 `int` but we can turn an `int` to an `integer` by implicit construction. The expression `x1 + 5` works like `x1 + integer(5)`.

But the following program does not compile:

```c++
class integer
{
private:
    int x;
    
public:
    integer(int x = 0) : x(x) { }
    
    // member function approach
    integer operator+(const integer& rhs) const
    {
        return integer(x + rhs.x);
    }
};

int main()
{
    integer x1(5);
    integer x2 = x1 + 5; // works
    integer x3 = 5 + x1; // error: no match for 'operator+' (operand types are 'int' and 'integer')
}
```

The problem lies in the feature of implicit convertions - expression `x1 + 5` works because **the second** argument can be converted to `integer`. But in the case of expression `5 + x1` **the first** argument needs to be converted - and this is the problem. **If a member function needs to be called, the argument type of the object operand must match exactly.**

I don't want to go into all boring details of the C++ language rules but in short, **member functions (including overloaded operators) have to be called on objects of their respective type**.

This rule might look easier to understand when presented this way:

```c++
integer x2 = x1.operator+(5); // ok, we can build integer object from 5
integer x3 = 5.operator+(x1); // error: 5 is not a class object and has no mmeber functions
```

#### Question: Is this rule really needed?

Actually yes. It would be far worse if we had hidden convertions for first arguments (imagine `5` turning into everything possible - time/date types, strings, matrices, positions, ...). There were some discussions on UFCS (unified function call syntax) (TODO link article) that could change a lot in this regard but so far C++ is not getting this feature (which itself is disputed).

## summary

Because of the problematic convertion, it's recommended to use global function approach - it's consistent with it's behaviour (same convertion rules for both left and right side). Also, global function implementation looks symmetric - no relying on hidden `this` parameter.

This recommendation is reverse for operators that do not treat their arguments equally: `a + b` is expected to be the same as `b + a` (return new object) but expressions like `a += b` are expected to modify left object.

<div class="note pro-tip" markdown="block">
When overloading binary operator:

- use non-member function when operands are treated the same way (as in `a + b`)
- use member function when operands are not treated the same way (as in `a += b`)
</div>

The rule for not trying to overuse friends still holds:

<div class="note pro-tip">
When overloading (any) operator, use `friend` only when necessary.
</div>

Of course often it is necessary (like in this lesson).
