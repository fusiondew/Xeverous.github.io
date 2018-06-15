---
layout: article
---

All of the programs below have exactly the same behaviour - they print information about 2 types of animals, but each program is written differently.

This article is to showcase how various programming styles can be. Each has different tradeoffs - mostly around convenience/easyness, extensibility/customizability and performance.

**Note**

Do not compare performance and generated assembly from these programs. They contain no user-dependent control flow and are therefore abnormal optimization cases. Also, modern compilers tend to do weird (read: abusive aggressive optimization) things with very short programs.

### classic structural

Most commonly seen in C. Very basic and simple, but lacking advanced functionality. Note: vector is not structural style, written only for comparison.

```c++
#include <iostream>
#include <vector>

enum class animal_type { cat, dog };

struct animal
{
    animal_type type;
};

void print_animal(const animal& a)
{
    if (a.type == animal_type::cat)
        std::cout << "meow\n";
    else if (a.type == animal_type::dog)
        std::cout << "whoof\n";
}

int main()
{
    std::vector<animal> v;
    v.push_back(animal{animal_type::cat});
    v.push_back(animal{animal_type::dog});

    for (animal a : v)
        print_animal(a);
}
```

### classis OOP

Very prominent style in Java. The simplest of OOP styles, but unfortunately the worst in regards to performance (virtual function call overhead). Still, classic OOP has the widest possibilities when it comes to the features.

```c++
#include <iostream>
#include <vector>
#include <memory>

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
    std::vector<std::unique_ptr<animal>> v;
    v.push_back(std::make_unique<cat>());
    v.push_back(std::make_unique<dog>());

    for (const auto& a : v)
        a->sound();
}
```

### monadic

Style encouraged in Haskell, also part of modern C++ trends

TODO variant + overloaded lambda implementation.

### metaprogramming

CRTP (Curiously Recurring Template Pattern). Limited to compile-time features (and people skilled in template sorcery) but guaranteed to be zero-overhead. This style is complicated and requires time to explain but it does wonders in C++ standard library and other libraries which require maximum performance with great list of features - such as in Eigen - linear algebra library which draws it's power from expression templates.

TODO CRTP implementation.
