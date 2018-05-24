# C++ templates tutorial

## [under construction]

Ever wondered how C++ templates work or how to use/write them? Then this is the right place you came to.

I have created this repository to provide easy to understand explanation and examples. While cppreference.com has complete documentation, there aren't that many examples and the webpage intends to have very technical-like language which can be hard to understand. Also it's a nice exercise for me to check if I learned everything correctly - contributions and amendments welcome!

Note - the following guide assumes you know C++ at some level - mostly OO stuff. If not - visit [this repository]()


language fundamentals
	- introduction to metaprogramming (keywords, inline and headers, declarations vs definitions, ODR)
	- value types: lvalue, rvalue, glvalue, xvalue, prvalue, (const) lvalue reference, (since C++11) (const) rvalue reference
	- implicit convertions, `std::decay`
	- `decltype` keyword
	- name lookup rules - qualified lookup, unqualified lookup, ADL
function templates
	- function templates
	- function template instances
	- function template specialization
	- overloading templated funcions
	- function templates with multiple parameters
	- template default arguments
class templates
	- class templates
	- class template full    specialization
	- class template partial specialization
	- inheritance and class templates
	- dependent names (`typename = typename T::type` and `T::template bar<typename U::type>()`), temploids (`typename`, `template` and `this->`)
	- Empty Base Optimization
	- class member templates
	- friends and virtual functions in class templates
other templates
	- (since C++11) alias templates (aka templated `typedef`)
	- (since C++14) variable templates
	- non-type templates
	- restrictions for non-type templates
	- template parameter type auto
	- templates for raw arrays and string literals
lambda expressions
	- leading and (since C++11) trailing return type
	- (since C++11) lambda expressions
	- (since C++11) mutable lambdas
	- (since C++14) generic lambda expressions
	- (since C++17) (generic) constexpr lambda expressions
	- (since C++20) templated lambda expressions
	- higher order functions
deduction
	- template deduction rules
	- explicit template deduction guides
	- policy classes
	- algorithm specialization, tag dispatching
compile-time evaluation
	- (since C++11) `constexpr` keyword
	- (since C++14) enhanced `constexpr`
	- (since C++11) `static_assert`
	- passing by value and reference
	- std::reference_wrapper - MOVE to lang tutoral
arcane theory
	- enum values vs static constants - MOVE to lang tutorial
	- (since C++14) `auto` function return type
	- (since C++14) `decltype(auto)`
	- (since C++17) structured bindings `auto [key, val] = get_pair();` - MOVE to tutorial
variadics
	- (since C++11) variadic templates, `sizeof...` operator
	- (since C++11) universal/forwarding reference
	- (since C++11) Perfect Forwarding (`std::forward<Args>(args)...`)
	- (since C++17) fold expressions (`std::cout << ... << args;`, `(std::is_same_v<T, Us> && ...)`)
CRTP
	- CRTP (example of static polymorphism), compile-time downcasting
	- CRTP inside CRTP
	- expression templates
type traits
	- standard library metafunctions
	- transforming types
	- specializations based on traits
	- (since C++17) `if constexpr`
SFINAE
	- SFINAE - introduction
	- SFINAE with (since C++11) `std::enable_if`
	- SFINAE with (since C++17) `std::void_t`
	- type traits based on SFINAE
	- TEMPLATES OF TEMPLATES
concepts
	- language concepts
	- usage of concepts
	- forming a concept
heavy wizardy
	- funcion objects - MOVE to lang tutorial
	- type erasure techniques
	- std::function, std::any
	- type lists
	- advanced pack expansion techniques
	- pairs and tuples

Examples and exercises
- containers (example implementation)
  - vector
  - single-linked list
  - simple smart pointer with unique ownership
- (?) boost::hana, boost::mpl (higher order metafunctions)
- discrete mathematics using SFINAE and `constexpr`
- type erasure (example implementation of `std::any`, `std::function`)
- implementing std::tuple
- implementing std::optional
- implementing std::variant
- implementing std::any
- lambda traits
- bit pattern scanner
- sample part of ET library
- lazy/delayed initialization

	
Cheatsheets
- operator overloading: unary, binary, ternary (eg 1-argument "-" (x = -x) vs 2-argument "-" (z = x - y) - what, where and when can be overloaded)
- value types
- temporary materialization
- implicit convertions
- template specialization, partial/full for nested classes/functions - what is where possible




TODO

make a cheatsheet what templates can be fully/partially specialized/overloaded etc.

make a cheatsheet about operator overloading

make a cheatsheet about value types

make a cheatsheet about implicit convertions 

https://www.reddit.com/r/cpp_questions/comments/7k9qs2/fiximprove_my_templated_signal_slot_implementation/

https://www.reddit.com/r/cpp_questions/comments/7ej93y/pattern_scanner_in_c_17/

https://stackoverflow.com/questions/19663640/syntax-for-specialization-of-nested-template-class

https://stackoverflow.com/questions/6301966/c-nested-template-classes-error-explicit-specialization-in-non-namespace-sco

https://stackoverflow.com/questions/2537716/why-is-partial-specialziation-of-a-nested-class-template-allowed-while-complete

https://stackoverflow.com/questions/34889583/default-template-arguments-when-using-template-template-parameters

http://blog.codeisc.com/2018/01/09/cpp-comma-operator-nice-usages.html

https://akrzemi1.wordpress.com/2017/12/02/your-own-type-predicate/

https://hackr.io/tutorials/learn-c-plus-plus?sort=upvotes&

stackoverflow.com/questions/6622452/alias-template-specialisation

-ffreestanding

Assert that compilation takes place in a freestanding environment. This implies '-fno-builtin'. A freestanding environment is one in which the standard library may not exist, and program startup may not necessarily be at main. The most obvious example is an OS kernel. This is equivalent to '-fno-hosted'.

STDC_HOSTED

- mml namespace (magic math library)

