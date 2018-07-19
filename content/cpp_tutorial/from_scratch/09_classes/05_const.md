---
layout: article
---

`const` is a pretty powerful keyword in C++. It can also be used to qualify member variables and member functions.

## const methods

In order to do this, you need to place `const` between function parameters and it's body. Putting `const` on the left (here: just before/after `int`) would change return type instead of the type of the function.

**Const-qualifying a member function changes it's type.**

```c++
int rectangle::get_area() const
//                        ^^^^^
{
    return width * height;
}
```

Const-qualified methods can not modify object's state. The presence of `const` prevents from changing values of width and height. This is good, because we do not want the function `rectanle::get_area()` to change the object - only to calculate it's area.

You can still do everything else in such function - create function-local variables, loops, output text, etc. You just can't change member variables. **It's like member variables are const for this function.**


## const propagation

You can not assign to a variable which is `const`. Similarly, you can not call non-const methods if you have a const-qualified object (or a reference/pointer).

```c++
void func(const rectangle& r) // object taken by const reference - can not change it
{
    int area = r.get_area(); // compilation error if method is not const-qualified

    // ...
}
```

## this

`this` is also affected by const-qualification.

```c++
void rectangle::get_area() const
{
    width = /*...*/; // error, can not assign inside const member function
    this->width = /*...*/; // error, can not assign through pointer-to-const
}
```

Inside const-qualified member functions, `this` is not of type `rectangle*` but `const rectangle*`. It's not possible to modify data through a pointer to const.

## relation to getters

**Getters should be const-qualified.**

```c++
class bar
{
// [...]

public:
    // typical accessors for trivial member
    void set_x(X x);
    X get_x() const;

    // typical accessors for bigger member objects
    void set_x(const X& x);
    const X& get_x() const;
};
```

Similarly to passing arguments, we can use references in return types to avoid unnecessary copies.

It was stated previously that references returned from functions are dangling - this is not the case for member functions.

```c++
bar b1;
const X& x_ref = b1.get_x();
// x still lives inside b1 object
```

References to local variables (defined inside functions) are dangerous - but class member variables do not get destroyed when function returns - their lifetime is tied to the lifetime of the object.

## const propagation misuse

This is a commonly made mistake when writing getters that return pointers or references.

In some patterns, getters are used to return references of member objects: `main_window.get_main_menu().get_exit_button().set_color(color::red);`. This allows to get deeper into the object but still without directly touching member variables.

Because the last function is modifying button state, we need to get non-const reference of the button. And because we want non-const reference of the button - we should get it from non-const menu too, (and so on...).

The mistake is made when someone creates a getter that creates an illusion of being const-qualified:

```c++
class window
{
    // [...]
public:
    menu& get_menu() const; // illusion of constness
};
```

What's the problem? Suppose you are writing a function that operates on window - it's task is something that does not require modification of the window so the argument type is `const window&`. Main menu is an object of class `menu` inside window - **the getter above does not modify the object but the reference it returns allows it**.

Thus, we end up in a situation when a const-qualified getter returns a reference to a part of the bigger object that is allowed for modification. The caller of the function that gives us window by const reference expects that the window object (or any parts of it) will not be modified. Through such getter, we can do it which breaks the consistency.

**Conclusion**

Const-qualifying a getter which returns non-const reference (or pointer) to some part of the object breaks constness consistency and allows to modify parts of the object even if it's taken by const reference.

**Solution**

2 overloads should be written - one const and one non-const.

```c++
class window
{
    // [...]
public:
    const menu& get_menu() const;
    menu& get_menu();
};
```

The const one is needed in the situation as described above - now it truly does not allow for modification.

The second one is needed when we do want to modify the object - then the function is non-const which will require to get non-const reference/pointer to the window.

TODO refactor this and move to overloading operator\[\]?

## hidden bug

The program is safe against setting invalid values if getters secure all invariants. But there is 1 hidden problem: what if we do:

```c++
rectangle r;
std::cout << r.get_area() << "\n";
```

`get_area` would then use variables which were not initialized. That's undefined behaviour. It would be good if we could provide some default values or force to set them upon object creation.

That's the purpose of **constructors**.

TODO where to put lesson about THIS keyword?
