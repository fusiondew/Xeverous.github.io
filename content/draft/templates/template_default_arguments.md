# template default arguments

Similarly to ordinary functions, you can also define default arguments for templates.

```c++
void func(int i = 0); // default function argument

template <typename T = int> // default template argument
void func(T t);
```

The rules are the same - defaulted arguments must be the last arguments (you can't write `(int x = 0, int y)`).

However, one additional trick is allowed. You can default argument to depend on some of previous arguments.

```c++
void func(int x, int y = x); // this is not allowed - a concrete value for y must be used

template <typename T, typename U = T> // this is allowed for templates; func<T> is the same as func<T, T>
void func(T t, U u); 
```

Default template arguments have lower priority than deduction. This means that in the case of `func(3, 3.5)` `T = int, U = double` are deduced, regardless of default types. This sounds like default template arguments for functions do not bring much functionality (in fact default template arguments for classes are used more often) but if we avoid deduction it can be helpful:

```c++
// This math function does some complex computations. Default arguments affect accuracy of results.
// By defalt result has the same type as arguments. U and R can be changed fot better accuracy but potentially lower performance
template <typename T, typename U = T, typename R = T>
R some_math_func(T x, T y)
{
	U intermediate_result = (x + y) * (y - x);
	U something = x * U(3.14); // will be x * 3 if T = int
	
	// ... more math
	
	Result r = ...
	return r;
}
```

The function above takes 2 values of type `T` but has 2 additional template types which are used only inside. Because there are no arguments for `U` and `R`, they are deduced to be the same as `T` when not explicitly written. `some_math_func(5, 10)` will be instantiated with `T = int, U = int, R = int`. `some_math_func<int, double, double>(5, 10)` will use floating-point maths and return different (more precise results).

TODO - find better example

