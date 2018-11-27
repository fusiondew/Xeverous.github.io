---
layout: article
---

## names

Classes represent things - their names are usually nouns.

Methods represent actions - their names are usually verbs.

```c++
my_rectangle.set_values(5, 10);
menu_button.set_text("menu");
click_sound_effect.play();
```

## typical member functions

From member functions there can be distincted few characteristic kinds: **setters**, **getters** and few others.

Not all member functions belong to these. These are just the most characteristic ones.

Setters:

- modify the object (they *set* things)
- secure **class invariant**s.
- function names usually start with `set`
- usually return `void`
 
Getters:

- do not modify the object
- function names usually start with `get` (return some private value or simple computation result)
- provide a convenient way to access information (different figures have different formulas but we don't need to remember them - just call `get_area()`)
- usually are read-only operations that should not affect the object state

Question-like functions:

- return `bool`
- start with `is` or `has` - for example: `is_ready()`, `has_completed()`
- do not modify object
- names are formed like questions

Action-like functions:

- modify the object
- names are formed like orders - for example: `change_image()`, `load_file()`, `refresh()`
- typically return `void` or `bool` (to inform if the operation succeeded)
- are often expensive (in terms of required operations)

Other important member functions (these have their respective lessons), they have special rules:

- **constructors**
- **assignment operator**
- **destructors**

Getters and setters are sometimes referred to as **accessors**.

Getters and setters do not always come in pairs - getters may combine information from multiple members and setters (and action functions) may change more than 1 variable.

It's rarely the case that getter and setter just set and return private members - it's usually more complicated. Even if not, if you use someone else's code (eg from a library) methods can be changed (eg library update) and code that uses them will also change it's behaviour. In this regards methods save us from rewriting the program - all of your code automatically gets updated when a method is changed. This is one of the reasons why it's recommended to have all member variables private - even if accessors are 1-line functions they can be changed any time when there is a need to do more.

## summary

- Getters and setters are the simplest examples of methods.
- The purpose of setters is to prevent setting invalid values (they secure invariants).
- The purpose of getters is to give access to private members (usually without allowing to modify them).
- Getters and setters do not always come in pairs.
    - A lot of data is calculated from other data and is read-only. Then you can have more getters than member variables.
    - A lof of member variables can have complex relations and result from other events (such variables don't have setters).
