---
layout: article
---

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

## this

This also explains `const` member functions:

```c++
void rectangle::get_area() const
{
    width = /*...*/; // error, can not assign inside const member function
    this->width = /*...*/; // error, can not assign through pointer-to-const
}
```

Inside const-qualified member functions, `this` is not of type `rectangle*` but `const rectangle*`. It's not possible to modify data through a pointer to const.

## ???

```c++
void set_x(X x);
X get_x() const;

// with (const) references if objects are heavy
void set_x(const X& x);
const X& get_x() const;
```

## hidden bug

The program is safe against setting invalid values if getters secure all invariants. But there is 1 hidden problem: what if we do:

```c++
rectangle r;
std::cout << r.get_area() << "\n";
```

`get_area` would then use variables which were not initialized. That's undefined behaviour. It would be good if we could provide some default values or force to set them upon object creation.

That's the purpose of **constructors**.

TODO where to put lesson about THIS keyword?
