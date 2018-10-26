---
layout: article
---

Previously skipped, now you should understand string literals - they are actually arrays of `char` (or other character type).

```c++
int main()
{
    const char[] str = "abc";
}
```

However, their size is larger than it seems to:

```c++
int main()
{
    const char[3] str = "abc";
}
```

```c++
main.cpp: In function 'int main()':
main.cpp:5:25: error: initializer-string for array of chars is too long [-fpermissive]
     const char str[3] = "abc";
                         ^~~~~
```

This is because literal strings have actually 1 more character: the hidden null termination character, notably `'\0'`.

The name "null termination character" has nothing to do with null pointers. Just a coincidence.

## C strings

<div class="note info">

String literals are also known as **C strings**.
</div>

Every literal string has appended null termination character at the end

```c++
// pseudocode
""      == { '\0' }
"a"     == {  'a', '\0' }
"ab"    == {  'a',  'b', '\0' }
"abc"   == {  'a',  'b',  'c', '\0' }
"a\0bc" == {  'a', '\0',  'b', 'c', '\0' }
```

This gives the benefit that given a `const char*`, we do not have to know the length - we can print as long as the character is not null character.

```c++
#include <iostream>

int main()
{
    const char str[] = "literal string of any length";

    for (int i = 0; str[i] != '\0'; ++i) // this will work even for str == ""
        std::cout << str[i];
}
```

String literals (character arrays) can be implicitly converted to `const char*` (or other pointer-to-const-character types).

```c++
const char* str = "literal string of any length";
```

### printing strings

Streams can take character pointers and print them:

```c++
#include <iostream>

int main()
{
    const char* str = "literal string of any length";
    std::cout << str << "\n"; // does the same loop - prints untill '\0' is hit

    const char str2[] = "another string\0this part will not be printed";
    std::cout << str2 << "\n"; // as above, but additionally implicitly decays array to pointer
}
```

~~~
literal string of any length
another string
~~~

This is the only case for character pointers - instead of printing the address they loop and print memory contents until null terminator is found.

Any other pointer types results in `0xhexvalue` being printed.

#### Question: What if the string has no null terminator?

The printing loop would not stop. Going outside range would cause undefined behaviour - usually printing some random characters untill crash or accidental null terminator.

### string literal concatenation

String literals can be split to multiple lines:

```c++
// this will be concatenated by the compiler
const char* str = "a very very very very very"
    " very very very very very very very very"
    " very very very very very very very very"
    " very very very very very very very very"
    " very long string literal";
```

### raw strings

Raw strings do not feature character escapes. Data is read exactly as it is written.

TODO HTML syntax form

```c++
const char[] raw_1 = R"(\a\b\c)"; // would print \a\b\c
const char[] raw_2 = R"xyz(\a\b\c)xyz"; // delimeter xyz is ignored

// these 2 are the same
const char[] str_3 = "\nHello\nWorld // comment\n";
const char[] raw_3 = R"(
Hello
World // comment
)";
```

Raw strings are useful when defining *regular expressions* or other strings that tend to contain a lot of symbols.

## comparing C strings

```c++
#include <iostream>

int main()
{
    const char str1[] = "abc";
    const char str2[] = "abc";

    if (str1 == str2)
        std::cout << "strings are identical\n";
    else
        std::cout << "strings are not identical\n";
}
```

The output of this program is actually *unspecified*. There is a problem here - **strings are not actually compared here. `str1 == str2` actually compares values of pointers!**

Depending on the compiler optimization, the statement might be false because both strings occupy different memory blocks or be true because both arrays got optimized to the same place.

To correctly compare 2 strings, we would need to use a loop and compare respective characters:

```c++
#include <iostream>

int main()
{
    const char str1[] = "abc";
    const char str2[] = "abc";

    bool identical = true;

    for (int i = 0; str1[i] != '\0' || str2 != '\0'; ++i)
    {
        if (str1[i] != str2[i])
        {
            identical = false;
            break;
        }
    }

    if (identical)
        std::cout << "strings are identical\n";
    else
        std::cout << "strings are not identical\n";
}
```

There is a function for this (`strlen()` in C), so that you don't have to write such loop every time.

## C++ strings

Of course, the tutorial is still at C feature level and you have yet to learn functions and classes and then use C++ string: the `std::string` class.

Now, here is a short demonstration what C++ string class is capable of, thanks to it's functions and overloaded operators.

```c++
#include <iostream>
#include <string>

int main()
{
    std::string str1 = "abc";
    std::string str2 = "a";
    str2 += "bc"; // magic memory operations inside

    if (str1 == str2) // works and does what you think it does
        std::cout << "strings are identical\n";
    else
        std::cout << "strings are not identical\n";

    str2 += "def";
    std::cout << "current str2 length: " << str2.length() << "\n"; // prints 6
}
```

String class may seem intuitive and powerful but it's thanks to it's hidden mechanisms which are explained in few next chapters. Untill classes chapter, I will use C strings.
