---
layout: article
---

So far all functions that were used were implemented by the compiler as **early binding**. This means that for code like `obj.func()` compiler inserts the instruction "call the function located at address xyz"

If we use function pointers, we can change that behaviour - then the compiler insterts pointer dereference and function call (that will be run at whatever the pointer holds). Then it's a sort of **late binding** since we can not state at compile time which function will be run.

## the virtual table

Let's assume someone was very clever when building a game and put quite sophisticated efforts into pointers.

Read the following code carefully.

```c++
#include <iostream>
#include <vector>
#include <memory>

// struct that will hold some metadata
struct vtable; // forward declare, we need just name

class animal
{
public:
    const std::string& get_name() const { return name; }

    // these methods will behave differently depending on the metadata
    bool has_tail() const;
    bool has_wings() const;
    void sound() const;

protected: // we do not want animals to be created directly
    animal(const vtable* vtable_ptr, std::string name) : vtable_ptr(vtable_ptr), name(std::move(name)) { }

private:
    friend vtable;

    const vtable* const vtable_ptr; // access metadata but don't change it
    std::string name;
};

class cat : public animal
{
public:
    cat(std::string name);

    // intentional shadowing
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

    // intentional shadowing
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

    // intentional shadowing
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

// global metadata objects
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

// now we set vtable pointers to appropriate metadata
cat::cat(std::string name) : animal(&vtable_cat, std::move(name)) { }
dog::dog(std::string name) : animal(&vtable_dog, std::move(name)) { }
parrot::parrot(std::string name) : animal(&vtable_parrot, std::move(name)) { }

// base class functions will now use this metadata and call appropriate function
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
    {
        a->sound();
    }
}
```

~~~
grumpy does meow
nyan does meow
doge does whoof
party does crrra
~~~

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
