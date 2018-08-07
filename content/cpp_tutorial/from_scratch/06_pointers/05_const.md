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

Remember that the most left-side `const` can be swapped with type name, but it does not change the meaning.

```c++
const int*       ptr; //       pointer to const int
int const*       ptr; //       (as above)

const int* const ptr; // const pointer to const int
int const* const ptr; // (as above)
```

## guidelines syntax

Previously it was stated that `int* ptr` makes more sense than the right-side asterisk version because of intuitive `type name` separation. In the case of more complex pointers, situation is a little different:

```c++
const int* ptr; // good, clear separatino of type and name
const int *ptr; // bad habit from C, it's not named *ptr neither unary operator

const int* const ptr; // good, const pointer to const int
const int *const ptr; // [syntax used on guidelines] also good because stuff is grouped
//        ^^^^^^ "const pointer to"
//^^^^^^^ "const int"
```

In the case of double const, it is reasonable to place the asterisk next to the right const - in result there is a clear separation `pointed_type pointer_type name`.

If you feel overwhelmed by the amount of rules - just stick the asterisk where it's more intuitive for you (but be consistent). It does not matter for the compiler.

## usage

The most commonly seen of all 4 permutations is `const int*` (pointer to const int or other const type). You will usually input such pointer to a function - it will be able to access your data, but read-only.

Pointers are rarely made themselves `const`, because in many scenarios they can become dangling so they would need to be set to null and in other scenarios references could be used instead.

## exercise

TODO tons of examples to compile
