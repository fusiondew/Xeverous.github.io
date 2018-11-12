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
- `basic_ostream` and `basic_istream` are simplest **i**nput and **o**utput **stream** templates. C++ offers few global objects that are bound to underlying operating system's text input/output interface:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>full type name</th>
                <th>type alias</th>
                <th>object</th>
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

All streams except error streams have buffered output. This means that you do not have to worry about irregular or malformed order of input/output.

## using different streams

<div class="note info">
Section below presents system-specific behaviour. Examples assume generic unix system terminal and may not be as accurate for other systems (eg Windows).
</div>

Operating systems offer 2 output streams and 1 input stream:

- STDIN - standard input
- STDOUT - standard output
- STDERR - standard error

These map in order to file descriptors: 0, 1, 2.

Let's have a look at a very basic program that uses both output streams:

```c++
#include <iostream>

int main()
{
	std::cout << "info message\n";
	std::cerr << "error message\n";
}
```

When run in terminal, there is no visible difference:

~~~
$ ./program
info message
error message
~~~

This is because terminals on all major OSes combine standard output and error.

We can redirect program's output, but only standard output is redirected by default:

~~~
$ ./program > file.txt
error message
$ cat file.txt
info message
~~~

You can see that even though program's output was redirected to a file it still printed an error. The file contains only the standard output.

Error stream must be redirected explicitly:

~~~
$ ./program > file.txt 2>&1
$ cat file.txt
info message
error message
~~~
