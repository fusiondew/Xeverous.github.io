---
layout: article
---

Short descriptions of all the keywords and relavant stuff in regards to templates.

`template` - indicates that the following declaration or definition is a template. Template signature is required for any subsequent implementations.

`typedef` - forms a type alias. Superseeded in C++11 by new `using` syntax, which allows to form templated aliases.

`typename` - indicates that the following identifier is an (yet unknown) type alias. Also used in contexts of dependent names to indicate a identifier is a type, not a value.

`decltype` - yields a fully qualified (may contain `const`, `volatile`, `noexcept`, `*`, `&` and `&&`) type of the expression. Most commonly used in templates to alias expressions and other types.

`std::declval` - function returning an object of specified type. This function has no definition and is only for type operations in unevaluated contexts  (more about it later).

`auto` (since C++11) - automatic type deduction. Used in various contexts to ommit and automatically deduce result type. Analogic to `var` and `let` in other languages.

`concept` (since C++20) - defines a concept (constrained template).

`requires` (since C++20) - used to form a concept or constrain a template.
