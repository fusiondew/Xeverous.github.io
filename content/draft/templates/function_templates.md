# Function templates

Suppose you have a simple function

```c++
int min(int x, int y)
{
	if (y < x)
		return y;
	else
		return x;
}
```

It is very simple but it will be used to showcase arbitrary type abstractions.

Now suppose you want to have a very similar function, but for strings:

```c++
const std::string& min(const std::string& x, const std::string& y)
{
	if (y < x)
		return y;
	else
		return x;
}
```

The code is almost identical, only **types** have changed. It would be very nice to have a way to abstract it. No one likes writing boilerplate, repetitive code. And then patching all of them.

To make a function template, there are 2 basic steps:

1. replace every occurence of the **type name** with an alias (here: `T`)
2. add `template` and name of the alias

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

This is exactly what [`std::min`](http://en.cppreference.com/w/cpp/algorithm/min) is doing.

**Note 1**

In this context, both `typename` and `class` can be used. Even with `class` the abstracted type does not have to be a class. There is no difference, but to avoid ambiguity I use `typename` everywhere. There is one exception to this rule (in templates of templates only `class` works) but it was fixed in C++17 so as of now there is no difference.

**Note 2**

It's very common to see `const T&` or `T&&` in templates since types are unknown and it's better to not copy heavy objects. Some types may not even be copyable.

**Note 3**

The alias `T` (with `U`, `V`, etc for next aliased types) is a very strong convention across whole C++ when aliasing any arbitrary type. I don't know exact origin of `T` but I'm sure it's either from "template" or "Type". If it's possible, it's good to express what type template is expecting by using a more conrete PascalCase name.

Example:

```c++
template <typename Iterator, typename UnaryFunc>
UnaryFunc some_algorithm(Iterator first, Iterator last, UnaryFunc&& f)
{
	for (; first != last; ++first)
		f(*first);
	
	return std::move(f);
}
```
In this case a potential user of this function is informed that algorithm expects a pair of iterators and a 1-argument function. More common aliases and conventions will be presented later.

**Note 4**

Templated functions, like any ordinary function can still be declared and defined later. Template aliases are also a part of function signature. Remember to place both in header file.

```c++
// inside class definition
template <typename T>
void func(const T&);

// somewhere below (still in header file)
template <typename T>
void MyClass::func(const T& obj)
{
	obj.foo();
}
```

# Using function templates

You can use them as any arbitrary type function (like in loosely typed languages).

```c++
int min_val = min(5, 10); // T automatically deduced to be int
```

But what happens when types does not match? In example above, `min()` has only 1 alias so both types need to be the same.

```c++
int min_val = min(5, 'a'); // compile-time error: 1st argument has type int, but 2nd has type char
```

You can force certain type by explicity writing it:

```c++
int min_val = min<int>(5, 'a'); // 'a' will be converted to int
```

Templates will not work if the supplied type does not support used operators and instructions:

```c++
struct Player
{
	std::string name;
	int life;
	int mana;
};

Player p1{"Mage", 100, 50}, p2{"Warrior", 150, 20};

const Player& p_min = min(p1, p2); // error inside min instantiated with T = Player: no defined operator <
```

You can extend template function possible usage by defining `operator<` for type `Player`:

```c++
const Player& operator<(const Player& lhs, const Player& rhs)
{
	if (rhs.life < lhs.life)
		return rhs;
	else
		return lhs;
}
```

This way `min<Player>` will work and compare players by their life.
