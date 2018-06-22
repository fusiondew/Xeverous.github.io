---
layout: article
---

So far all of the example programs were using simple built-in types. **Classes** allow you to define custom types with custom functions - **methods**. OOP (Object-Oriented Programming) is a very wide topic that has been worked on since 1950s. Simula language - one of the first languages to feature OOP. Today OOP is the main feature of many programming languages. OOP offers great benefits compared to traditional, structural programming.

C++ is a multi-paradigm language. OOP is one of it's bigger features, but it's no where required - in contrast, many languages force OO style of programming and their "hello world"s can not be written without creating a class. Due to it's philosophy, C++ does not have such requirement - it supports and encourages very wide ways of programming. In fact, most of the standard library uses generic programming rather than OOP. 

Despite the fact that C++ does not put as much hype into OOP as other languages, it has actually more features. Most of C++-specific OOP features are not present in other languages because they were thought as unnecessary or easy to misuse. C++ gives the opportunity to do more but it's a double-edged sword - that's why you may read learning C++ is harder than other languages.

## the purpose

So what exactly is a class? In simple terms, it's a group of closely related variables which are intended to be used together. Such group can have own class-specific functions - **methods**. Methods can be used **on** objects of appropriate classes.

Classes can improve code readability and offer modular design. They also feature a different syntax.

```c++
set_text(button, "hello"); // structural
button.set_text("hello");  // object-oriented
```

Isn't the second line more intuitive?

- The structural approach uses a global function which takes (a reference to) a button and the text to set.
- The OO approach uses a class-specific function which takes only the text to set. Method is invoked on the object `button` - note how `.` has to be used to access it. This is because methods are tied to classes and therefore have to be invoked on concrete objects.

OOP is related to few important terms:

- **abstraction** - *selective ignorance*. We can abstract away uninteresting things and focus on what is important.
- **encapsulation** - classes group related variables and functions. This leverages type safety and helps with modular design.
- **inheritance** - classes can be build as extentions to other classes. Massive code reuse.
- **polymorphism** - classes can provide interfaces - uniform way of treating objects on the outside with custom behaviour on the inside. Ability of *related* classes to behave differently while sharing something common.

## how to

Classes are custom (user-defined) types. Before using a class, you have to define it.

syntax:

TODO make it HTML

```c++
class class_name
{
access_specifier:
    fields and/or methods...
access_specifier:
    fields and/or methods...
...
access_specifier:
    fields and/or methods...
};
```

`class_name` - name of the class. Essentialy the name of the type that is created.

`access_specifier` - limits how the data is accessed. There are 3 possible specifiers: `private`, `protected` and `public`. What they do exactly - very soon. Just keep reading.

`fields` - class variables. In C++, you can encounter the term "member variables".

`methods` - class functions. In C++, you can encounter the term "member functions".

## access specifiers

You may remember structures - they have pretty intuitive use

```c++
struct point
{
    int x;
    int y;
};

point p1;
p1.x = 5;
p1.y = 10;

point p2;
p2.x = -3;
p2.y = 6;
```

In the example above, you can freely write `p1.x` and such to modify each of the point variables. Classes can constrain access to their member variables.

```c++
class point
{
public:
    int x;
    int y;
};

point p1;
p1.x = 5;
p1.y = 10;

point p2;
p2.x = -3;
p2.y = 6;
```

`public` access works the same way as with structures. `public` access means no restrictions. You can freely change member variables any time. `protected` and `private` allows only to access member variables inside class functions - the code above would not be valid.

#### Question: Why would I want to limit access to member variables?

Remeber the `const`? We limit mutability to avoid potential errors. Similarly with classes, we use access specifiers to limit potential misuse. Once you learn the purpose and convenience of member functions, you will understand it better.

## summary

**Classes** tie together **fields** (member variables) and **methods** (member functions).

**Access specifiers** can be used to limit access to members.
