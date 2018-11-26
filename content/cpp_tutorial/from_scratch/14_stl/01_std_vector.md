---
layout: article
---

`std::vector` is a standard library wrapper around dynamic array implementation. It has several features:

- multiple insertion/erase functions
- member `size()` function
- range-based loop support (aka for-each)
- overloaded `operator[]` to be able to work with just like with plain pointers and arrays

Vector is a class template - through the magic of generic programming it can hold any type you choose.

## basic example

Vector has multiple constructors and assignment operators. The one used below should be obvious.

```c++
#include <iostream>
#include <vector> // required for std::vector

int main()
{
    std::vector<int> v = { 1, 3, 3, 7, 4, 2, 0 };
    //         ^^^^^ note how held type must be specified

    // add more values
    v.push_back(6);
    v.push_back(9);

    for (int val : v) // for-each loop
        std::cout << val << '\n'; // 'val' represents one element
}
```

~~~
1
3
3
7
4
2
0
6
9
~~~

## more than just array

Remember dynamic array class from previous chapters?

TODO paste dynamic array snippet

The class allocates memory upon construction and deallocates in destructor. We can provide `operator[]` and `size()`. Unfortunately, once the object is constructed we can not change it's size.

Vector is different. It has more member variables and allocates *at least* as much as needed. Size of the vector changes when elements are inserted or erased.

## dynamic size

Vector has 2 concepts of "size":

- `size()` - the actual amount of stored elements
- `capacity()` - the maximum amount of stored elements without further allocations

**Vector invariant**: capacity is always >= size.

- `resize()` - changes amount of stored elements, may require additional allocation if capacity is not enough
- `reserve()` - changes only the capacity, amount of elements is not affected

The above functions take integer parameter specifying new size/capacity.

## what's inside

This is an example body of vector class (without templates). This one stores `double`s.

```c++
class vector
{
private:
    double* data = nullptr;
    double* end_of_data = nullptr;
    double* end_of_storage = nullptr;

public:
    // all member function declarations...
};
```

**3 pointers? WTF?**

Yes.

TODO vector infographic

- elements span from `data` to `end_of_data`
- the entire allocated memory spans from `data` to `end_of_storage`
- space between `end_of_data` and `end_of_storage` is uninitialized memory - future elements will be put there

This leads to conclusion that:

- `size()` is `end_of_data - data`
- `capacity()` is `end_of_storage - data`

We can already write such methods:

```c++
int vector::size() const
{
    return end_of_data - data;
}

int vector::capacity() const
{
    return end_of_storage - data;
}
```

## how it works

A default constructed vector can be left as is - initializing all member pointers to null pointers will work correctly. Both size and capacity will be zero (methods will just do `nullptr - nullptr`) which makes sense.

Suppose we would like to insert an element. We have 2 potential scenarios:

- capacity > size - easy, we just **append element at the end** and increment `end_of_data`
- capacity == size - we don't have more space, this will require **larger** allocation

**Why append at the end?**

It's the simplest. Putting an element in the space already occupied would overwrite existing elements. Putting an element but not just after last one would create a hole that would cause problems during iteration and complicate calculating size.

**Larger allocation - how capacity should grow?**

Memory allocation is an expensive operation. If we allocate for just `capacity() + 1` we would get the same problem at the next insertion. If we allocate for `capacity() + 10` we can delay this problem - but for how long? If the vector has capacity of 5, this gives us a quite large future space. But what if the vector has like 1000 elements? For such big one we can expect further insert operations will likely add tens or hundreds of elements.

By the way, vector of 1000 elements is not actually *that* big. If it stores `doubles` and we assume that `sizeof(double) == 8` on the running platform, 1000 * 8 gives up 8000 bytes which is not even 8 kibibytes! With the size of current computer memory, we should be prepared for storing milions and biblions of elements.

The solution to "how much memory should be allocated" is easy - **increase the capacity depending on the current capacity**.

The simplest approach is to just double the amount of allocated memory each time vector becomes full. For any size, we can be sure this will allocate reasonably enough free space for future insertions.

The insertion function name "push back" might seem weird but you will understand it once you learn more about **data structures**.

```c++
void vector::push_back(double new_element)
{
    if (capacity() > size()) // easy, just place new element after exisint ones
    {
        *end_of_data = new_element;
        ++end_of_data; // this will effectively change the size
    }
    else // need to reallocate
    {
        if (size() == 0)
            reserve(8); // multiplying 0 would result in 0, instead give some starting capacity
        else
            reserve(capacity() * 2);

        // now, we have enough space and can insert new element
        *end_of_data = new_element;
        ++end_of_data; // this will effectively change the size
    }
}
```

Allocation happens inside `reserve()`. Because allocation results in a new memory block, elements need to be copied from old block to the new block.

Some users may call resize function directly before multiple insertions if they know how many elements will be put (to avoid multiple reallocations during lots of inserts). If the new size is smaller than the current, we can ignore the call.

```c++
void vector::reserve(int new_capacity)
{
    if (new_capacity < capaciy())
        return; // ignore, we already have enough space

    // allocate new block
    double* new_storage = new double[new_capacity];
    // copy elements to the new block
    for (int i = 0; i < size(); ++i)
        new_storage[i] = data[i];
    // free memory - we no longer need current (smaller) block
    delete[] data;
    // assign new blocks to member variables
    int current_size = size(); // amount of elements did not change but setting any member pointer will break this function
    data = new_storage;
    end_of_data = new_storage + current_size;
    end_of_storage = new_storage + new_capacity;
    // now invariant end_of_storage >= end_of_data >= data is again satisfied
    // member functions will work back again
}
```

## array access

Array operator needs 2 overloads. One const-qualified and one not.

The const overload should be obvious - this function does not modify elements, it's just a getter. It's also the only one usable if you have a const reference to the vector (eg passed as read-only argument to the function)

```c++
const double& vector::operator[](int i) const
{
    return data[i];
}
```

The non-const overload is needed for situations when users of the class want to write to the vector.

```c++
double& vector::operator[](int i)
{
    return data[i];
}
```

In the const overload we could return by value - const references to trivial types do not work faster than copy. I wrote const reference for consistency - the standard library implementation uses templates and (without advanced template sorcery) returning by const reference is safer than by copy - templates do not know with what type vector will be used. References to trivial types will be optimized anyway while copies for some types could not compile (not all types are copyable).
