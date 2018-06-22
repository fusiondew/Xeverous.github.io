---
layout: article
---

Ok, you probably surmised what destructors do. Like constructors, they are inevitable and are always called when an object is destroyed (goes out of scope).

Destructors are written like constructors, but the class name is prepended with `~`.

```c++
class foo
{
public:
    foo();  // ctor
    ~foo(); // dtor
};
```

However, one thing comes to mind - what would be a possible use of parameters in destructors? How would I call a destructor on an expiring object?

The answer is simple: you can't. **Destructors are always 0-argument and can not be overloaded.** So every class always has exactly 1 destructor (implicit or custom one) and you can at most customize it's body.

## purpose of destructors

Usually custom destructors are not needed - we do not care with member variables that die - there is no point in resetting them to zero or something similar.

**But what if memory is dynamically allocated?** Destructors are then the best way to always enfore cleanup!

Look how useful destructors can become when dealing with dynamic allocation:

```c++
class dynamic_array
{
private:
    int* const data;
    const int size;

public:
    dynamic_array(int size);
    ~dynamic_array();
};

dynamic_array::dynamic_array(int size)
: data(new int[size]), size(size)
{
}

dynamic_array::~dynamic_array()
{
    delete[] data;
}
```

I used const pointer and const size as it does not change through the lifetime of objects of this class. This also forces us to correctly use member initializer list - and as you see, you can put arbitrary expressions there.

In this simple class ctor + dtor form an inevitable pair that is impossible to break through - if someone creates an object of type `dynamic_array`, it's guaranteed to execute both ctor and dtor and therefore both allocation and deallocation of memory.

```c++
{
    dynamic_array da(1000); // ctor called, allocates memory for 1000 integers

    // ...da is used...

} // dtor called here, releases memory
```

Note that destructor calls are not written - you don't write `da.~dynamic_array();` or something similar - it's done automatically. It's actually possible to do this but the current level of this chapter is far behind situations in which you would need to manually call destructors.

## going further

We can now write a class that safely manages dynamic memory. By adding more public functions, we can extend it's functionality while preserving invariants. With the help of operator overloading, we can even make `da[i]` work just like it does with plain pointers.

## ???

TODO ??? something is likely missing
