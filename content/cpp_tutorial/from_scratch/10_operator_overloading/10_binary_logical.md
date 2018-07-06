---
layout: article
---

Operators `&&`, `||` and `,` are hardly ever overloaded.

The first 2 doesn't signal any concrete behaviour - what would be the purpose of `a && b` when they are not boolean?

Overloading comma only asks for more problems - imagine passing arguments to function: `f(a, b)` suddenly becomes `f(operator,(a, b))`.

#### Question: Are there any places in which these operators are overloaded?

Yes. C++ is a fun language where even the most obscure "features" will be found by someone to be usable.

Operator `,` is overloaded in [Boost Assign](http://www.boost.org/doc/libs/release/libs/assign/doc/index.html#intro) to extend interface of STL containers. This library is somewhat old (pre modern C++ standards), since C++11 there are much better (and less confusing) ways to do things what the library provides.

A true mastery of extraordinary operator overloads is achieved in Boost Spirit. [This short article](https://en.wikipedia.org/wiki/Spirit_Parser_Framework) gives an overview of the library purpose - templated overloaded operators are used to form grammar specification allowing to parse and lex various texts. This sort of solution is known as DSL (domain specific language) where a different language happens to be inside another.
