---
layout: article
---

## expensive getters

Sometimes some member functions may be used more than others. Consider a situation where there is a class that performs physical calculations and the result takes some time to compute.

```c++
class physics_state
{
private:
    int amount;
    double velocity;
    double time_in_ms;
    // more data...

public:
    // setters for data...

    physics_result compute_result() const; // very expensive
};
```

Computation function returns the result by value because it's an object created inside it (otherwise it would be a dangling reference).

So far everything looks correct:
- all data is private
- setters secure invariants (otherwise computation result would be meaningless)
- computation function is const-qualified

But there is one problem - we know that data doesn't change often but we often need the computation result. If we call this function over and over, we are continuously repeating the same (expensive) calculation. We should implement some caching so that if data has not changed just return the last result.

```c++
class physics_state
{
private:
    int amount;
    double velocity;
    double time_in_ms;
    // more data...

    physics_result last_result; // cached result - return it if data has not changed

public:
    // setters for data...

    // now return reference
    const physics_result& compute_result() const; // const?
};
```

But now there is another problem - the computation function can no longer be const-qualified because if data has changed since last call, it has to modify last result.

## the `mutable` keyword

```c++
class physics_state
{
private:
    int amount;
    double velocity;
    double time_in_ms;
    // more data...

    mutable physics_result last_result; // cache

public:
    // setters for data...

    const physics_result& compute_result() const; // can be const
};
```

Member `last_result` is `mutable`. **Mutable member variables can be modified inside const-qualified functions.**

`mutable` is used to implement caches, mutexes and lazy evaluation. Thanks to this keyword, we can still have const-qualified functions even if they modify some data.

## recommendation

<div class="note pro-tip">
Const-qualify member functions that do not modify publicly visible state. Use `mutable` only when necessary to satisfy function constness.
</div>

Don't get it wrong - do not const-qualify a function just becase it can be. Action-like functions should not be const-qualified even if they can - they may just happen to not modify any member data (but may affect some global state or external program). Chances are that later they will need to modify some data and you would then need to drop that `const` (and likely get many compilation errors).

Const-qualifying a member function should not depend just on whether function modifies some data or not. It should depend on the intention.

Examples:

- Should printing object affect it's state? No. If the communication with the printer requires some internal changes - make related variables `mutable`.
- A `refresh()` method currently does very little and does not modify member variables. Still, it should not be const-qualified because refreshing itself (as a verb) signals something is being rewritten. Very likely that in future program version function body will have to do more.

## other notes

- `mutable` fields can not be `const`
- `mutable` fields can not be `static`
- `mutable` fields can not be references (on member references in constructors lesson)
- `mutable` fields can be modified even if the expression that gives access to the object returns const-qualified reference
