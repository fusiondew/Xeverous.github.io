---
layout: article
---

# class templates

There isn't much difference between abstracting type in function and a class, so I move instantly to examples.

Generic class that will hold 2 values of the same type:

```c++
template <typename T>
struct Pair
{
	T fisrt;
	T second;
	
	// some methods
	bool areEqual() const;
};
```

Any members of class template "inherit" the template signature. This means that following code is invalid:

```c++
bool Pair::areEqual() const
{
	return first == second;
}
```

The problem in the code above is that `Pair` does not name a concrete type. An error is returned because we try to write a function for something that is not a complete type.

```c++
main.cpp:22:6: error: 'template<class T> struct Pair' used without template parameters
 bool Pair::areEqual() const
      ^~~~
```

The correct syntax is to add missing template signature

```c++
template <typename T>
bool Pair<T>::areEqual() const
{
	return first == second;
}
```

Because the function `areEqual()` is inside the templated class, it is not `Pair::areEqual()` but `Pair<T>::areEqual()`. The function is not templated, but it is a member of template class, and so it needs to know that `first` and `second` are of type `T`.

### nested template classes

Things get little trickier when nested classes are used.

```c++
template <typename T>
struct Pair
{
	T first;
	T second;
	
	template <typename U>
	struct Inner
	{
	    U third;
	    
	    bool isDefault() const;
	};
	
	bool areEqual() const;
};
```

This is how to write a definition for a nested member:

```c++
template <typename T>
template <typename U>
bool Pair<T>::Inner<U>::isDefault() const
{
    return third == U();
}
```

1-line `template <typename T, typename U>` is incorrect because it would express that `Pair` has 2 template parameters. We place a separate template signature for each nested type.

### function templates inside template classes

The same thing applies here. For this pair class definition:

```c++
template <typename T>
struct Pair
{
	T first;
	T second;
	
	template <typename U>
	struct Inner
	{
	    U third;
	    
	    bool isDefault() const;
	    
	    template <typename V>
	    bool isEqualTo(const V& v) const;
	};
	
	bool areEqual() const;
};
```

The definition for nested function template is as follows:

```c++
template <typename T>
template <typename U>
template <typename V>
bool Pair<T>::Inner<U>::isEqualTo(const V& v) const
{
    return third == v;
}
```

So in short, write a separate template signature for each level of template depth.

### fully specializing nested templates

Related SO questions:

- https://stackoverflow.com/questions/6301966/c-nested-template-classes-error-explicit-specialization-in-non-namespace-sco
- https://stackoverflow.com/questions/2537716/why-is-partial-specialziation-of-a-nested-class-template-allowed-while-complete

There are some restrictions. To avoid mindfuck, I will post specialization examples for this:

```c++
template <typename T>
class A
{
    template <typename U>
    class B {};
};
```

1. Allowed - full inner specialization of full outer specialization

```c++
template <>
template <>
class A<int>::B<int> {};
```

2. Allowed - inner template of fully specialized outer

```c++
template <>
template <typename T>
class A<int>::B<T> {};
```

3. Not allowed - full inner specialization of templated outer

```c++
template <typename T>
template <>
class A<T>::B<int> {};
```

### partially specializing nested templates

```c++
template <typename T, typename = void>
class A
{
    template <typename U, typename = void>
    class B {};
};
```




