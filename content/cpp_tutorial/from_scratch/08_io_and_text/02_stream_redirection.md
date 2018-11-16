---
layout: article
---

## using different streams

<div class="note info">
Section below presents system-specific behaviour. Examples assume generic unix system terminal and not all things are possible or done the same way on other systems (especially Windows).

You can do all of this on Windows if you have [Git Bash](https://git-scm.com/downloads). It is an almost complete unix shell for Windows that has lots of fancy tools (`git`, `grep`, `find`, `awk`, `sed` and more) and can also run Bash scripts.
</div>

Operating systems offer 2 output streams and 1 input stream:

- STDIN - standard input
- STDOUT - standard output
- STDERR - standard error

In unix, these map directly to file descriptors: 0, 1, 2 - unix systems assign identification numbers for each opened "file". Since these streams are somewhat special files and are always opened they have fixed IDs.

## redirecting output

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

Error stream must be redirected explicitly. Here we redirect error stream to standard output stream and then both to a file:

~~~
$ ./program > file.txt 2>&1
$ cat file.txt
info message
error message
~~~

We can redirect specific streams. Here we redirect to null device to ignore any content:

~~~
$ ./program 2>/dev/null
info message
$ ./program 1>/dev/null
error message
~~~

Note: spaces must not be present, otherwise `2 > /dev/null` ends up as program arguments.

## redirecting input

This can be used to automate testing of input-oriented programs, especially for tasks given in universities (they tend to require manual input instead of file reading). All `std::cin`s are automatically filled.

~~~
$ ./program < input.txt
~~~

Upon reaching end of file, the stream will receive EOF (end of file) character and go failure state.

Most console terminals also allow to paste to the console while the program is running.
