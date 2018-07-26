---
layout: article
---

Remember the animals example? `animal` had protected constructor - it disallows to create an animal object directly but still allows derived types to construct the parent (if it was private derived types constructors would not compile).

Obviously it doesn't make much sense to create "just animal". Such thing is too *abstract*. It's a good base type for multiple more precise animals but the sole `animal` is too vague. Would you say you have a cat/dog/parrot etc or "I have an animal"?

## pure virtual

Making constructor protected is a reasonable choice. But what about base type functions? `animal::has_tail()` - should it return `true` or `false`? Throw an exception?

The answer is that we do not have to provide the body of the function at all.

```c++
class animal
{
public:
    virtual bool has_tail() const = 0; // pure virtual

    // ...
};
```

Specifying a virtual function with `= 0` makes it **pure virtual**. Such function does not have to have a body.

**syntax**

I agree that `= 0` looks quite dubious, but it's a thing of the past. C++ creators are very resistant about adding new keywords because they always risk breaking someone's code if that person used it as a type or variable name. In this case, the proposed keywords were `pure` and `abstract` - in fact, many programming languages do have such keywords. We got later `override` and `final` but they have their special meaning only in the context of function qualifiers.

`= 0` somewhat resembles C-style initialization ("nothing", "null", "zero") that in the very first writings was used (before C got `NULL`).

## abstract classes

Ok, we now have solved the problem of nonsensical virtual functions. But what happens if we actually do this?

```c++
animal a; // assuming public constructor
a.has_tail();
```

Undefined behaviour (null pointer in virtual table)? Exception? The answer is: **it does not compile**.

**Any type that has at least 1 pure virtual function is an abstract type.**

**Objects of abstract types can not exist.**

In other words, even if we have a public constructor but there is at least 1 **pure** virtual function compiler won't let construct such type directly. You have to create derived types and override (or rather, implement) this function. If derived type does not implement all pure virtual functions - it will be abstract too.

Applying abstract class approach to the example:

```c++
#include <iostream>
#include <memory>
#include <vector>

class animal
{
public:
    virtual ~animal() = default;
    virtual void sound() const = 0;
};

class cat : public animal
{
public:
    void sound() const override
    {
        std::cout << "meow\n";
    }
};

class dog : public animal
{
public:
    void sound() const override
    {
        std::cout << "whoof\n";
    }
};

int main()
{
    std::vector<std::unique_ptr<animal>> animals;
    animals.push_back(std::make_unique<cat>());
    animals.push_back(std::make_unique<dog>());
    // animals.push_back(std::make_unique<animal>()); // error: can not create object of abstract class

    for (const auto& a : animals)
        a->sound();
}
```

## default implementations for pure virtual functions

> Specifying a virtual function with `= 0` makes it **pure virtual**. Such function **does not have to** have a body.

Does not have to but it can.

```c++
class animal
{
public:
    virtual ~animal() = default;
    virtual int get_eye_count() const = 0;
};

// this must be outside the class
// it's not allowed to provide both = 0 and the body
int animal::get_eye_count() const
{
    return 2; // reasonable default
}

class cat : public animal
{
public:
    int get_eye_count() const override
    {
        return animal::get_eye_count(); // explicit use of default implementation
    }
};
```

This combines the benefits of abstract classes and at the same time allows for some default implementation that can be reused.

In practice, it's rarely used but comes handy when needed - 2 animals don't have to write the same function.

## pure virtual destructors

A further variation of the default implementation feature. But in the case of destructors, a default body must be provided.

```c++
// the smallest possible abstract class - just 1 function (destructor)
class smallest
{
public:
    virtual ~smallest() = 0;
};

smallest::smallest() { }
```

## summary

Benefits of pure virtual functions

- Must be implemented. No printed/saved "???" or "animal has 0 eyes" bugs. If there is a default implementation you must explicitly call it.
- Abstract classes can not be instantiated. Prevents random misuse by accidental creations of nonsensical objects.