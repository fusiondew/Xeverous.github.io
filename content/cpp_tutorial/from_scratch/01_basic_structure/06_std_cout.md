---
layout: article
---

```c++
	std::cout << "hello, world";
```

Every C++ standard library function, class, etc is inside `std` namespace. Namespaces are a sort of directory trees but for code and `::` is used to denote levels instead of `/` in file paths. More about namespaces later - for now just remember that the standard library stuff is inside `std`.

`std::cout` is a globally accessible object of type `std::ostream` (**o**utput **stream**). It represents underlying system's **c**haracter **out**put.

There is also `std::cin` and `std::cerr` which represent **c**haracter **in**put and **c**haracter **err**or stream.

<details>
<summary>relation to operating system</summary>
<p>

*Don't worry if you don't understand OS streams - this is only for informational purpose, it's more of operating system theory rather than programming.*

If you are using an Unix system (MacOS, Linux, Android, BSD and other), these 3 map directly to stdin, stdout and stderr ([file descriptors](https://en.wikipedia.org/wiki/File_descriptor), in order: 0, 1 ,2). If you are using Windows system, `std::cerr` and `std::cout` have some distinction but it's more complicated.

**shell stream manipulation**

Programs using different standard output streams will print to the screen the same way, but their content can be split by stream redirection - see [this SO question](https://stackoverflow.com/questions/818255/in-the-shell-what-does-21-mean). Eg by adding `1>/dev/null` you will see only error prints.</p>
</details>

`<<` is an operator that is used by streams to output data. I don't want to explain all internals of this now as there are used many advanced language features which are yet to be explained later. For now, just assume there is some underlying magic which allows it to understand various data types and convert them to characters and output them to the screen.

`<<` can output vary many different data types (so far seen numbers and character sequenes) but more data types will be shown in a couple of lessons. If you get an error like `no match for 'operator<<' (operand types are 'std::ostream' ...` this means you have hit a data type that has no defined output. It is possible to define it, but that obviously requires you to understand many language features first.

### chaining

One of the useful features of some operators is that they often can be chained one after another. `<<` can be chained like `+` in math expressions.

```c++
#include <iostream>
 
int main()
{
	std::cout << "hello" << ", " << "world";
	return 0;
}
```

The program above prints the same text but uses `<<` operator multiple times.

Example using different data types:

```c++
#include <iostream>
 
int main()
{
	int x = 7;
	std::cout << "hello, world\n" << "x = " << x;
	return 0;
}
```

The above program prints

```
hello, world
x = 7
```

When chaining operators, watch out for typical syntax mistakes:

- double operator: `std::cout << << "text;"`
- unwanted semicolon: `std::cout << "text"; << "text";`
- operator with no operand: `std::cout << "text" <<;`
- wrong operator: `std::cout >> "text";`

### escape sequences

One noticeable thing in the example above is `\n`. This encodes a newline. Without it, the output would be:

```
hello, worldx = 7
```

Character `\` is an escape character. This means that the next character after it has a different meaning. Escaped `n` forms a line break instead of regular `n`.

Most important escape characters:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>sequence</th>
                <th>description</th>
            </tr>
            <tr>
                <td>\'</td>
                <td>single quote</td>
            </tr>
            <tr>
                <td>\"</td>
                <td>double quote</td>
            </tr>
            <tr>
                <td>\\</td>
                <td>backslash</td>
            </tr>
            <tr>
                <td>\n</td>
                <td>line break</td>
            </tr>
            <tr>
                <td>\t</td>
                <td>tab character</td>
            </tr>
            <tr>
                <td>\0</td>
                <td>null-terminator</td>
            </tr>
        </tbody>
    </table>
</div>

[more escape sequences](http://en.cppreference.com/w/cpp/language/escape) are described on the reference website.

`/` does not need to be escaped and behaves normally.

Null-terminator character is not visible, but it has important uses.

<div class="note info">
#### endl
<i class="fas fa-info-circle"></i>
You might have see examples on other sites that use `std::endl` instead of `\n`. This is almost always used incorrectly, because `std::endl` does not only output line break but also explicitly flushes the buffer, which is hardly ever needed. Don't use it unless you know exactly what that means and you have a reason to do the flush.
</div>

Example

```c++
#include <iostream>
 
int main()
{
	std::cout << "quotes: \" \'\n" << "backslash: \\\n" << "some\tspaced\ttext";
	return 0;
}
```

<details>
<summary>output</summary>
<p markdown="block">

~~~
quotes: " '
backslash: \
some	spaced	text
~~~

</p>
</details>

### exercise

Test escape characters if you have any dobuts. If you know how to handle system shell, you can also experiment with stream redirection.
