---
layout: article
---

## preface

This was originally supposed to be a part of the tutorial but for reasons (listed further in this article) it did not land there.

Still, if pointers don't scare you, you can see exactly how the most popular dynamic dispatch implementation works.

___

When writing tutorial, I often first wrote some "tricks" how to make the code more robust. Then show a language feature which is intended for exactly such purpose.

```c++
// function wraper
void func1(int x);
void func2() { func1(10); }

// language feature - default arguments
void func1(int x = 10); // func1() == func1(10) == func2()

// multiple related functions
struct animal { ... };
void func1(animal* a_ptr, int b);
void func2(animal* a_ptr, double x, double y);

// feature - class member functions
class animal {
    void func1(int b);              // a_ptr == this
    void func2(double x, double y); // a_ptr == this
};
```

Such approach gives multiple benefits:

- the reader knows **how** feature is implemented - no need for explanation (was really helpful with explaining `this`)
- the reader knows **why** feature is implemented - the reader understands importance and convenience of certain keywords, syntax etc

So starting chapter about polymorphism, I wanted to do the same - write own implementation of virtual table and dynamic function dispatch. I was concerned that I will need to use dangerous `void*` and it will not be a good code to base explanations on. It turned out that I do not need void pointers and that they are not compatible with function pointers anyway (the standard states that convertions between data/function/method pointers are not well-defined).

Writing itself has not caused me any bigger problems besides having to look into documentation for syntax and `.*` and `->*` operators but...

...the implementation is, you know, better see by yourself:


```c++
#include <iostream>
#include <vector>
#include <memory>

struct vtable; // forward declare, we need just name

class animal
{
public:
    const std::string& get_name() const { return name; }

    // these will be virtual
    bool has_tail() const;
    bool has_wings() const;
    void sound() const;

protected: // we do not want animals to be created directly
    animal(const vtable* vtable_ptr, std::string name) : vtable_ptr(vtable_ptr), name(std::move(name)) { }

private:
    friend vtable; // just in case for non-public methods

    const vtable* const vtable_ptr;
    std::string name;
};

class cat : public animal
{
public:
    cat(std::string name);

    // functions to bind dynamically
    bool has_tail() const { return true; }
    bool has_wings() const { return false; }
    void sound() const
    {
        std::cout << get_name() << " does meow\n"; 
    }
};

class dog : public animal
{
public:
    dog(std::string name);

    // functions to bind dynamically
    bool has_tail() const { return true; }
    bool has_wings() const { return false; }
    void sound() const
    {
        std::cout << get_name() << " does whoof\n"; 
    }
};

class parrot : public animal
{
public:
    parrot(std::string name);

    // functions to bind dynamically
    bool has_tail() const { return false; }
    bool has_wings() const { return true; }
    void sound() const
    {
        std::cout << get_name() << " does crrra\n"; 
    }
};

// now the magic - pointers to member functions!
struct vtable
{
    bool (animal::* const has_tail)() const;
    bool (animal::* const has_wings)() const;
    void (animal::* const sound)() const;

    // constructor
    vtable (
        bool (animal::* const has_tail)() const,
        bool (animal::* const has_wings)() const,
        void (animal::* const sound)() const
    ) : has_tail(has_tail), has_wings(has_wings), sound(sound) { }
};

// global vtable objects
const vtable vtable_cat(
    static_cast<bool (animal::*)() const>(&cat::has_tail),
    static_cast<bool (animal::*)() const>(&cat::has_wings),
    static_cast<void (animal::*)() const>(&cat::sound));
const vtable vtable_dog(
    static_cast<bool (animal::*)() const>(&dog::has_tail),
    static_cast<bool (animal::*)() const>(&dog::has_wings),
    static_cast<void (animal::*)() const>(&dog::sound));
const vtable vtable_parrot(
    static_cast<bool (animal::*)() const>(&parrot::has_tail),
    static_cast<bool (animal::*)() const>(&parrot::has_wings),
    static_cast<void (animal::*)() const>(&parrot::sound));

// set vtable pointers in constructors
cat::cat(std::string name) : animal(&vtable_cat, std::move(name)) { }
dog::dog(std::string name) : animal(&vtable_dog, std::move(name)) { }
parrot::parrot(std::string name) : animal(&vtable_parrot, std::move(name)) { }

// implement dynamic dispatch
bool animal::has_tail() const
{
    return (this->*(vtable_ptr->has_tail))();
}

bool animal::has_wings() const
{
    return (this->*(vtable_ptr->has_wings))();
}

void animal::sound() const
{
    (this->*(vtable_ptr->sound))();
}

int main()
{
    std::vector<std::unique_ptr<animal>> animals;
    animals.push_back(std::make_unique<cat>("grumpy"));
    animals.push_back(std::make_unique<cat>("nyan"));
    animals.push_back(std::make_unique<dog>("doge"));
    animals.push_back(std::make_unique<parrot>("party"));

    for (const auto& a : animals)
        a->sound();

    // note: destructors are not dispatched virtually
}
```

~~~
grumpy does meow
nyan does meow
doge does whoof
party does crrra
~~~

I initially wanted to to place it in the tutorial as it would be the best possible "how it works" but after implementing it and knowing it's all quirks (upcasts on member function pointers, syntax for using member function pointers, vtable initialization bloat) I resigned. It would cause more confusion than explanatory help.

It was a fun though to implement.

```
main.cpp: In member function 'bool animal::has_tail() const':
main.cpp:107:42: error: must use '.*' or '->*' to call pointer-to-member function in '((const vtable*)((const animal*)this)->animal::vtable_ptr)->vtable::has_tail (...)', e.g. '(... ->* ((const vtable*)((const animal*)this)->animal::vtable_ptr)->vtable::has_tail) (...)'
     return this->*(vtable_ptr->has_tail)();
                                          ^
```

Seriously. Always wanted to try and see how actual vtable looks like.
