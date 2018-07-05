---
layout: article
---

## C++ FAQ

### language

#### Why "this" is a pointer, not a reference?

Because `this` was introduced before references have been added to the language. If references came earlier, `this` would be a reference. Relevant [SO question](https://stackoverflow.com/questions/645994/why-this-is-a-pointer-and-not-a-reference).

#### Is C faster than C++?

No. Correctly written code should be fast in both languages. Misused C usually ends in crashes, misused C++ features usually end in lower performance.

There are few things in C that are slower than their relatives in C++. This applies specifically to C standard library which does not have efficient generic abstractions besided macros - for example C functions taking void pointers are far worse optimized than C++ templates.

Even when developing high-performance programs, performance is not needed strictly everywhere. Where possible, convenience features can be used over performance features. It doesn't matter if text entered by the user is processed 10% slower, but it matters if the full product can be delivered several times faster (compared to C) with the same core performance.

From Bjarne Stroustrup FAQ:

> If nothing else, you can write the program in C style benefiting from C++'s stronger type checking and better notational support, but most programs can benefit from C++'s support for generic and object-oriented programming without compromising size or performance. Sticking to the C-like subset of C++ is most often counter-productive.

> Writing Java-style code in C++ can be as frustrating and sub-optimal as writing C-style code in C++.

> I never saw a project for which C was better than C++ for any reason but the lack of a good C++ compiler.

#### Is C++ a legacy language? It is old design?

From Bjarne Stroustrup FAQ:

> Naturally, calling C++ a legacy language shows a bias \[...\]. That aside, people are usually thinking of Java or C# when they ask such a question. I will not compare C++ to those languages, but I can point out that "modern" doesn't necessarily mean "better", and that both Java and C# are rooted in 1980s style OOP to an even greater extent than early C++ is.

> Since 1987 or so, the focus of development the C++ language and its associated programming styles have been the use of templates, static polymorphism, generic programming, and multiparadigm programming. This is way beyond the scope of the much-hyped proprietary languages. Another key difference is that C++ supports user-defined types to the same extent as built-in types. This - especially in combination with the use of templates, constructors, and destructors - enables the C++ programmer to use programming and design techniques that (IMO) are more advanced than what is supported in the languages with which C++ is most often compared

#### Is C++ an OOP language?

It belongs to the family of OO languages, but more accurately, C++ is a multi-paradigm language. It means if offers various styles of programming that can be mixed together.

C is mostly about imperative, structural programming. This style is still practiced (not only in C++) but almost always is augmented by other, unique features and mixed with different styles.

The whole STL is designed around generic programming - instead of implementing interfaces you specialize and instantiate templates.

See also cat-dog program written in various styles. TODO link.

#### What is STL?

Standard template library. Specifically, containers (data structures), iterators and algorithms. By far templates are the biggest part of C++ standard library (more than 90%). It's quite an effort to find classes that are not templates.

### Templates

#### What are the differences between C++ templates and Java/C# generics?

Read this [SO question](https://stackoverflow.com/questions/31693/what-are-the-differences-between-generics-in-c-sharp-and-java-and-templates-i).

#### What's the difference between `template <typename T>` and `template <class T>`?

There is no difference except 1 corner case which was addressed in C++17. Prior to this, `typename` and `class` keywords could be used interchargebly, with the exception of *template template parameters* in which `class` had to be used (small "typo" in the standard). Since C++17 both are officially valid everywhere, but major compilers accepted it much earlier.

Historically, the keyword `class` was used first in templates to indicate aliased type. It's a common practice in C and C++ to reuse existing keywords for new contexts to avoid creating new ones that could invalidate existing code. Eventually new keyword was created for templates - `typename` (resembling existing `typedef`) to avoid confusion about `class` (template types do not have to be classes, they can also be trivial built-in types). Funny is that `typename` keyword has been overloaded later anyway, so now both keywords are multi-purpose and have different meanings depending on the context.

Some may use a convention that `typename` aliases any type (for example an array holding objects of any type) and `class` is supposed to be instantiated only on types that match specific criteria (eg concept of an iterator). Some will write `class` because it's shorter. Some will choose the convention to choose one keyword and stick to it for consistency.

There is also a very rare case when unit testing of protected/private inherited classes uses the hack `#define class struct`, `#define protected public`, `#define private public` - it explodes on `template <class>`. You should not be unit testing implementation details though. 

I use the designated keyword `typename` everywhere for consistency and to avoid any confusion.

#### Why `T` in templates?

I don't know the exact reason, but I predict it started either from the word "type" or "template". This is one of the very few places where C++ uses PascalCase. In generic contexts where more aliases are needed next alphabet letetrs are used.

In case of more adanced templates and concepts, longer and more descriptive names are used sush as `RandomAccessIterator` and `TriviallyConstructible`.

### other

#### Who actually makes C++?

The ISO WG21 committee. Members include Bjarne Stroustrup (language creator) and programming experts from Google, Microsoft, Intel, IBM, Qualcomm, Qt, nVidia and other companies. Committee is open-ended and always says they would take more people - so far it's lacking game dev representatives.

The committee is divided into groups:

- Library Working Group
- Library Evolution Working Group
- Core Working Group
- Evolution Working Group
- Study Groups (more than 15, various topics: eg concurrency, low-latency, database, netorking)

Committee schema + images: https://isocpp.org/std/the-committee.

Feature list + image timeline: https://isocpp.org/std/status.

Committee organizes official meetings every few months and every 3 years issues new international standard.

#### Can I submit my own idea for C++?

Yes, check [how to submit a proposal](https://isocpp.org/std/submit-a-proposal). In case of problems ask on [/r/cpp](reddit.com/r/cpp).
