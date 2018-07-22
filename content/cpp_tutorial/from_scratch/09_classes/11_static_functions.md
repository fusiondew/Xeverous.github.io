---
layout: article
---

If you understood previous lesson well this one should be really simple.

## rules

- Static member functions, like static variables are not tied to any specific instance.
- As a consequence of the above, static member functions do not have hidden `this` parameter.
- As a consequence of the above, static member functions can access only other static members or global objects
- Static member functions can not be const-qualified. Since they do not work on any object, there is no point in declaring that they don't modify the object
- Static member functions can not be `virtual` (virtual functions - polymorphism chapter)

Similarly to static member variables, static member functions can be thought as global functions, just inside class scope.

```c++
struct foo
{
    int x;

    static int func();
};

int foo::func() // note: no static here
{
    // usual function definition

    // you can not access 'x' here because there is no 'this' 
}
```

## uses

You can use static member function as a getter for static member variable which is private.

From previous lesson:

```c++
class user
{
private:
    static inline int next_id = 0;

public:
    static int get_next_it();
    static int generate_next_it(); // TODO this is good for [[nodiscard]]
};

int user::get_next_id()
{
    return next_id;
}

int user::generate_next_id()
{
    return ++next_id;
}
```

Or to implement certain static initialization order. TODO

## ???

Something missing? Maybe an exercise?
