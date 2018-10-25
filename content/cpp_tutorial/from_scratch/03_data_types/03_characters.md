---
layout: article
---

## encoding

Characters are stored as numbers (integers). Depending on the encoding, different values represent different characters.

The simplest encoding - [ASCII](https://en.wikipedia.org/wiki/ASCII) was formed from telegraph code. It is a 7-bit encoding consisting of latin letters, digits, simplest math symbols and some control codes. Most of control codes are now obsolete - computers do not need to perform mechanical tasks that teleprinters had to; codes that are still being used are carriage return (CR), line feed (LF), vertical tab (VT) and null terminator (NUL). [ASCII chart](https://en.cppreference.com/w/cpp/language/ascii).

Multiple different encodings have been created (Unicode variations: UTF-8, UTF-16, UTF-32) to support other alphabets and more complex symbols. Some of them require larger integers.

## line ending

Teleprinters and typing machines after each output character moved cartridge to the right by a fixed distance. Before printing characters on a new line they had to move their carriage left back to the first column. CR (carriage return) code was used for this purpose. CR was followed by LF (line feed) which commanded the device to move 1 text row down.

Such operations are no longer needed but Microsoft's operating systems (MS-DOS and later Windows series) still preceed LF by CR, probably for some very deep backwards compatibility.

Unix systems do not use CR - they separate text lines by LF only.

Mac OS prior to version X used purely CR, then switched to purely use LF.

In Notepad++ there is a feature to see all control characters:

![Notepad++ show all characters](https://i.stack.imgur.com/3Yo4K.png)

The file on the image above contains mixed endings. It can be fixed by Edit -> EOL Convertion.

**consequences**

Mac OS X (+ later versions) and Unix systems do not have problems reading files from Windows - CR is a non-printable character and text editors just ignore it.

Built-in notepad program in Windows does not understand pure LF line endings and such text files are displayed as one long line.

Some programs may not read lines correctly when they are given a file with unusual or inconsistent endings. There are command line tools that can fix them: `dos2unix` (CRLF to LF), `unix2dos` (LF to CRLF) and `sed` (any custom find-replace regex).

**opening files in C++**

Later, there will be a guide how to deal with different encodings and line endings in C++.

## character types in C++

- `signed char` - signed 8-bit (or larger) integer
- `unsigned char` - unsigned 8-bit (or larger) integer
- `char` - treated as distinct type at language level but one of the 2 above depending on the target architecture (on x86 and x86_64 signed, on ARM and PowerPC unsigned)
- `char16_t` - integer capable of holding any character from UTF-16 encoding
- `char32_t` - integer capable of holding any character from UTF-32 encoding
- `wchar_t` - type for wide characters; 32-bit integer on systems that support Unicode but 16-bit on Windows

<details>
    <summary>`char8_t`</summary>
    <p>There is a proposal for `char8_t` type, it gives improvements for more strict text handling and helps with Unicode but it somewhat breaks backwards compability. It's currently discussed what will be done in this manner.</p>
</details>

**Example**

```c++
#include <iostream>

int main()
{
    char c = 'A';
    int i = c; // there is a hidden convertion here
    std::cout << "character: " << c << "\n";
    std::cout << "stored as number: " << i << "\n";
}
```

~~~
character: A
stored as number: 65
~~~

Character `'A'`, when interpreted as a number has value `65`. By using different types we achieve different meanings (here: character/number).
