---
layout: article
---

You might already encounter the term "lambda", "lambda expression" or "closure". What does it mean? The shortest explanation is that it is unnamed (anonymous) function or function object.

Just like it's possible to create an unnamed object:

```c++
std::string str = "something"; // named object (str)
some_func_which_takes_string(std::string("foo") + "bar"); // unnamed string - just the constructor call
```

or unnamed class:

```c++
class
{
    // ...
} object_name;
```

it's also possible to create an unnamed function:

```c++
// ordinary function
int func(int x)
{
    return x * x + x;
}
// anonymous function - lambda expression
[](int x) -> int
{
    return x * x + x;
}
```

As you see, the lambda has no name. There is no "func". Instead, there is a pair of brackets: `[]`. It has nothing to do with arrays - it's just reused symbol. Just like `class` keyword has been reused to create strongly typed enumerations, `[]` characters have been reused to create lambda expressions. Some programming languages have `lambda` keyword - C++ has the philosophy of not adding new keywords if something existing can be reused (backwards compability) - this time the bracket syntax has been given a new purpose. Since `[]` alone would not make sense earlier, the addition of lambda expressions did not break anything - previously it was invalid code.

Now some terms:

```c++
   [](int x) -> int
// ^^               captures
//   ^^^^^^^        parameters
//           ^^^^^^ return type
```

Paremeters and return type should be obvious - they work just like with ordinary funcions. There is just a different order - return type is specified **after** parameters with `-> Type` syntax.

`[]` has more purposes besides just starting a lambda expression. Between brackets, **captures** can placed - and this is the very unique feature of lambdas.

On captures and more special use of `[]` there will in a while. First, I will explain more things about the syntax.

## trailing return type

C++11 has introduced lambda expressions. Part of their syntax relies upon the *trailing return type* (also introduced in 2011). Interestingly, this feature can also be used for ordinary functions:

```c++
int func1(int x) // leading return type
{
    return x * x + x;
}

auto func2(int x) -> int // C++11 trailing return type
{
    return x * x + x;
}
```

`auto` in this case expresses "hold on, the actual return type is later, after parameters". `func2` is still a normal function. This is just the different way to write it.

You even write `int main()` as `auto main() -> int`. Open your tools and try!

#### Question: What's the point of trailing return type?

At first, it's not obvious what's the purpose of this new syntax. More code has to be written to express the same - but - there is some use for this feature. And this use comes from the fact that return type is specified *after* parameters. There are some "tricks" to make smart use of parameters in the return type - unfortunately I won't show them now as they make only a good use in templates and templates are far away from the scope of this article.

As for now, just trust that trailing return type has some use, but only in more advanced scenarios.

## comparison

Coming back to the example, we can compare lambda with 2 possible ways to write an ordinary function:

```c++
int  func1(int x)        // function with leading return type
auto func2(int x) -> int // function with trailing return type
        [](int x) -> int // lambda expression
```

Now you should notice lambda looks very similar to the function with trailing return type. It just doesn't have a name (has `[]` instead) and does not need `auto` to express trailing return type.

**Lambdas use only trailing return type. They can not specify return type before parameters.**

### using lambdas

Enough explanation. Time to use a lambda. But how do we call it? It has no name.

There are 2 options:

- save lambda to a variable (just like temporary string can be stored in `str`), and use that variable
- put the lambda to a function, it will be taken as a parameter, which has a name inside the function

The second option requires more knowledge. *How to pass a lambda as an argument?* The short answer is: templates. There will be examples which present use of some standard library functions which can take lambdas, but (just now) there won't be examples presenting how to write a such function.

For now, let's state that standard library has some *template magic*. And this *magic* is capable of taking lambdas as parameters. We do not need to explain it now, just remember that *there is a way* to do it.

So we are left with the first option. Save lambda to a variable.

```c++
??? my_lambda = [](int x) -> int
{
    return x * x + x;
}; // note the semicolon - lambda is [](){}, but ; comes from usual assignment expression
```

But wait, what's the type of lambda? There is no `std::lambda`. You might try with function pointers and have some luck with it, but most of the time they will not work. More about "function pointers to lambdas" later.

So what's the answer? We just don't care - use `auto`. Let the compiler do the work.

**Every lambda expression has it's own unique type. Even 2 lambas with exactly the same parameters, return type and body are treated as 2 distinct types.**

This makes `auto` the only always-valid option which does not use template magic. Function pointers may be sometimes used, but you will see in further lessons that they are very limited.

You can think of lambdas as objects of unnamed classes that overload `operator()`.

## exercise

Play with the example. Call a lambda few times and get used to it's syntax

```c++
#include <iostream>

int main()
{
    auto my_lambda = [](int x) -> int
    {
        return x * x + x;
    };

    for (int i = 0; i < 5; ++i)
        std::cout << my_lambda(i) << '\n';

    std::cout << my_lambda(10) << '\n';
    std::cout << my_lambda(15) << '\n';
    std::cout << my_lambda(100) << '\n';

    // this is also possible - note () after the body
    // these lambdas are invoked instantly after creation
    const double d = []() -> double { return 3.14; }();
    std::cout << [](int x) -> int { return x * x; }(5) << '\n';
}
```
#### Question: Can I copy/move a lambda?

It has been allowed in C++20 but with many restrictions. They depend on the capture. More about it - later.

#### Question: What's the difference between lambda expression and a struct with overloaded `operator()`?

In the examples so far - pretty much nothing besides deeper terminology. But in the next article, we will start using lambda features which are not available for overloaded `operator()`.

Technically, lambda expression creates a unique class satisfying `ClosureType` concept.

<details>
    <summary>Full technicals</summary>
    <p>The lambda expression is a prvalue expression of unique unnamed non-union non-aggregate class type, known as closure type, which is declared (for the purposes of ADL) in the smallest block scope, class scope, or namespace scope that contains the lambda expression.
    </p>
</details>

#### Question: Where can not I use lambdas?

*Lambda-expressions are not allowed in unevaluated expressions, template arguments, alias declarations, typedef declarations, and anywhere in a function (or function template) declaration except the function body and the function's default arguments.*

As of C++20 the above statement is no longer true.
