---
layout: article
---

## copy constructor

There is a special constructor overload which takes another object of it's type as parameter.

```c++
class point
{
public:
    // always present unless you write your own with = delete or custom body
    point(const point& p) = default; // copy ctor

private:
    int x = 0;
    int y = 0;
};
```

If you don't explicitly remove copy constructor, it will be automatically added to the class, like in the example above.

By default, copy ctor copies value of each member in the order they are declared.

## example

Copy constructors are called every time an object of the same type is created from another object. Copy constructors are called only at initialization.

```c++
#include <iostream>

class point
{
public:
    point(int x, int y);
    void print() const;

    // we rely on automatically added copy ctor here

private:
    int x = 0;
    int y = 0;
};

point::point(int x, int y)
: x(x), y(y)
{
}

void point::print() const
{
    std::cout << "(" << x << ", " << y << ")\n";
}

int main()
{
    point p1(2, 3);
    p1.print();

    point p2(p1); // calls copy ctor
    p2.print();

    point p3 = p2; // calls copy ctor
    p3.print();

    point p4(4, 5);
    // p2 = p4; // error: no match for operator=(point, point)
}
```

## initialization vs assignment

In the example above first line using `=` compiles but second does not.

This is because first line is an initialization but second is an assignment. Initialization happens only upon object creation - the second line does not create an object.

Initialization in C++ has a variety of syntax options (including `=`) and regardless of the choosen one, it will call one of available constructors or directly initialize some members.

In order to make second line work, we need to overload `operator=`. This is covered in next chapter.

## custom copy constructor

Custom copy constructors are written just like any other constructors. The only difference is that they must take a const reference to the different object as the only parameter.

```c++
// inside class body
point(const point& other); // no = default/delete means compiler will expect custom definition

// outside
point::point(const point& other)
: x(other.x), y(other.y)
{
    std::cout << "copy ctor called\n";
}
```

## copy constructors vs pointers

Let's recall a dynamic array from previous lesson. There is an importan thing to be shown.

```c++
#include <iostream>

class dynamic_array
{
public:
    dynamic_array(int size);
    ~dynamic_array();

    int get(int pos) const { return data[pos]; }
    void set(int pos, int val) { data[pos] = val; }

    int length() const { return size; }
    void print() const;

private:
    int* const data;
    const int size;
};

dynamic_array::dynamic_array(int size)
: data(new int[size]), size(size)
{
}

dynamic_array::~dynamic_array()
{
    delete[] data;
}

void dynamic_array::print() const
{
    for (int i = 0; i < length(); ++i)
        std::cout << "[" << i << "] = " << get(i) << "\n";
}

int main()
{
    dynamic_array a1(10);
    for (int i = 0; i < a1.length(); ++i)
        a1.set(i, i * 2);

    std::cout << "first array\n";
    a1.print();

    dynamic_array a2 = a1;
    std::cout << "second array\n";
    a2.print();
}
```

Looks like another simple program calling constructors, but upon running there is a surprise:

~~~
$ ./program
first array
[0] = 0
[1] = 2
[2] = 4
[3] = 6
[4] = 8
[5] = 10
[6] = 12
[7] = 14
[8] = 16
[9] = 18
second array
[0] = 0
[1] = 2
[2] = 4
[3] = 6
[4] = 8
[5] = 10
[6] = 12
[7] = 14
[8] = 16
[9] = 18
Segmentation fault (core dumped)
~~~

**The program has crashed.** The error message is different on each system, on Windows most common is "program has stopped working" popup, on Unix systems various errors related to memory segmentation are printed.

So what has gone wrong? The program successfully printed contents of both arrays but something bad happened later.

The cause might not be clear at the first sight, so lets outline what actually happens when the program is run:

- first array is created
  - memory is allocated by the constructor
- first array is modified
- first array is printed
- second array is copy-created from first array
  - `data` is copied to second array
  - `size` is copied to second array
- second array is printed
- end of scope, run destructors (in reverse order)
  - destructor of second array frees memory pointed by `data`
  - destructor of first array frees memory pointed by `data` - **the same memory is freed again**

The cause of the problem lies here:

```c++
    dynamic_array a2 = a1;
```

So in short, both arrays were sharing the same memory block because the copy constructor copied the pointer. At the end of the program, each object was not aware that there is another object that also has access to that memory and is going to free it.

You can notice that memory is shared by modifying any data of one of array objects:

```c++
int main()
{
    dynamic_array a1(10);
    for (int i = 0; i < a1.length(); ++i)
        a1.set(i, i * 2);

    dynamic_array a2 = a1;
    std::cout << "first  array pos 1: " << a1.get(1) << "\n";
    std::cout << "second array pos 1: " << a2.get(1) << "\n";
    a2.set(1, 5);
    std::cout << "first  array pos 1: " << a1.get(1) << "\n";
    std::cout << "second array pos 1: " << a2.get(1) << "\n";
}
```

~~~
$ ./program
first  array pos 1: 2
second array pos 1: 2
first  array pos 1: 5
second array pos 1: 5
Segmentation fault (core dumped)
~~~

Because both arrays have the same value of the pointer, any modification of one also affects another - there is only one array is memory but 2 objects have pointers to it.

## resource ownership

The problem above can be named as *unwanted resource sharing*. 2 objects try to manage the same resource (here: dynamically allocated memory) without knowledge of another.

Additionally, any modification to that resource (here: changing values in the array) also affects other objects which share this resource.

We need some mechanism to determine who (which code) is reponsible for resource management

## owners vs observers

The `data` member pointer of the `dynamic_array` class is an **owning pointer**. It's owning because it is used to allocate and deallocate a resource.

This is not an owning pointer:

```c++
{
    int x;
    const int* p = &x; // not an owner (does not manage memory)
    // p is an *observer*
}
```

It's important to have clear distinction between owners and observers as otherwise resource management becomes very unclear which results either in crashes or resource leaks.

## shallow vs deep copying

Copy constructors by default blindly copy each member. It works well for built-in types and structures of them, but creates problems when copying an owning pointer. This is because the pointer is copied, not the resource managed by it.

What we want is **deep copying** - instead of copying the pointer itself (**shallow copy**), we want to copy contents of the pointed memory (**deep copy**). This is achieved by writing a custom copy constructor:

```c++
// inside the class
dynamic_array(const dynamic_array& other);

// outside
dynamic_array::dynamic_array(const dynamic_array& other)
: data(new int[other.size]), size(other.size) // allocate block of the same length
{
    for (int i = 0; i < size; ++i)
        data[i] = other.get(i); // copy array contents
}
```

Now any object created by copy constructor will have a separate memory block. If you rerun the second example now it will correctly show that both array objects manage different memory (changes are unrelated):

~~~
$ ./program
first  array pos 1: 2
second array pos 1: 2
first  array pos 1: 2
second array pos 1: 5
~~~

The program no longer crashes, because each object has it's own memory block.

## the rule of 3

TODO def block

If a class contains any of the following:

- custom destructor
- custom copy constructor
- custom copy assignment operator (`operator=` overload)

it almost certainly needs all 3.

The presence of any of mentioned 3 special member functions almost always is a consequence of having to deal with resource management. Writing one but forgetting to write the rest usually ends in bugs causing crashes like the one presented in this lesson.

Therefore, you should follow the rule of 3 - watch out when writing any class that holds owning pointers - you almost always don't want to copy them but the contents of managed resource.

#### Question: Example of a different resource than memory?

Practically all resources will be more or less related to memory but many of them will be more than just dynamically allocated block.

Example other resources:

- POSIX file descriptor (given by the OS when opening a file) (this is an integer)
- network socket
- available threads to execute some tasks

## RAII

This lesson presents an example problem which occurs as a consequence of improper resource management. RAII (resource acquisition is initialiation) is a C++ programming technique which relies on binding a resource to the lifetime of an object and clear notion of owners and observers.

We can say that after the addition of custom copy ctor, `dynamic_array` class is a RAII class - the lifetime of the dynamically allocated array is managed by class constructor and destructor.

```c++
{
    dynamic_array da(/* ... */);
    // use da...
} // no memory leaks, destructor frees resources
```

**RAII is one of fundamental C++ concepts.**

Later in the tutorial, you will learn:

- how to deal with resources that are unique (can not be copied, only observed)
- how to share a resource to multiple users without breaking it's cleanup
- how to transfer (move) a resource between 2 objects (effectively changing the owner)
- resource-managing tools that are offered by C++ standard library, especially:
  - containers
  - smart pointers

If you find the term name unclear (resource acquisition is initialiation) - don't worry, C++ has a lot of idioms that have weird names, some of which have unpronounceable abbreviations. The alternative names for RAII are SBRM (scope-based resorce management) and CARD (constructor acquires, destructor releases).

## recommendations

- have a clear notion of owning and observing pointers
- encapsulate a resource by writing a class for it (examples in future chapter)
- follow the rule of 3 (note: there is also rule of 5 and of 0 - these will be presented later)
