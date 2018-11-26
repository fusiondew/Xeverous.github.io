---
layout: article
---

### using lambdas

You might wonder what are the uses of lambdas. Where a lambda would be needed or a good solution to something.

The best examples are standard algorithms. Most of them take iterators and an optional functor to do the comparison. The functor is the most important part here - algorithm logic is already written, the functor is just used to do the core step such as telling whether `a > b` or `x` satisfies certain criteria.

Have a look at one of the most basic algorithms:

```c++
template <typename InputIt, typename T>
InputIt std::find(InputIt first, InputIt last, const T& value);
```

The algorithm is pretty obvious - it takes a range to search in and the value to search for. Iterator is returned: `last` if the element was not found or something in range `[first, last)` if the element was found.

But, what if we would like to do something different? Like searcing for a certain string, but not it's value, but some other property - for example length.

Suppose we have a vector of strings:

```c++
std::vector<std::string> v = { /* ... */ };
```

and we would like to find a string that has length of 1. We can not input `"?"` or something similar as it would search for exactly that string.

The answer is to use a lambda - there is `find_if` that acceps functors instead of values:

```c++
template <typename InputIt, typename UnaryPredicate>
InputIt std::find_if(InputIt first, InputIt last, UnaryPredicate p);
```

`UnaryPredicate` is a conventional name expressing 2 things:

- unary - takes 1 argument
- predicate - performs a check (on this argument), returns `bool` if succeded

The predicate is used inside the algorithm to check whether given value is the one user is searching for. We do not need to know the implementation of the algorithm - only tell it how it should know it has found expected element.