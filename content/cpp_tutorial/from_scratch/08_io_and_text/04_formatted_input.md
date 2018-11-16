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

Irrecoverable error happened. Something so bad that you can't do much about it (eg out of memory). 

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

## reading

Generally you want to read only when the stream is in a good state. Formatted input functions do nothing if any of failure bits is set. If recent parsing failed and you would like to repeat the operation, clear flags: `std::cin.clear()`.

Note that since formatted input functions do not consume invalid characters, repeating the same input operation again will have the same effect.

### reading integers

```c++
#include <iostream>

int main()
{
	while (true)
	{
		int n; // also can be long/signed/unsigned etc
		std::cin >> n;
		
		if (std::cin.eof())
		{
			std::cout << "end of input reached\n";
			break;
		}

		if (std::cin.fail())
		{
			std::cout << "parsing failed\n";
			break;
		}
		else
		{
			std::cout << "entered: " << n << "\n";
		}
	}
}
```

Skips any whitespace, then extracts characters from the stream as long as they are digits. First character can be a minus sign.

Possible error outcomes:

- first character is not valid (not a whitespace, minus sign or digit)
  - 0 is written to the variable
  - **failbit** is set
- number is too large to fit in the given integer type
  - largest/smallest value possible is written to the variable
  - **failbit** is set

TODO when characters are consumed, when not.

Example inputs and outputs:

~~~
$ echo "1 2 3" | ./program
entered: 1
entered: 2
entered: 3
end of input reached
$ echo "1 2 a 3" | ./program
entered: 1
entered: 2
parsing failed
$ echo "1   2 -3	44" | ./program
entered: 1
entered: 2
entered: -3
entered: 44
end of input reached
$ echo "1 -2 3 -4 5434209798123741273 6 7" | ./program
entered: 1
entered: -2
entered: 3
entered: -4
parsing failed
~~~

### ignoring invalid inputs

In the previous program we exited on parsing failure - but what if we would like to continue and just ignore invalid inputs?

We can not just do

```c++
if (std::cin.fail())
	std::cin.clear();
```

and repeat the operation because it will have exactly the same result - inputs are consumed only if they are valid.

TODO describe ways to ignore input
