---
layout: article
---

Like with output, C++ offers both formatted and unformatted input.

## parsing data

Any stream when using formatted input (not just `std::cin`) will greedily accept any characters as long as they match. Upon encountering an invalid character, reading stops and it is left in the buffer for future operations.

If the stream encounters an invalid character at the start or the parsing failed (for whatever reason) the stream goes to **specific** failure state.

## examples form rationale

For testability and easier way of running examples I used string streams with fabricated input instead of `std::cin` which reads from system's standard input interface (keyboard on console terminals).

If you would like to experiment by manually writing text or using shell redirection just replace string streams with `std::cin`.

## chained reading example

```c++
#include <iostream>
#include <sstream> // for std::stringstream

int main()
{
	int n;
	char c;
	double d;
	// like with output streams, operators are run from left to right
	std::stringstream("1234 a 12.34") >> n >> c >> d;
	std::cout << "n = " << n << "\nc = " << c << "\nd = " << d;
}
```

~~~
n = 1234
c = a
d = 12.34
~~~

## dealing with invalid input

There is no doubt that sooner or later you or other users will submit invalid input.

In case of behaviour on invalid input C++ can be really unintuitive so I recommend to pay attention to details here as otherwise validating input can be very surprising.

## stream state

Each stream object has a state.

After an unsuccessful I/O operation, stream goes to **specific** failure state and ignores all future operations until explicitly reset.

Failure is usually triggered by:

- invalid input data (eg expected digits but got letters when reading an integer)
- reaching end of input (file end or EOF command in terminals)
- insufficient priviledges (eg when opening a file)

Possible failure flags:

**failbit**

This will be the most common error. Formatting or parsing error (usually invalid characters).

**eofbit**

**E**nd **o**f **f**ile reached. This can also happen outside reading files. This is just a generic marker that the input device has closed.

Most console terminals allow to send EOF through a shortcut:

- any Unix console terminal: ctrl+D (does not work in Git Bash on Windows)
- Windows cmd: ctrl+Z
- Windows Power Shell: ctrl+Z

**badbit**

Irrecoverable error happened.

TODO important block

Failure flags are independent which makes it important to check the appropriate one.

Mistakes in state cheking can result in surprising behaviour, for example:

- closing entire program just because one input failed
- stucking in an endless failed reading loop after reaching end of file

## checking state

```c++
// all 4 functions return bool

if (std::cin.fail()) // check if parsing failed
if (std::cin.eof())  // check if end of file has been reached
if (std::cin.bad())  // check if unrecoverable error occured

if (std::cin.good()) // check if no errors exist (none of 3 error bits are set)
if (std::cin)        // as above (this code uses hidden feature, explained later)
if (std::cin >> x)   // first read to x, then check if no errors (using same feature)
```

## any formatted/unformatted reading

Requires that **eofbit** is not set. Otherwise there is nothing left to read.

## reading integers

```c++
int n;
std::cin >> n;
```

-