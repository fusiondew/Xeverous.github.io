---
layout: article
---

So far all of the example programs were using simple built-in types. **Classes** allow you to define custom types with custom functions - **methods**. OOP (Object-Oriented Programming) is a very wide topic that has been worked on since 1950s. Today OOP is the main feature of many programming languages. OOP offers great benefits compared to traditional, structural programming.

C++ is a multi-paradigm language. OOP is one of it's bigger features, but it's no where required - in contrast, many languages force OO style of programming and their "hello world"s can not be written without creating a class. Due to it's philosophy, C++ does not have such requirement - it supports and encourages very wide ways of programming. In fact, most of the C++ standard library uses generic programming rather than OOP. 

Despite the fact that C++ does not put as much hype into OOP as other languages, it has some features which are not available anywhere else. Most of C++-specific OOP features are not present in other languages because they were thought as unnecessary or easy to misuse. C++ gives the opportunity to do more but it's a double-edged sword - that's why you may read learning C++ is harder than other languages. Most of C++-specific OOP features are at the end of this tutorial. In practice, they are rarely used.

This lesson is a more philosophical than others but further ones in this chapter showcase a lot of new code. It's important to not only understand *how*, but also *why*. You can perfectly memorize all OOP rules, write any program that satisfies given requirements but whether the code will be a good code is a very different topic.

<div class="note warning">
A lof of examples in this chapter are very purpose-oriented. They are here to teach - it's similar situation as with redundant comments explaining things that should be obvious (you don't write such comments in the real code).
<br>
You will realize that examples are not perfect (not-so-conventional order of declarations, missing const, missing static, overused features) - as with most things I focus first on learning parts and then how to use them together. 
</div>

*It was quite hard for me to write lessons in order that would perfectly satisfy me. If you find something hard to understand, simply move on and come back later - classes hit with lots of rules and most of them are related (rather than built on-top-of) which makes it hard to explain 1-2-3 way. Don't treat order of articles in this chapter with as much respect as in others.*

## the need and the purpose

So what exactly is a class? In simple terms, it's a group of closely related variables which are intended to be used together. Such group can have own class-specific functions - **methods**. Methods can be used **on** objects of appropriate classes.

Classes can improve code readability and offer modular design. They also feature a different syntax.

```c++
set_text(button, "hello"); // structural
button.set_text("hello");  // object-oriented
```

Isn't the second line more intuitive?

- The structural approach uses a global function which takes (a reference to) a button and the text to set.
- The OO approach uses a class-specific function which takes only the text to set. Method is invoked on the object `button` - note how `.` has to be used to access it. This is because methods are tied to classes and therefore have to be invoked on concrete objects. You can `wall.paint()` but `paint()`ing itself has no sense if there is nothing to work on.

You might have already realized that you write multiple functions which are closely related - something like this:

```c++
struct rectangle
{
    int a;
    int b;
};

void set_rectangle_sides(rectangle& r, int a, int b);
bool is_valid_rectangle(const rectangle& r); // checks if sides are correct (lengths must be positive)
int compute_rectangle_area(const rectangle& r);
```

With object-oriented approach, these **functions** should become **methods**. Instead of writing `if (is_valid(rect1))` one can write `if (rect1.is_valid())`.

## goals

OOP is related to few important terms:

- **abstraction** - *selective ignorance*. We can abstract away uninteresting things and focus on what is important.
- **encapsulation** - classes group related variables and functions and can constrain their usage through access specifiers. This leverages type safety and helps with modular design.
- **inheritance** - classes can be build as extentions to other classes. Massive code reuse.
- **polymorphism** - classes can provide interfaces - uniform way of treating objects on the outside with custom behaviour on the inside. Ability of *related* classes to behave differently while sharing something common.

## C/C++ border

You should know that so far most of presented C++ things also exist in C (with more or less similarities).

**This is the moment at which none of further presented things are in C.** This is the "++ part of C++". The actual C++ journey starts here.
