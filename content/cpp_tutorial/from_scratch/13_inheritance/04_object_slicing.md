---
layout: article
---

Consider a very simple inheritance:

```c++
struct base { int foo; };
struct derived : base { int bar; };
```

**Object slicing** happens when derived type gets assigned to base:

{% include_relative 04_object_slicing/ex2.html %}

Assignment operator expects `const base&`. Since `d` is `derived` it's also a `base` and the operator has no problem taking an object - but it only uses the `base` part of `d`. **Remaining information is lost.**

## more severe case

{% include_relative 04_object_slicing/ex3.html %}

~~~
d1.foo: 3
d1.bar: 2
~~~

**The resulting object contains mixed data from both `d1` and `d2`.**

Reference binding itself is not bad. We can use objects of derived types just like they were base (the use is limited to base class features).

```c++
base& b_ref = d1;
```

The problem happens here:

```c++
b_ref = d2;
```

This line assigns `d2` to `d1` through a reference to `base`. Since it sees the object only as a `base`, it only assigns `base` memebers. `d1` ends in a half-assigned state.

<div class="note pro-tip">
Do not assign or invoke copy or move constructors through references unless you can guuarantee that there are no derived types or both objects are of the same type as the reference.
</div>

## derived types as arguments

Object slicing can also happen when passing arguments to functions:

```c++
void func(const base& b); // good, will not invoke slicing
void func(base b);        // bad, base can be a slice of bigger object
```

The same recommendation applies here - when there is some inheritance hierarchy you should take objects by (const) reference.
