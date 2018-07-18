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

From member functions there can be distincted few characteristic kinds: **setters**, **getters** and question-like functions.

Setters:

- modify the object (they *set* things)
- secure **class invariant**s.
- function names usually start with `set`
 
Getters:

- do not modify the object
- function names usually start with `get` (return some private value or simple computation result)
- provide a convenient way to access information (different figures have different formulas but we don't need to remember them - just call `get_area()`)

Question-like functions:

- return `bool`
- start with `is` or `has` - for example: `is_ready()`, `has_completed()`
- do not modify object
- names are formed like a questions

Action-like functions:

- modify the object
- names are formed like orders - for example: `change_image()`, `load_file()`, `refresh()`
- typically return `void` or `bool` (to inform if the operation succeeded)

Not all member functions belong to these. These are just the most characteristic ones.

Getters and setters are sometimes referred to as **accessors**.

Getters and setters do not always come in pairs - getters may combine information from multiple members and setters (and action functions) may change more than 1 variable.

It's rarely the case that getter and setter just set and return private members - it's usually more complicated. Even if not, if you use someone else's code (eg from a library) methods can be changed (eg library update) and code that uses them will also change it's behaviour. In this regards methods save us from rewriting the program.

## summary

- Getters and setters are the simplest examples of methods.
- The purpose of setters is to prevent setting invalid values (they secure invariants).
- The purpose of getters is to give access to private members without allowing to modify them.
