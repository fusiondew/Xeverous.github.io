---
layout: article
---

# Function templates

## Writing funtion templates

*Prerequisities: knowledge of references*

Suppose you have a min function:

```c++
int min(int x, int y)
{
	if (y < x)
		return y;
	else
		return x;
}
```

It is very simple but it will be used to showcase powerful type abstractions.

Now suppose you want to have a very similar function, but for doubles and strings:

```c++
double min(double x, double y)
{
	if (y < x)
		return y;
	else
		return x;
}

const std::string& min(const std::string& x, const std::string& y)
{
	if (y < x)
		return y;
	else
		return x;
}
```

You can easily overload it, but you notice that the code is almost identical, only **types** have changed. It would be very nice to have a way to abstract it. 

To make function a function template, there are 2 simple steps:

1. add `template` signature with the name of the used alias (here `T`)
2. replace every occurence of the **type name** with the alias

```c++
template <typename T>
const T& min(const T& x, const T& y)
{
	if (y < x)
		return y;
	else
		return x;
}
```
Suddenly we get something very similar to [`std::min`](http://en.cppreference.com/w/cpp/algorithm/min).


**Why "T"?**

The name of the alias doesn't really matter, but it is a very strong convention to use T and consecutive alphabet letters (U, V, W, ...) for arbitrary type aliases. It probably originated from words "type" or "template".

Template type aliases are PascalCase, not UPPERCASE. We just have a 1-letter name here. Later, in more advanced scenarios, longer, more descriptive alias names will be used such as `UnaryPredicate` or `RandomAccessIterator` to indicate the template is for certain kind of types. Since the min function can work with anything (that supports `operator<`) we use `T`. Eventually, `LessThanComparable` could be used.

The exact meaning and conventions of all longer names (with their list) will be presented later. For now, `T` is enough.


**What is "typename"?**

This keyword simply indicates we alias a type. There are non-type templates too. It's just the syntax.

Sometimes you might see `class` keyword used. In terms of template signatures (things inside `<>`), both `typename` and `class` can be used interchangeably except 1 corner case which was a small bug in the standard (fixed with C++17).

I use `typename` because it sounds more appropriate and doesn't confuse the reader (`T` does not have to be a class).

More about the corner case in FAQ.

**Note about references**

It's common to see various types of references in templates since types are unknown and it's better to not copy heavy objects. Some types may not even be copyable. More details about references will be explained later, for now you can const reference everything.

## Using function templates

You can use function templates just like ordinary functions.

Function templates upon usage, automatically deduce what `T` should be:

```c++
int min_val = min(5, 10); // T automatically deduced to be int
```

At this moment, compiler generates the body of the actual function.

But what happens when variables are of different types?

```c++
int min_val = min(5, 'a');
```
```c++
main.cpp: In function 'int main()':
main.cpp:14:29: error: no matching function for call to 'min(int, char)'
     int min_val = min(5, 'a');
                             ^
main.cpp:4:10: note: candidate: template<class T> const T& min(const T&, const T&)
 const T& min(const T& x, const T& y)
          ^~~
main.cpp:4:10: note:   template argument deduction/substitution failed:
main.cpp:14:29: note:   deduced conflicting types for parameter 'const T' ('int' and 'char')
     int min_val = min(5, 'a');
                             ^
```

The deduction failed because `5` has type `int` but `'a'` has type `char`. It could not be dediced what `T` should be.

The obvious solution you may come up with is to use convertions (`static_cast<int>('a')`) but - there is a better way - we can explicitly state what we want `T` to be:

```c++
int min_val = min<int>(5, 'a'); // no deduction, we force T to be int
```
Note that the function `const int& min(const int&, const int&)` is formed first, then arguments are feed into it.

The act of forming a function (using a template with certain alias - deduced or explicitly stated) is called **template instantiation**. We can say we have instantiated `min()` with `T = int`.

Other examples that will fail to instantiate:

```c++
min(2, 3u)   // int, unsigned int
min(3.0, 4l) // double, long int
min(0, 0.0f) // int, float
```

Example that will successfully instantiate:

```c++
min<char>(35.49l, 7u); // both long double and unsigned int will be converted to char
// the resulting character will have value 7, which is one of the control characters in ASCII (bell in this case) 
```

## Exercises

Write a simple function template, eg `max()` and test it with various types. Go to the next lesson if you encounter too many problems with instatiation. There are still few things to explain.
