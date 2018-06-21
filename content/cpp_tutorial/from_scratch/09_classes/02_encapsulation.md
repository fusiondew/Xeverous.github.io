---
layout: article
---

Let's begin with an example. We create a `rectangle` class representing a mathematical rectangle. We add member functions to leverage OOP features.

```c++
#include <iostream>

class rectangle
{
private:
    int width;
    int height;

public:
    void set_values(int a, int b);
    int get_area() const;
};

void rectangle::set_values(int a, int b)
{
    width = a;
    height = b;
}

int rectangle::get_area() const
{
    return width * height;
}

int main()
{
    rectangle r1;
    r1.set_values(5, 10);
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

## private width and height, public functions

`rectangle`'s dimensions are `private`. They can only be accessed inside member functions. Line such as `r1.width = 10;` would not compile - we can not access private members inside main function. **We have to use `public` method to set dimensions.**

This is good - just think what can be done if someone writes `r1.width = -5;`. Dimensions for any geometric figure must be positive. If we force to use public functions we can prevent such situation - someone can write `r1.set_values(-5, 10);` but since it's a function we can place an `if` inside and ignore the values if they are not correct.

#### Question: I don't get access specifiers. When exactly do private/public limit access?

Don't worry, there will be more examples. You can also change the code from example above and experiment - if you encounter a compilation error you will know why.

#### Question: What about protected access?

Up to some point, `protected` will work the same way as `private`. The only differences are when it comes to inheritance - all examples before inheritance chapter will only use private and public access.

## function definition syntax

The function declaration inside a class looks as usual, but the body is a bit different - noticed how it uses `rectangle::` before it's name?

```c++
void rectangle::set_values(int a, int b)
//   ^^^^^^^^^^^ here
{
    width = a;
    height = b;
}
```

This is because it's a member function. It belongs to rectangle class. That's how bodies for member functions are written. The body of the funtion modifies `width` and `height` - they are members of the rectangle class. These variables are `private` but it's allowed for member functions to access them.

`width` and `height` are not global variables. They are member variables of class `rectangle`. Each rectangle has it's own width and height -  `r1` and `r2` are 2 different objects of the same type.

Note how member functions have to be called on concrete objects:

```c++
r1.set_values(5, 10); // sets width and height on r1
set_values(5, 10);    // error: we need an object to set values on
```

## method `const`

```c++
int rectangle::get_area() const
//                        ^^^^^
{
    return width * height;
}
```

This means that the method does not modify object's state. The presence of `const` prevents from changing values of width and height. This is good, because we do not want the function `rectanle::get_area()` to change the object - only to calculate it's area.

You can still do everything else in such function - create function-local variables, loops, output text, etc. You just can't change member variables. It's like member variables are const for this function.

## core conventions

- It's very typical to have **private fields** and **public methods**. Such design allows to prevent setting wrong values - by being forced to use pulic methods you can be sure that the "if" checking if the values are correct is always executed. It also reduces code duplication.
- Member functions can be divided into 2 core categories: setters and getters. Setters modify the data but secure the **class invariant**. Getters do not modify the data (const methods) and provide a convenient way to certain calculations.

**class invariant** - something that is always true. In the case of rectangle, the invariant is that width and height are always positive.

Getters and setters are sometimes referred to as **accessors**.
