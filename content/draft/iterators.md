---
layout: article
---

### Iterators

You might already encounter this term. But what does it really mean? What is the purpose of iterators? Where/Why they are better than ordinary integer i?

Have a look at a typical array loop:

```c++
std::vector<int> v = { 3, 4, 9, -7, 8, 2, 0, -11 };
for (std::size_t i = 0; i < v.size(); ++i)
    std::cout << v[i] << '\n';
```

`operator[]` is used to access the elements. Vector is relatively simple structure in which array indexes are just pointer arithmetics. `v[i]` just accesses internal array start pointer and adds `i` to it. But what if the structure is not a continuous block of memory? Some containers forms trees or multiple arrays.

The different way to do the loop - using iterators:

```c++
for (auto it = v.begin(); it != v.end(); ++it)
    std::cout << *it << '\n';
```

It does the same thing but has noticeable differences:

- `begin()` is used to initialize the iterator
- iterator is compared with `end()`
- the comparison uses `!=` instead of `<`
- element is accessed by `*it`

This brings us to one question

#### Are iterators just a fancy name for pointers?

Not really. Indeed, the simplest form of an iterator is a pointer. But it's true only for continuous storage containers. Linked lists, trees or even more complex data structures can not just give user pointers to iterate, because elements are not stored next to each other.

This is **why iterators are needed. They abstract the way elements are accessed and how to move from one to another.**

### conventions

Iterators have a very strong convention of their syntax and behaviour in C++.