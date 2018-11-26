---
layout: article
---

## class definition

Classes are custom (user-defined) types. Before using a class, you have to define it.

syntax:

TODO make it HTML

```c++
class class_name
{
access_specifier:
    fields, methods, ...
access_specifier:
    fields, methods, ...
...
access_specifier:
    fields, methods, ...
}; // <== don't forget this semicolon
```

`class_name` - name of the class. Essentialy the name of the type that is created.

`access_specifier` - limits how the data is accessed. There are 3 possible specifiers: `private`, `protected` and `public`. What they do exactly - very soon. Just keep reading.

`fields` - class variables. In C++, you can encounter the term **member variables**.

`methods` - class functions. In C++, you can encounter the term **member functions**.

There are few more things which you can put inside a class (and therefore make them members of the class) - they will be introduced in further lessons.

## access specifiers

Structures have pretty intuitive use.

```c++
struct point
{
    int x;
    int y;
};

point p1;
p1.x = 5;
p1.y = 10;

point p2;
p2.x = -3;
p2.y = 6;
```

In the example above, you can write `p1.x`, `p2.y` and such to modify each of the point variables. Classes can constrain access to their member variables.

```c++
class point
{
public:
    int x;
    int y;
};

point p1;
p1.x = 5;
p1.y = 10;

point p2;
p2.x = -3;
p2.y = 6;
```

`public` access works the same way as with structures. `public` access means no restrictions. You can freely change member variables any time. Classes with public access works exactly the same as structs.

`protected` and `private` allows only to access member variables inside class functions - with such specifiers the code above would not be valid.

#### Question: Why would I want to limit access to member variables?

Remeber the `const`? We limit mutability to avoid potential errors. Similarly with classes, we use access specifiers to limit potential misuse. Once you learn the purpose and convenience of member functions, you will understand it better.

## struct vs class

For historical reasons, in C++, `structs` have all power that `class`es have (structs can have access specifiers and member functions too). You can aswell use keyword `struct` when defining custom types.

The only differences are:

- the default access in structs is public while in classes it's private

```c++
struct foo
{
// no specifier here - assumed 'public'
    int x; // x is public
};

class bar
{
// no specifier here - assumed 'private'
    int x; // x is private
};
```

- the default inheritance in structs is public while in classes it's private

```c++
struct base {};
struct derived : public base {};
struct derived : base {}; // same as line above

class base {};
class derived : private base {};
class derived : base {};  // same as line above
```

*More about inheritance in it's chapter*.

C++ originally did not have `class` keyword and just allowed everything inside `struct`. `class` keyword was very anticipated though so it eventually arrived. This caused shift in convention to use `class` for classes and even though `struct` has all the same features (with just 2 minor differences above) it's recommended to use only the C subset of `struct` features.

Cases where to use `struct` instead of `class`:

- all members are intentionally public and there are no strong relations - the type is just a box for multiple variables - common example is a point struct holding just X and Y coordinates
- the type is empty (empty types are useful in some situations)
- the type is a template helper (also applies to type traits)

<div class="note pro-tip" markdown="block">

Use `struct` only when defining types that tie together few public members. If you need something more (restricting access to protected/private, complex member functions) use `class`.

When in doubt, use `class`.
</div>

## example

We create a `rectangle` class representing a mathematical rectangle. We add member functions to leverage OOP features.

```c++
#include <iostream>

class rectangle
{
private:
    int width;
    int height;

public:
    void set_values(int a, int b)
    {
        if (a > 0)
            width = a;

        if (b > 0)
            height = b;
    }

    int get_area()
    {
        return width * height;
    }
};
// we are outside of the class definition here
// from this point and further, we can only use what is public

int main()
{
    rectangle r1;
    r1.set_values(5, 10); // r1.width = 5; would not compile (width is private)
    std::cout << r1.get_area() << "\n";

    rectangle r2;
    r2.set_values(3, 6);
    std::cout << r2.get_area() << "\n";
}
```

output:

~~~
50
18
~~~

Okay, that's a lot of new code. I will explain things one by one.

## private variables, public functions

`rectangle`'s dimensions are `private`. They can only be accessed inside member functions. Line such as `r1.width = 10;` would not compile - we can not access private members inside main function. Outside the class, **we have to use `public` method to set dimensions.**

<div class="note info">
All member functions (with any access specificiation) can access member variables.
</div>

This is good - just think what can be done if someone writes `r1.width = -5;`. Dimensions for any geometric figure must be positive. If we force to use public functions we can prevent such situation - someone can write `r1.set_values(-5, 10);` but since it's a function we can place an `if` inside and ignore values if they are not correct.

<div class="note pro-tip">
In practically all scenarios, all member variables should be private.

Functions which are part of the class interface (how it is supposed to be used from the outside) should be public.

Functions which are only internal logic of the class (often helper functions to avoid code duplication, not intended to be used in main code) should be protected/private.
</div>

Applying the above recommendation to the rectangle class:

- member variables are private to prevent modifications from the outside which could set invalid values
- 2 member functions are public - they are the outside functionality of the class
- we could move `if (a > 0)` to private member function - something like `bool is_valid(int length)` - this function would be then used inside other member functions (this is a very trivialized example)

## analogy

Kitchen devices are pretty good examples - they are relatively simple to use but hide a complicated mechanisms inside.

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>device</th>
                <th>private variables</th>
                <th>private functions</th>
                <th>public functions</th>
            </tr>
            <tr>
                <td>microwave</td>
                <td>current power, rotating speed</td>
                <td>rotate plate, switch light, emit microwaves</td>
                <td>switch on/off, set time, set power</td>
            </tr>
            <tr>
                <td>refrigerator</td>
                <td>current temperature, expected temperature</td>
                <td>switch light, compressor controls</td>
                <td>open, close, take, put</td>
            </tr>
            <tr>
                <td>blender (mixer)</td>
                <td>force currently applied</td>
                <td>engine controls (set speed, force, rotation)</td>
                <td>switch on/off, set power</td>
            </tr>
            <tr>
                <td>dishwasher</td>
                <td>available water, current program stage</td>
                <td>enable water pump, rotate nozzles</td>
                <td>switch on/off, set program, open/close</td>
            </tr>
        </tbody>
    </table>
</div>

- private variables represent internal state - something which you should better not fiddle with (force, temperature, electricity, etc)
- private functions represent mechanisms that are used internally (you don't explicitly switch light or rotate plate) - these functionalities should be used only in specific situations (don't rotate when microwave is open, switch light off when fridge is closed)
- public functions represent mechanisms that are intended to be used by final user - buttons which set time, power, open/close etc

## keeping sensible state

Classes limit bugs by keeping **invariant**s intact. **An invariant is something that is always true**.

Example invariants:

- light is off when fridge is closed
- when microwave is open, plate does not rotate
- water does not get out (for washing machine and dishwasher)
- temperature is in safe range

You never directly call private methods - private `rotate_plate()` would be called only inside public functions of microwave. Similarly light switch by fridge.

#### Question: What about protected access?

In most situations, `protected` will work the same way as `private`. The only differences are when it comes to inheritance - all examples before inheritance chapter will only use private and public access.

#### Question: I still don't get access specifiers. Where exactly do private/public limit access?

Don't worry, there will be more examples. You can also change the code from example above and experiment - if you encounter a compilation error you will know why.

#### Question: I have problems deciding on privte/public access.

Classes in current examples are pretty small. Real classes usually contain 3-10 variables and even up to 100 functions. Then it's clear that there is need to limit what can be accessed from the outside - otherwise it's like using a device with opened cover where you can see working engine - touching moving parts can damage you and/or device.

Many of OOP decisions are not always trivial. Some problems take a lot of attempts and experiments to learn. If you can't grasp it now, move on, continue and come back later. Remember that **the best way to learn programming is by writing code**. The more problems you encounter and solve, the better.

If you still have doubts, the reasonable default is to make every variable private and every function public.

## exercise

Can you specify what are invariants for rectangle and triangle?

<details>
<summary>answer</summary>
<p markdown="block">
rectangle

- width and height are positive

triangle

- a, b and c are positive
- $a + b > c$, $a + c > b$, $b + c > a$ (you can't have triangle with sides 1, 2, 5)
</p>
</details>

## summary

**Classes** tie together **fields** (member variables) and **methods** (member functions).

**Access specifiers** are used to limit access to members. Limited access and exposing only what is needed to the public helps to keep class **invariants**.
