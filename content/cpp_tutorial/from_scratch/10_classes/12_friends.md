---
layout: article
---

There is a special feature which lets ignore access specifiers: friends.

Friends have access to anything, including private and protected members.

**Friend declarations are not affected by access specifiers.** It doesn't matter where you put it. It just have to be inside the class definition.

## friend functions

**A class can friend a non-member function. This function will have access to private and protected members.**

```c++
#include <iostream>

class foo
{
private:
    int x = 3;

    // this is not a member function but a friend function declaration
    friend void func(const foo& f);
};

void func(const foo& f)
{
    std::cout << "f.x = " << f.x << "\n"; // friends can access private and protected members
}

int main()
{
    foo f;
    func(f);
}
```

You can also place the function definition inside the class. It's always `inline` then. It's still a global function despite how it looks (`friend` keyword informs that it's not a member).

```c++
#include <iostream>

class foo
{
private:
    int x = 3;

    // global friend function defined inside class is always inline
    friend void func(const foo& f)
    {
        std::cout << "f.x = " << f.x << "\n";
        // std::cout << this << "\n"; // error: 'this' is not available in non-member functions
    }
};

int main()
{
    foo f;
    func(f);
}
```

Friend function definitions inside class are only allowed if the class is defined non-locally (at global scope or in some namespace, it won't work for class defined locally - eg in a function - but obviously noone defines classes inside functions...).

## friend classes

**A class can friend another class. Friended class (and it's functions) will have access to private and protcted data. This works only in 1 direction.**

There are 2 types of declarations:

```c++
friend class_name;       // 1: simple type specifier
friend class class_name; // 2: elaborated type specifier
```

Both let the designated class access private and protected members of the enclosing class. The statements have only minor differences:

**simple type specifier**

- Requires `class_name` identifier to exist (otherwise compilation error).
- If the identifier exists but is not a class, struct or union the statement is ignored.

**elaborated type specifier**

- `class_name` identifier is not required to exist. If it doesn't exist, in addition to friending that class it's also a class forward declaration.

```c++
class Y {};
class Z1 {};
using A = int;

class X
{
private:
    int data;

    friend A; // A exists but is not a class - statement ignored
    // friend B; // error: B identifier does not exist
    friend Y; // allows Y to access private/protected members of X
    friend class Z1; // as above
    friend class Z2; // as above + also forward declares class Z2

    // friend class Z3 {}; // error: friended class definition inside enclosing class not allowed
};
```

## friend methods

It's also possible to friend certain members of other classes. But you need first to access these members.

```c++
class X
{
public:
    int func1() const;
private:
    int func2() const;
};

class Y
{
    friend X::X(); // default 0-argument ctor is public
    friend int X::func1() const; // ok, X::func1 is public so you can access it here
    // friend int X::func2() const; // error, X::func is private so we can not access to friend it
};
```

## other rules

- Friendship is a one-way relation: if A friends B, B can access protected and private members of A but A can not access private and protected members of B.
- Friendship is not transitive: a friend of your friend is not your friend.
- Friendship is not inherited: your friend's children are not your friends; your's children do not friend your friends.

In short, friendship is a one-way relation that does not propagate.

**Note:** it's possible to template friend statements. Rules regarding template friends are not covered here.

## recommendation

Too many friends defeat the purpose of encapsulation. Don't use them unless necessary. Friends, thanks to unlimited access can break class invariants.

Common situations and how to fix them:

- If two classes friend each other, they probably should be rewritten as one class
- If one class has many friends, it should provide instead public methods that offer functionality which is implemented in friends

Legitimate uses of friends:

- Overloading non-member operators

**Do not ever friend any class or function from the standard library.**

Standard library has it's own, internal `__compiler_specific` classes and functions inside it's "accessible surface". Because friendship does not propagate, it will not work.

## summary

<div class="note pro-tip">
Don't use friends except for non-member operator overloads.
</div>

*Examples in operator overloading chapter.*
