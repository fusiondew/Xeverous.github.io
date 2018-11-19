---
layout: article
---

A term definitely heard often when talking about pointers and optimization but not everyone understands it clearly.

## what it is

**Strict aliasing** - an **assumption**, that dereferencing pointers/references to objects of **unrelated types** will never **alias**.

This is the shortest definition I could form, but the wording requires a bit of explanation.

- **assumption** - Like with undefined behaviour, it is not always possible to verify that it does not happen so compilers assume it never happens. They do output warnings if they happen to find it, but unverifiable cases are just blindly trusted.
- **unrelated types** - Types that do not share a common parent class or cv-qualification. Signess is ignored (may alias).
- **aliasing** - Referring to the same memory location. Two pointers alias if they point to the same memory cell. We can also speak of aliasing in terms of arrays - they alias if ranges overlap. Aliasing does not have to be a 2-side relation: pointers of base types may alias derived type objects, but derived type pointers can not alias base type objects.

## why it is important

- Strict aliasing allows multiple optimizations. Having a rule that excludes some objects from being accessed allows to remove some load/store instructions and operate completely on registers.
- Strict aliasing is a form of aggressive optimization. It relies on trust to the code - compilers are not able to always verify it but they perform optimization transformations based on this assumption. Breaking strict aliasing leads to undefined behaviour.
- Some low-level code requires *type punning* which is prone to strict aliasing violations.

## examples

Here we have a simple function taking 2 pointers.

```c++
int func(int* p1, int* p2)
{
    *p1 = 2;
    *p2 = 3;
    return *p1 + *p2;
}
```

```asm
func(int*, int*):
        mov     DWORD PTR [rdi], 2   ; *p1 = 2
        mov     DWORD PTR [rsi], 3   ; *p2 = 3
        mov     eax, DWORD PTR [rdi] ; tmp = *p1
        add     eax, 3               ; tmp += 3
        ret                          ; return tmp
```

Looking at the assembly we find a surprise - why does the compiler perform load again on the first pointer? Why this was not optimized to just return 5?

The answer is simple: **these pointers may alias**. Someone might do this:

```c++
int x = 0;
func(&x, &x); // save 2, overwrite with 3, return 3 + 3
```

In such case the result should be 6, so we can not optimize the function to return a fixed value. That's why first value is reloaded after second is assigned - it might have changed.

Let's add some abstraction.

```c++
struct s1 { int val; };
struct s2 { int val; };

int func(s1* p1, s2* p2)
{
    p1->val = 2;
    p2->val = 3;
    return p1->val + p2->val;
}
```

```asm
func(s1*, s2*):
        mov     DWORD PTR [rdi], 2 ; p1->val = 2
        mov     DWORD PTR [rsi], 3 ; p2->val = 3
        mov     eax, 5             ; return 5
        ret
```

Now the assembly is optimized and the function has hardcoded return value. This is because **`s1` and `s2` are unrelated types - they can not alias**.

The function can not be given two pointers that refer to the same memory location so the compiler is allowed to precompute return value assuming pointers are always different.

## impact on performance

This really depends on the hardware. On some architectures unwanted aliasing may cause to flush buffers and reload the cache after every load-hit-store combo which has a high cost.

More details on the problem: https://en.wikipedia.org/wiki/Load-Hit-Store.

## exceptions

- For obvious reasons any (potentially cv-qualified) variation of `void*` is excluded from strict aliasing. Void pointers may alias everything.
- For less obvious reasons, also:
  - C: any (potentially cv-qualified) signed/unsigned/unspecified `char*` is allowed to alias
  - C++: any (potentially cv-qualified) unsigned/unspecified `char*` is allowed to alias

## enabling SA-based optimizations

### C

C has special keyword for indicating that 2 pointers may not alias.

```c
int func(int* restrict p1, int* restrict p2);
```

Because [restrict rules are complex](https://en.cppreference.com/w/c/language/restrict) and C++ has much more complex type system the keyword does not exist in C++. Many compilers offer is as non-standard extension though.

Invalid use of `restrict` is undefined behaviour because optimizers will transform the code on false assumptions, making some wanted assignments impossible to happen.

### C++

The simplest way is to add abstraction - user defined types that do not share a common parent type.

Contracts which come in C++20 might also allow explicit specification that pointers may not alias.

## type punning

Sometimes you want to interpret one's type memory as it was of different type. Such inspection is named **type punning**. Type punning is usually needed when interacting with OS API, doing networking or serialization.

The naive way is to simply cast a pointer to a different type - such pointer then aliases the former object.

```c++
float n = 1.0f;

// C
int* n = (int*)&f; // UB, violates strict aliasing
// C++
int* n = reinterpret_cast<int*>(&f); // UB, violates strict aliasing
```

## type punning without SA violations

### union

```c
union {
    float f;
    int n;
} u;

u.f = 1.0f;
// use u.n ...
```

This unfortunately works only in C. In C++ accessing a different union member than the last assigned one is undefined behaviour. Beware of this when porting a C project to C++.

Major C++ compilers do not take advantage of this fact, probably because there are no interesting transformations that could improve performance. Still, such code is not well-defined and may break at any time.

### `-fno-strict-aliasing`

**Strongly discouraged.** Disabling strict aliasing will impact performance of the entire program. Do not use this unless you have no other choice.

### memory copy

Void pointers may alias everything, hence this is the standard way to perform type punning. Calling a function might seem heavy, but compilers already have a lot of mem-related function optimizations and easily catch it that we want to perform type punning and optimize following code to register moves.

```c++
template <typename T, typename U>
T type_pun(U value) noexcept
{
    static_assert(sizeof(T) == sizeof(U));
    static_assert(std::is_trivial_v<T>);
    static_assert(std::is_trivially_copyable_v<U>);
    T result;
    std::memcpy(&result, &value, sizeof(value));
    return result;
}
```

The function above is available in C++20 as `std::bit_cast`. It is also `constexpr`.
