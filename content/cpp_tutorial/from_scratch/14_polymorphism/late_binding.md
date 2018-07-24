---
layout: article
---

## early binding

So far all functions that were used were implemented by the compiler as **early binding**. This means that every time you call a function, compiler inserts specific address of this function there - it *binds* an address to a statement.

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

Such solution would work, but it's very verbose, long to write and easy to make a mistake (eg forget an if/switch case, inconsistent handling in multiple places etc).

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
    void (*const func_ptr)();
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

What has been done in the example above is **late binding**. Function pointers get different value depending on the type of the object which results in different functions being called.

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

Now everything works as expected.

## ???

Ok, that's truly some pointer sorcery. So what actually happens here?

1. We create 4 objects, each of type derived from `animal`
2. We put (smart) pointers of these objects to the vector.
3. There is no object slicing because we used (smart) pointers.
4. We call `animal::sound()` in the loop.
5. Different functions get executed depending on the type of animal.

But more important - how does it even work?

## late binding

1. Class `animal` contains a poiner to `vtable`.
2. `vtable` is a struct holding pointers to member functions.
3. There exist 3 tables: each containing different function addresses.
4. Classes derived from `animal` pass different `vtable` pointers to `animal`'s constructor.
5. `animal` methods access `vtable` and call functions which addresses are stored in the `vtable`.
6. Because each derived type provides different `vtable` pointer, `animal` functions will call different methods depending on which `vtable` pointer was given.
7. **`a->sound()` (and 2 other `animal` methods) are polymorphic** - which function is run depends on the provided **virtual table**.
