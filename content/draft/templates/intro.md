# Intro

### History

At the early stage of forming C++, templates were added as a very powerful tool to create generic code; they originated from Ada generics. Later, there have been multiple (often accidental) discoveries: C++ templates syntax is a standalone, turing-complete, purely functional language. As the time progressed, more features regarding templates where added and discovered (such as SFINAE).

Generic code offers high portability, extensibility and offers a very large code reuse. Corner cases can be handled by template specializations and idioms such as SFINAE.

[SO question](https://stackoverflow.com/questions/1039853/why-is-the-c-stl-is-so-heavily-based-on-templates-and-not-on-interfaces) regarding history and why templates were chosen over OO design for C++ standard library.

### Differences between C++ templates and Java, C# generics

Read this [SO question](https://stackoverflow.com/questions/31693/what-are-the-differences-between-generics-in-c-sharp-and-java-and-templates-i).

### Important note

C++ templates are a way of expressing generalized instructions. Templates alone can not be compiled, since they are only "code drafts" - exact types/values are unknown or incomplete. This means you have to put both template declarations and definitions in header files. Each time a template is used, it will be instantiated for the given situation. [Relevant SO question](https://stackoverflow.com/questions/495021/why-can-templates-only-be-implemented-in-the-header-file).

`template` implies `inline`

`constexpr` implies `inline`
`constexpr` implies `const` when used in a declaration

### FAQ

`template <typename T>` or `template <class T>`?

There is no difference except 1 corner case which was addressed in C++17. Prior to this, `typename` and `class` keywords could be used interchargebly, with the exception of *template template parameters* in which `class` had to be used. Since C++17 both are valid everywhere.

Historically, the keyword `class` was used first in templates to indicate aliased type. It's a common practice in C and C++ to reuse existing keywords for new contexts to avoid creating new ones that could invalidate existing code. Eventually new keyword was created for templates - `typename` (resembling existing `typedef`) to avoid confusion about `class` (template types do not have to be classes, they often can be trivial built-in types). Funny is that `typename` keyword has been overloaded later anyway, so now both keywords are multi-purpose and have different meanings depending on the context.

Some may use a convention that `typename` aliases any type (for example an array holding objects of any type) and `class` is supposed to be instantiated only on types that match specific criteria (eg concept of an iterator). Some will write `class` because it's shorter. Some will choose the convention to choose one keyword and stick to it for consistency.

There is also a very rare case when unit testing of protected/private inherited classes uses the hack `#define class struct`, `#define protected public`, `#define private public` - it explodes on `template<class>` 

I consistently use the designated keyword `typename` everywhere to avoid any confusion.

### Coding style

I put in great effort to offer as best examples as possible. Even just reading advanced C++ code can be hard. Wrongly placed spaces suggest different things and can even create different tokens during parsing  - I will always stick relevant operators to the type or the syntax of the used expression. This means you will see:

- 1 type name declaration per line
- `T* t`, NOT `T *t`
- `Args&&... args`, NOT `Args&& ...args`
- `Ts...`, NOT `Ts ...`
- `const T& t`, NOT `const T &t`
- `args && ...` (as fold expression), NOT `args&&...`, NOT `args &&...`
- lots of `auto` to simplify long type names; however many will be explained in comments so you are sure it's `std::unordered_map<std::string, std::vector<std::string>>::const_iterator` this time
- the greatest ancient and most readable of all lowercase_style_names - `find_first_not_of()`, NOT `findFirstNotOf()`
- Allman brace style, long line splits to avoid any syntax ambiguity

_please report any typos_