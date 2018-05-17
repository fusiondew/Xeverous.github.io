---
layout: article
---

## character types

Characters are stored as small integers. The simplest encoding - ASCII occupies numbers 0 - 127 but encodes only latin letters, digits, simplest math symbols and some control (line break, tabs, space, etc). Multiple different encodings have been created (UTF-8, UTF-16, UTF-32, Unicode) to support other alphabets and more complex symbols. Obviously they require larger integers.

- `signed char` - signed 8-bit (or larger) integer
- `unsigned char` - unsigned 8-bit (or larger) integer
- `char` - one of the 2 above, treated as distinct type at language level; On x86 and x86_64 signed, on ARM and PowerPC unsigned
- `char16_t` - integer capable of holding any character from UTF-16 encoding
- `char32_t` - integer capable of holding any character from UTF-32 encoding
- `wchar_t` - type for wide characters; 32-bit integer on systems that support Unicode but 16-bit on Windows

<details>
    <summary>`char8_t`</summary>
    <p>There is a proposal for `char8_t` type, it gives improvements for more strict text handling and helps with Unicode but it breaks backwards compability. It's currently discussed what will be done in this manner - committee wants to push more breaking changes as the C++ language must go forward and the evolution sometimes requires breaking backwards compability.</p>
</details>