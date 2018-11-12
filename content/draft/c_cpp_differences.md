---
layout: article
---

Below is a (hopefully complete) list of differences between C and C++.

I do not list features that are only in one language, only stuff that exists in both but has different meaning.

## size of characters

In C, character expressions are of integer type.

```c++
// C
sizeof('a') == sizeof(int)
// C++
sizeof('a') == sizeof(char)
```

## string literals

C allows to assign string literals to non-const pointers

```c++
char* str = "abc"; // valid C, invalid C++
```

Attempting to modify such string is still undefined behaviour.

## empty parameter list

In C, function with no parameters is treated only as a name declaration - arguments are still unspecified.

```c++
// C  : 'func' declaration with unspecified amount and types of arguments
// C++: 'func' declaration that takes 0 arguments
void func();

// C  : 'func' declaration that takes 0 arguments
// C++: as above, just a bad style
void func(void);
```

## keywords

- C++ has no `restrict` keyword. There were some attempts to bring it but it is already complicated in C - in C++ due to classes it could very easily become a source of bug-prone optimizations.
- C++ has no meaning for `register`, the keyword remains reserved.

## linkage

Names in the global scope that are `const` and not `extern` have external linkage in C, but internal linkage in C++.

```c++
const int n = 1;
// C  : can     be referred from other translation units
// C++: can not be referred from other translation units (requires extern)
```

## unions

C allows unions for type punning.

C++ has constructors and destructors which complicate the situation. Unions allows only to access last assigned member and any other access is undefined behaviour.

```c++
// valid C, UB in C++
union {
	int n;
	char bytes[4];
} packet;

packet.n = 1;
if (packet.bytes[0] == 1) // accessing other member
	// ...
```

## strict aliasing

In C, (potentially cv-qualified) signed/unsigned/unspecified `char*` may alias.

In C++, only (potentially cv-qualified) unsigned/unspecified `char*` may alias.
