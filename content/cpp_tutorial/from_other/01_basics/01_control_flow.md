---
layout: article
---

## jumps

Classical ever-hated goto. Very strongly discouraged. C++ forbids it in few contexts.

```c++
	code();
label:
	code();
	if (x)
		goto label;
```

## conditions - switch

Due to backwards compatibility switch in C++ has few restrictions:

- cases can only test equality
- cases match only for constant expressions

Cases fallthrough by default. Use breaks to stop it.

```c++
switch (x)
{
case 1:
	// ...
	break;
case 2:
	// ...
	// fallthrough, may generate a warning
case 3:
	// ...
	break;
default:
	// ...
	break;
}
```

Braces are required if cases enter variable's scope ommiting initialization.

```c++
switch (x)
{
    case 1:
        int x = 0; // initialization
        std::cout << x << '\n';
        break;
    default:
        // compilation error: jump to default would enter the scope of 'x'
        // without initializing it
        std::cout << "default\n";
        break;
}
```

## conditions - if

Braces not required for 1-statement bodies.

```c++
if (condition)
	statement();
else
	statement();
```

Chaining is possible which relies on the lack of brace requirement.

```c++
if (cond1)
	statement();
else if (cond2) // no else { if ... } required
	statement();
else if (cond2)
	statement();
else
	statement();
```

Since C++17 you can put an initialization statement before checking. This can be useful to create an object only for if-else scope.

```c++
if (std::string str = func(); str.empty()) {
	statement();
}
else {
	statement(); // str also lives here
}
// but not here
```

This is also possible for switches.

## while

As with others, braces not required.

```c++
while (condition)
	statement();

while (init; condition) // C++20
	statement();
```

```c++
do
	statement();
while (condition); // <-- people forget this semicolon
```

## for

Classical one:

```c++
// no difference between ++i and i++ but prefer prefix one -
// it does not output old copy and some iterators only support prefix increment
for (int i = 0; i < arr.size(); ++i)
	// use arr[i]
```

Iterator loops:

```c++
for (auto it = ds.begin(); it != ds.end(); ++it)
	// use  it to access iterator
	// use *it to access element

// more on iterators in STL chapter
```

For-each loops:

```c++
std::vector<T> v;
// copy each element - modifications in the loop will not have visible effects
for (T obj : v)
// read-only reference - use for large objects to avoid costly copies
for (const T& obj : v)
// use for large objects when modification is intended
for (T& obj : v)
// use for moving resources
for (T&& obj : v)

// more on references in type system chapter
```