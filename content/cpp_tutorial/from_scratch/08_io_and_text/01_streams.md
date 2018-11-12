---
layout: article
---

C++ offers a variety of streams, some which share common properties.

**Stream** - something that can input and/or output data (usually in the form of text).

Streams in the standard library come from `basic_*stream` templates which offer a generic interface to implement various input/output facilities. `CharT` is the type of characters that given stream is operating on (eg `char`, `char32_t`, `wchar_t`) and `Traits` specify concrete behaviour of operations.

![IO library inheritance diagram](http://upload.cppreference.com/mwiki/images/0/06/std-io-complete-inheritance.svg).

Obviously you do not even know classes (custom types) yet, but the diagram should clearly outline which types share common functionality.

- `ios_base` is the **base** of **i**nput/**o**utput **s**ystem.
- `basic_ios` is a template that is used to create all stream types.
- `basic_istream` and `basic_ostream` are simplest **i**nput and **o**utput **stream** templates. C++ offers few global objects that are bound to underlying operating system's text input/output interface:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>full type name</th>
                <th>type alias</th>
                <th>global object</th>
                <th>bound to</th>
            </tr>
            <tr>
                <td rowspan="3">std::basic_ostream&lt;char&gt;</td>
                <td rowspan="3">std::ostream</td>
                <td>std::cout</td>
                <td>STDOUT</td>
            </tr>
            <tr class="even">
                <td>std::cerr</td>
                <td>STDERR (unbuffered)</td>
            </tr>
            <tr>
                <td>std::clog</td>
                <td>STDERR</td>
            </tr>
            <tr class ="even">
                <td rowspan="3">std::basic_ostream&lt;wchar_t&gt;</td>
                <td rowspan="3">std::wostream</td>
                <td>std::wcout</td>
                <td>STDOUT</td>
            </tr>
            <tr>
                <td>std::wcerr</td>
                <td>STDERR (unbuffered)</td>
            </tr>
            <tr class="even">
                <td>std::wclog</td>
                <td>STDERR</td>
            </tr>
            <tr>
                <td>std::basic_istream&lt;char&gt;</td>
                <td>std::istream</td>
                <td>std::cin</td>
                <td>STDIN</td>
            </tr>
            <tr class="even">
                <td>std::basic_istream&lt;wchar_t&gt;</td>
                <td>std::wistream</td>
                <td>std::wcin</td>
                <td>STDIN</td>
            </tr>
        </tbody>
    </table>
</div>

- `basic_istringstream`, `basic_ostringstream` and `basic_stringstream` are templates to implement string input/output/input+output operations
- `basic_ifstream`, `basic_ofstream` and `basic_fstream` are templates to implement file input/output/input+output operations

There are no global string and file stream objects - the intent is to create them on demand when one wants to perform string or file operations.

All streams except error streams have buffered output. This means that their output may not appear instantly on the screen (on all major systems appear anyway).

## in practice

**output**

Practically only `std::cout`, `std::cerr` and `std::cin` are used. Most data is encoded in pure ASCII or in UTF-8 so type `char` satisfies all common needs.

Sometimes you may see `std::wcout` being used on Windows because Unicode parts of WinAPI use UTF-16 encoding.

TODO remainer block

`wchar_t` on Windows is 16-bit, on any other system 32-bit.

**file operations**

Streams are divided into ones that perform reading/writing/reading+writing for maximum compatibility. Some files may be read-only and many systems offer write only file streams in the form of console terminals.

On unix systems you can use `ls -l` (or common alias: `ll`) to see file privilegdes.

TODO color ll output

~~~
xeverous@localhost~/ $ ll
total 354
-r--r--r-- 1 xeverous 197121     10 nov  5 19:49 read_only_file
-rw-r--r-- 1 xeverous 197121     29 nov  4 14:08 file
-rwxr-xr-x 1 xeverous 197121 353187 nov  5 19:48 executable_program*
drwxr-xr-x 1 xeverous 197121      0 nov  5 19:48 directory/
~~~

Opening a file with insufficient priviledges would instantly set stream's state to failure.
