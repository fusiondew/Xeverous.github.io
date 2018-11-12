---
layout: article
---

A term definitely heard often when talking about pointers and optimization but not everyone understands it clearly.

## what it is

**Strict aliasing** - an **assumption**, that dereferencing pointers/references to objects of **unrelated types** will never **alias**.

This is the shortest definition I could form, but the wording requires a bit of explanation.

- **assumption** - Like with undefined behaviour, it is not always possible to verify that it does not happen so compilers assume it never happens. They do output warnings if they happen to find it, but unverifiable cases are just blindly trusted.
- **unrelated types** - Types that do not share a common parent class or cv-qualification. Signess is ignored (may alias).
- **aliasing** - Referring to the same memory location. Two pointers alias if they point to the same memory cell. We can also speak of aliasing in terms of arrays - they alias if ranges overlap. Aliasing does not have to be a 2-side relation.

## why it is important

- String aliasing allows multiple optimizations. Having a rule that excludes some objects from being accessed allows to remove some load/store instructions and operate completely on registers.
- String aliasing is a form of aggressive optimization. It relies on trust to the code - compilers are not able to always verify it so breaking this rule leads to hidden undefined behaviour.
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

In such case the result should be 6, so we can not optimize the function to return a fixed value.

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

## exceptions

- For obvious reasons any (potentially cv-qualified) variation of `void*` is excluded from strict aliasing. Void pointers may alias everything.
- For less obvious reasons, also:
  - C: any (potentially cv-qualified) signed/unsigned/unspecified `char*` is excluded
  - C++: any (potentially cv-qualified) unsigned/unspecified `char*` is excluded

## type punning

Sometimes you want to interpret one's type memory as it was of different type. Such inspection is named **type punning**. Type punning is usually needed when interacting with OS API, doing networking or serialization.

The naive way is to simply cast a pointer to a different type - such pointer then aliases the former object.

```c++
int n = 1;

// C
float* f = (float*)&n; // UB, violates strict aliasing
// C++
float* f = reinterpret_cast<float*>(&n); // UB, violates strict aliasing
```

## type punning without SA violations

There are multiple alternatives.

### union

This unfortunately works only in C. In C++ accessing a different union member than the last assigned one is undefined behaviour. Beware of this when porting a C project to C++.

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
