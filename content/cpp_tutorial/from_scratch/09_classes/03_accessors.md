---
layout: article
---

## member functions outside class

Functions inside classes gain access to member variables. They can also be split up into declarations and definitions.

TODO header/source separation. But in which chapter?

```c++
class rectangle
{
private:
    int width;
    int height;

public:
    void set_values(int a, int b); // declaration
    int get_area() const;          // declaration
};

void rectangle::set_values(int a, int b) // definition
//   ^^^^^^^^^^^ spot this
{
    width = a;
    height = b;
}
```

Note how definition uses `rectangle::` before it's name. It's to inform the compiler that we are writing a member function - otherwise it would complain that `width` and `height` are unknown names.

Don't get it wrong: `width` and `height` are not global variables. They are member variables of class `rectangle`. Each rectangle has it's own width and height.

The body of the funtion modifies `width` and `height` - they are members of the rectangle class. These variables are `private` but it's allowed for member functions to access them.

## member function usage

Note how member functions have to be called on concrete objects:

```c++
r1.set_values(5, 10); // sets width and height on r1
set_values(5, 10);    // error: we need an object to set values on - a rectangle that has width and height
```

`5` and `10` are the arguments that match parameters `a` and `b`. `r1` is the object that matches `rectangle::`. Member functions have a hidden mechanism for handling on which object method is invoked.

## const methods

You might have noticed unusually placed `const` at the end of second member function declaration. Definition of this function also has it:

```c++
int rectangle::get_area() const
//                        ^^^^^
{
    return width * height;
}
```

This means that the method does not modify object's state. The presence of `const` prevents from changing values of width and height. This is good, because we do not want the function `rectanle::get_area()` to change the object - only to calculate it's area.

You can still do everything else in such function - create function-local variables, loops, output text, etc. You just can't change member variables. **It's like member variables are const for this function.**

Const methods follow intuitive const behaviour - you can't assign to const variables and similarly you can't call non-const methods on const objects.

```c++
void func(const rectangle& r) // object taken by const reference - can not change it
{
    int area = r.get_area(); // compilation error if method is not const

    // ...
}
```

## accessors

From member functions there can be distincted 2 characteristic kinds: **setters** and **getters**.

Setters:

- modify the data (they *set* things)
- secure **class invariant**s.
- function names usually start with `set`
 
Getters:

- do not modify the data (const methods)
- provide a convenient way to access information (different figures have different formulas but we don't need to remember them - just call `get_area()`)
- function names usually start with `get` (return some private value or computation result) or `is`, `has` (names resemble questions and functions return `bool`)

Not all member functions belong to these. These are just 2 kinds which very often appear in classes.

In simple scenarios, there is 1 getter and setter for each member variable

```c++
void set_x(X x);
X get_x() const;

// with (const) references if objects are heavy
void set_x(const X& x);
const X& get_x() const;
```

Setters sometimes return `bool` to indicate whether operation succeeded - if result is `false` we can expect that the invalid value has been ignored and object is left unchanged.

## summary

Getters and setters are sometimes referred to as **accessors**.

Getters and setters are the simplest examples of methods.

The purpose of setters is to prevent setting invalid values (they secure invariants).

The purpose of getters is to give access to members without allowing to modify them.

## hidden bug

The program is safe against setting invalid values if getters secure all invariants. But there is 1 hidden problem: what if we do:

```c++
rectangle r;
std::cout << r.get_area() << "\n";
```

`get_area` would then use variables which were not initialized. That's undefined behaviour. It would be good if we could provide some default values or force to set them upon object creation.

That's the purpose of **constructors**.

TODO where to put lesson about THIS keyword?
