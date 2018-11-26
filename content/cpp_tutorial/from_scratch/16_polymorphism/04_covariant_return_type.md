---
layout: article
---

Virtual functions do not need to have exactly the same return type. It's allowed to be **covariant**.

2 return types of `base::func` and `derived::func` are covariant if:

- both are first-level pointers or reference to classes
- references/pointed-to class in the return type of `base::func` is a base class of the type referenced/poined-to by `derived::func`
- return type of `derived::func` must be equally or less cv-qualified than the return type of `base::func`

The return type of `derived::func` must be a complete type (no forward declared types allowed) or pointer/reference to `derived`.

**rationale**

Very different return types are not possible because at the point of virtual function call we do not know which actual function is called. This should be obvious.

But because all pointers to data types have no difference on the machine instruction level, we can return similar types of pointers/references - all in all they are just memory addresses.

Covariant pointers/references are limited to the same hierarchy so that all covariant return types share a common base.

```c++
struct B { /* ... */ };

struct base
{
    virtual B& func();
};

struct D : B { /* ... */ };

struct derived : base
{
    D& func() override; // allowed, because D is inherited from B
};
```

If we call a virtual function from base, we get some common base type.

```c++
base& ref = /* ... */;
B& result = ref.func(); // we see B& it it might be D&
```

But if we call a virtual function from deeper level, we get more detailed type information:

```c++
derived& ref = /* ... */;
D& result = ref.func(); // we get more precise type information
```

Note that when we call virtual functions we usually do it from the base class - we just see only the base type of the result. But if we call virtual function at some deeper level, we can do more - normally in the example above both `func()` would need to return `B&`.

**If we can manage to get a reference to some more derived type, covariant return types reward us with more precise return type information.**

## applications

You know that it's wrong to copy/assign objects of polymorphic types - we are not sure which type it is exactly and can end in object slicing.

To solve this problem, we can use virtual function mechanism to copy objects.

```c++
struct base
{
    virtual base* clone() const;
};

struct derived : base
{
    base* clone() override; // returns derived type
};

struct more_derived : derived
{
    base* clone() override; // returs more derived type
};
```

Now, when we get a `base&` we can `.clone()` and be sure that the returned object is of the same type as the object on which the function was called.

If we add covariant return types to the code above, we are rewarded with more precise information when cloning objects:

```c++
struct base
{
    virtual base* clone() const;
};

struct derived : base
{
    derived* clone() override;
};

struct more_derived : derived
{
    more_derived* clone() override;
};
```

In some situations, we can manage to use more precise pointers/references. Imagine there is a game where there are `animal`s. All animals have `clone()` available for replication. `fish`es have specific skills which are not available to all `animal`s - fish-specific virtual functions start at the `fish` class level - there is no such function in the base `animal` class.

If at some point in the game, we can prove that in the given place there are only `fish`es (or more derived types) covariant return type of `clone()` allows us to call fish-only methods which do not exist for base `animal`.

```c++
struct animal
{
    virtual animal* clone() const;
};

struct fish : animal
{
    // ... inherited methods + more from fish
    virtual void fish_specific_skill();

    fish* clone() const override;
};

struct specific_fish : fish
{
    // even more methods...
    void fish_specific_skill() override;

    specific_fish* clone() const override;
};
```

```c++
animal& a1 = /* ... */;
animal* a2 = a1.clone(); // we can only use what all animals can do

fish& f1 = /* ... */;
fish* f2 = f1.clone(); // f2 offers more functions than a2, but we must prove that f1 is a fish
```

**Note:** the clone method is const-qualified because it should not modify cloned object. Returned pointer to new object is non-const because it's a different object (not a situation for const illusion).

## deeper analysis

The examples above use plain **owning** pointers. It's of course bad but covariant return types limit us to pointers and references only. References would be misleading as objects are allocated dynamically but references should never be owners.

Such restrictions limit potential benefits of covariant return types. This feature rewards us with more detailed return type information for more detailed objects but imposes a quite error-prone implementation lacking RAII.

Personally, I haven't ever found a good real-life situation where I would prefer covariant return types to smart pointers. So my recommendation is to resign of this feature in faviour of RAII:

```c++
struct animal
{
    virtual std::unique_ptr<animal> clone() const;
};

struct fish : animal
{
    // ... inherited methods + more from fish
    virtual void fish_specific_skill();

    // smart pointers are classes so it's impossible for them to be covariant
    std::unique_ptr<animal> clone() const override;
};
```

There is also another rationale: checking actual type at runtime is very often a code smell. The magic of polymorphism is that once an object is constructed, we should forget which type it is and just treat it by virtual functions.

Still, if we really want to check an object's actual type, there are way to do it.
