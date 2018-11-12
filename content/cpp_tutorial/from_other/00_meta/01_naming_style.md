---
layout: article
---

There is no language-imposed naming convention in C++ (neither in C) and many projects use different styles.

Personally I am against WritingEverythingUsingCamelCaseNotOnlyBecauseItIsHardToRead. snake_case names are longer, but easier to read and we should optimize code for the reader, not for the writer - code is read ~10 more times than written.

The original naming style in C++ follows the one of C which means that everything except macros should be written using snake_case. This also includes class names.

C++ uses PascalCase names, but only for template parameters and concepts - this is a quite small part of code.

## reserved names

C++ reserves following name patterns for the implementation:

- `_X*` - anything beginning with an underscore followed by an uppercase letter
- `*__*` - anything containing 2 consecutive underscores

This makes sure that user code does not interfere with implementation, especially macros that can easily sabotage includes.

Using reserved names that are not explicitly allowed by the implementation (some offer fancy stuff like additional keywords or types, eg `__int128`) is undefined behaviour.

## members

Many conding styles recommend to use different name styles for members. There is no strong convention for it in C++, but there are few common ones:

~~~
member_variable (no special style)
member_variable_
_member_variable
m_member_variable
~~~

Personally I am for the last one as it allows IDEs a very good autocomplete.

## file naming

C used .h and .c file names, and it sounds natural that C++ should have similar convention.

Thus, I recommend .hpp and .cpp; some projects use .hh and .cc.

You might see use of .h and .cpp but I discourage this. There are projects that use both C code and C++ code and having the same extension for headers can confuse both humans and tools.

## coding styles

One of the worst coding styles you can find for C++ is Google's C++ style. It has numerous issues and is mostly suited for writing legacy code.

C++ has many features and no project uses all of them. Keep everything at reasonable level, adhere to general programming recommendations and deviate from them if you have a good reason (eg performance).

In terms of a good recommendations - read [Core Guidelines](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) which are developed by people who are behind C++. Core Guidelines are basically C++'s PEP8.
