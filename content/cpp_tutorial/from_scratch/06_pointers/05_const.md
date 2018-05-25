---
layout: article
---

`const` with pointers gains a second level of meaning

- a pointer can be const, meaning we can not change what address it holds
- a pointer can hold address of const object, meaning we can dereference but only to read

## syntax

```c++
      int*       ptr; //       pointer to       int
const int*       ptr; //       pointer to const int
      int* const ptr; // const pointer to       int
const int* const ptr; // const pointer to const int
```

This can be quite a mindfuck, but there is a simple trick - read the keywords in reverse order

```c++
   int  *  const
//         const
//   pointer to
// int

   const int  *
//            pointer to
//       int
// const
```

The most left-side `const` can be swapped with type name, but it does not change the meaning.

```c++
const int*       ptr; //       pointer to const int
int const*       ptr; //       (as above)

const int* const ptr; // const pointer to const int
int const* const ptr; // (as above)
```

## usage

The most commonly seen of all 4 permutations is `const int*` (pointer to const int). You will usually input such pointer to a function - it will be able to access your data, but read-only.

Pointers are rarely made themselves `const`, because in many scenarios they can become dangling so they would need to be set to null.

## exercise

TODO tons of examples to compile
