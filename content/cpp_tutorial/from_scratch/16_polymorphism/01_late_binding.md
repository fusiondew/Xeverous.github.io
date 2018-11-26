---
layout: article
---

## early binding

So far all functions that were used were implemented by the compiler as **early binding**. This means that every time you call a function, compiler inserts specific address of the function where it is called - it *binds* an address to a statement.

```c++
#include <iostream>

class animal
{
public:
    void sound() const
    {
        std::cout << "???\n";
    }
};

class cat : public animal
{
public:
    void sound() const // shadows base class function
    {
        std::cout << "meow\n";
    }
};

class dog : public animal
{
public:
    void sound() const // shadows base class function
    {
        std::cout << "whoof\n";
    }
};

int main()
{
    cat c;
    c.sound(); // calls cat::sound because c is a cat
    dog d;
    d.sound(); // calls dog::sound because d is a dog
}
```

~~~
meow
whoof
~~~

However, if we treat the objects as just an animal:

```c++
int main()
{
    cat c;
    animal& ref1 = c; // base class reference
    ref1.sound(); // we see only base class function

    dog d;
    animal& ref2 = d; // as above
    ref2.sound();
}
```

we instead get 

~~~
???
???
~~~

In ideal scenario we would like to have a vector of animals and call appropriate function depending on the **dynamic type**. We can not use `std::vector<animal>` because object slicing would happen, losing all the information about derived types.

We can use `std::vector<std::unique_ptr<animal>>` but the problem is that **once we obtain a pointer/reference to the base class, we lose the information which type it is exactly**.

What's worse is that since base class pointer/reference does not know about actual type of the object it will also invoke only base type destructor:

```c++
#include <iostream>
#include <memory>
#include <vector>

class animal
{
public:
    animal() { std::cout << "animal::animal()\n"; }
    ~animal() { std::cout << "animal::~animal()\n"; }
};

class cat : public animal
{
public:
    cat() { std::cout << "cat::cat()\n"; }
    ~cat() { std::cout << "cat::~cat()\n"; }
};

class dog : public animal
{
public:
    dog() { std::cout << "dog::dog()\n"; }
    ~dog() { std::cout << "dog::~dog()\n"; }
};

int main()
{
    std::vector<std::unique_ptr<animal>> animals;
    animals.push_back(std::make_unique<cat>());
    animals.push_back(std::make_unique<dog>());
}
```

~~~
animal::animal()
cat::cat()
animal::animal()
dog::dog()
animal::~animal()
animal::~animal()
~~~

This can lead to severe bugs if destructors of derived types have to perform any work - especially things such as memory release. If `cat` or `dog` had a string member, it's destructor would not be called, therebly leaking memory.

## the need for type metadata

There is certainly a need for some mechanism that would store the type information metadata and call appropriate function. That metadata would need to be stored as a member of the base class - it should be visible when we access objects by pointer/reference to base type.

This metadata could be a simple enum describing the actual type, initialized in derived classes constructors - each constructor of more derived type would overwrite it to note something "more derived". We could then put else-ifs/switches and based on enum value call appropriate functions.

## late binding

Enum solution would work, but it's very verbose, long to write and easy to make a mistake (eg forget an if/switch case, inconsistent handling in multiple places etc).

Instead of integer, we could store a pointer. Why constantly check integer when we can just use the pointed function?

```c++
#include <iostream>
#include <memory>
#include <vector>

class animal
{
public:
    animal(void (*func_ptr)()) : func_ptr(func_ptr)
    {
        std::cout << "animal::animal()\n";
    }
    
    ~animal()
    {
        std::cout << "animal::~animal()\n";
    }

    void sound() const
    {
        (*func_ptr)();
    }

private:
    void (*const func_ptr)(); // late binding - set up at runtime
};

void cat_sound()
{
    std::cout << "meow\n";
}

void dog_sound()
{
    std::cout << "whoof\n";
}

class cat : public animal
{
public:
    cat() : animal(&cat_sound)
    {
        std::cout << "cat::cat()\n";
    }

    ~cat()
    {
        std::cout << "cat::~cat()\n";
    }
};

class dog : public animal
{
public:
    dog() : animal(&dog_sound)
    {
        std::cout << "dog::dog()\n";
    }

    ~dog()
    {
        std::cout << "dog::~dog()\n";
    }
};

int main()
{
    std::vector<std::unique_ptr<animal>> animals;
    animals.push_back(std::make_unique<cat>());
    animals.push_back(std::make_unique<dog>());

    for (const auto& a : animals)
        a->sound();
}
```

~~~
animal::animal()
cat::cat()
animal::animal()
dog::dog()
meow
whoof
animal::~animal()
animal::~animal()
~~~

What has been done in the example above is **late binding**. Function pointer gets different value depending on the type of the object which results in different functions being called.

It's also a better approach than enum - we setup it only once (in the constructor). No else-ifs or switches every time a function needs to be used, just pointer dereference.

However, we still have the problem with destructors.

Obviously, we can add another pointer and even more member pointers for each function we would want to **dispatch dynamically**. It would be sort of manual implementation of...

## virtual functions

Marking function as `virtual` changes it's binding. Virtual functions will use mechanism similar to the code above.

```c++
#include <iostream>
#include <memory>
#include <vector>

class animal
{
public:
    animal() { std::cout << "animal::animal()\n"; }
    // virtual function - will use late binding
    virtual ~animal() { std::cout << "animal::~animal()\n"; }

    // virtual function - will use late binding
    virtual void sound() const
    {
        std::cout << "???\n";
    }
};

class cat : public animal
{
public:
    cat() { std::cout << "cat::cat()\n"; }
    // this is no longer shadowing but a binding variant
    ~cat() { std::cout << "cat::~cat()\n"; }

    // this is no longer shadowing but a binding variant
    void sound() const
    {
        std::cout << "meow\n";
    }
};

class dog : public animal
{
public:
    dog() { std::cout << "dog::dog()\n"; }
    // this is no longer shadowing but a binding variant
    ~dog() { std::cout << "dog::~dog()\n"; }

    // this is no longer shadowing but a binding variant
    void sound() const
    {
        std::cout << "whoof\n";
    }
};

int main()
{
    std::vector<std::unique_ptr<animal>> animals;
    animals.push_back(std::make_unique<cat>());
    animals.push_back(std::make_unique<dog>());

    for (const auto& a : animals)
        a->sound();
}
```

~~~
animal::animal()
cat::cat()
animal::animal()
dog::dog()
meow
whoof
cat::~cat()
animal::~animal()
dog::~dog()
animal::~animal()
~~~

Now everything works as it should.

## how it works

In previous example, we used a member pointer to a function. It allowed to bind a function at runtime, giving the flexibility of late binding - different derived classes could set different function.

If we wanted to use more dynamically dispatched functions, we would need more pointers. Because real-life classes usually contain just few variables but dozens of functions, we would need a ton of pointers. That would impose a significant overhead - each object in addition to storing just few variables would store even a hundred of pointers. Pointers would contribute as the majority in object memory representation, causing the object to occupy even 10 times more memory than it's actual variables.

Because of this, the actual implementation of virtual functions is different.

## dynamic dispatch implementaton

<div class="note info">
The C++ standard does not mandate any concrete implementation of virtual functions. Still, what is presented below is the overwhelmingly the most popular implementation, used by most programming languages.
</div>

Because pointers can occupy a lot of space and adding more functions would increase the object size in memory, the most common way is to place all these pointers in a global structure knows as **virtual table**.

Then, each **polymorphic** object contains a pointer to the virtual table. This significantly reduces needed memory.

For each **polymorphic** type, compiler generates different virtual table. Objects of the same type use the same table.

Each object holds a pointer to it's appropriate virtual table which is automatically set in the constructor.

When a virtual function is called, an object accesses virtual table through it's member pointer. Then, uses the function pointer that is at certain offset in this virtual table.

Note that we do not need any concrete information about the actual object type - we rely on the fact that different types have different value of virtual table pointer.

### example manual implementation

It's possible to manually implemenent virtual tables, fill them with function pointers and set up table pointer (or reference) in each class constructor.

I initially wanted this to be a part of this lesson, but resigned for few reasons:

- virtual table definition uses complex syntax (pointers to *member* functions)
- filling virtual table requires a lot of explicit type convertions and we need to fill a separate table for each class
- the call of a virtual function requires double pointer dereference (first which table, then which function) which itself is a complex line because of member function pointers syntax

Still, if this doesn't discourage you, here is the link. TODO link

## features of virtual functions

Because each class receives own virtual table, it's possible to reuse some functions from other classes. Virtual table can consist of multiple reused function pointers but also few derived-type-specific function pointers that the derived type wants to *override*.

The ability to mix function implementations from different classes caused additional features of dynamic dispatch. In further lessons, you will be presented various aspects of these features and how to use them effectively.
