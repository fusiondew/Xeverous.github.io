---
layout: article
---

## C++ FAQ

### language

#### Why "this" is a pointer, not a reference?

Because `this` was introduced before references have been added to the language. If references came earlier, `this` would be a reference. Relevant [SO question](https://stackoverflow.com/questions/645994/why-this-is-a-pointer-and-not-a-reference).

### Templates

#### What are the differences between C++ templates and Java/C# generics?

Read this [SO question](https://stackoverflow.com/questions/31693/what-are-the-differences-between-generics-in-c-sharp-and-java-and-templates-i).

#### `template <typename T>` or `template <class T>`?

There is no difference except 1 corner case which was addressed in C++17. Prior to this, `typename` and `class` keywords could be used interchargebly, with the exception of *template template parameters* in which `class` had to be used. Since C++17 both are valid everywhere.

Historically, the keyword `class` was used first in templates to indicate aliased type. It's a common practice in C and C++ to reuse existing keywords for new contexts to avoid creating new ones that could invalidate existing code. Eventually new keyword was created for templates - `typename` (resembling existing `typedef`) to avoid confusion about `class` (template types do not have to be classes, they can also be trivial built-in types). Funny is that `typename` keyword has been overloaded later anyway, so now both keywords are multi-purpose and have different meanings depending on the context.

Some may use a convention that `typename` aliases any type (for example an array holding objects of any type) and `class` is supposed to be instantiated only on types that match specific criteria (eg concept of an iterator). Some will write `class` because it's shorter. Some will choose the convention to choose one keyword and stick to it for consistency.

There is also a very rare case when unit testing of protected/private inherited classes uses the hack `#define class struct`, `#define protected public`, `#define private public` - it explodes on `template <class>`. You should not be unit testing implementation details though. 

I use the designated keyword `typename` everywhere for consistency and to avoid any confusion.

#### Why `T` in templates?

I don't know the exact reason, but I predict it started either from the word "type" or "template". This is one of the very few places where C++ uses PascalCase. In generic contexts where more aliases are needed next alphabet letetrs are used.

In case of more adanced templates and concepts, longer and more descriptive names are used sush as `RandomAccessIterator` and `TriviallyConstructible`.

### other

#### Can I submit my own idea for C++?

Yes, check [how to submit a proposal](https://isocpp.org/std/submit-a-proposal). In case of problems ask on [/r/cpp](reddit.com/r/cpp).