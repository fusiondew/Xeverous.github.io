---
layout: article
---

### Iterators

Prerequisities: operator overloading, data structures

You might already encounter this term. But what does it really mean? What is the purpose of iterators? Where/Why they are better than ordinary integer index?

Have a look at a typical array loop:

```c++
std::vector<int> v = { 3, 4, 9, -7, 8, 2, 0, -11 };
for (std::size_t i = 0; i < v.size(); ++i)
    std::cout << v[i] << '\n';
```

`operator[]` is used to access the elements. Vector is relatively simple structure in which array indexes are just pointer arithmetics. `v[i]` just accesses internal array start pointer and adds `i` to it.

The different way to do the loop - using iterators:

```c++
for (auto it = v.begin(); it != v.end(); ++it)
    std::cout << *it << '\n';
```

It does the same thing but has noticeable differences:

- `begin()` is used to initialize the iterator
- iterator is compared with `end()`
- the comparison uses `!=` instead of `<`
- element is accessed by `*it`

This brings us to one question

#### Are iterators just a fancy name for pointers?

Not really. Indeed, the simplest form of an iterator is a pointer. But it's true only for continuous storage containers. What if the structure is not a continuous block of memory? Some containers forms trees or multiple arrays - simple pointer increment would not work in their case. Linked lists, trees or even more complex data structures can not just give user pointers to iterate, because elements are not stored next to each other.

This is **why iterators are needed. They abstract the way elements are accessed and how to move from one to another.**

**Iterators are custom types that implement pointer-like behaviour.** They know how to:

- access an element (`*it`)
- move forward / backward / jump (`++it`, `--it`, `it += x`)
- compare with each other `it1 != it2`, especially with `end()` of the sequence

The core point is that you can **use iterators just like they were pointers while they may do something more complex underneath**. Iterators are just pointer wrappers, replicating all of their behaviour through operator overloading.

### implementation differences

Iterators must be are aware of the given data structure and know how to move around and access elements.

Iterators of arrays just move forward across consecutive elements. Array iterators are plain pointers or their wrappers.

```
0xA0   ...  0xA3     ...    0xA7
+---+---+---+---+---+---+---+---+
| a | b | c | d | e | f | g | h |
+---+---+---+---+---+---+---+---+
 /|\       moving forward is
  |    ==> just pointer increment
 it        moving backward - decrement
0xA0
```

Iterators of linked lists obtain next element address from the node:
```
 0xA0            0xA7            0xB5            0xDB
+----+----+     +----+----+     +----+----+     +----+----+
| a  |0xA7| --> | b  |0xB5| --> | c  |0xDB| --> | d  |0xB9| -->
+----+----+     +----+----+     +----+----+     +----+----+
                 /|\
                  |    ==> moving forward - read next node address
                  it       moving backward - impossible
                 0xA7
```

Iterators of trees are more complicated.

Their `operator++` is defined in a such way that the iterator knows how to move across tree branches - it performs checks (eg if given tree node has a child) and goes upwards / downwards as needed.

```
p: null, c1: 0xA3, c2: 0xB3
         0xA0
          d   <-- it (How does it traverse? When to move left/right?)
        /   \
0xA3  a       f  0xB3, p: 0xA0, c1: 0xCC, c2: 0xC0
       \     / \
  0xA7  b   e   h  0xC0, p: 0xB3, c1: 0xBA, c2: null
         \     /
    0xAA  c   g  0xBA, p: 0xC0, c1: null, c2: null
 p: 0xA7,
c1: null,
c2: null
```



### expectations

In all cases we want to achieve the same - traverse the whole structure and visit each element exactly once.

In the case of array and linked list we can be sure that the order will be `a, b, c, d, e, f, g, h`.

In the case of tree - it depends on the implementation: both `c, b, a, d, f, e, h, g` and `d, a, b, c, f, e, g, h` are valid.

### supported operations

There is also 1 important difference - in the case of array it's very easy to jump across multiple elements at once - just add multiplied element size. In the case of tree it's not very possible - given the address of a node, we can only move to it's parent or one of it's childs (if they exist). There is no simple way to jump ahead besides just repeating advancement in a loop.

And this is the reason why each standard library container (and also strings and string views) produces own iterator type. Some iterators offer more operations than others.

`std::forward_list<T>::iterator` supports moving forward: `++it`

`std::set<T>::iterator` supports moving forward (`++it`) and backward (`--it`)

`std::vector<T>::iterator` supports moving forward, backward and jumping over arbitraty number of elements (`it += n`)

#### Question: Are iterators smart pointers?

No. This is a different term. The purpose of iterators is to abstract data structure traversal. The purpose of smart pointers is to encapsulate resource management.

### implementation

In order to use iterators correctly, you need to understand their concepts - eg the beginning and end of a sequence.

I will use array iterators for examples - they are plain pointers and have minimal abstraction

```
      0xA0           ...          0xA7
--+---+---+---+---+---+---+---+---+---+---+--
  |   | a | b | c | d | e | f | g | h |   |
--+---+---+---+---+---+---+---+---+---+---+--
       /|\                             /|\
        |  begin                        |  end
        |   0xA0                        |  0xA8
```

The `begin` iterator points to the first element. The `end` iterator points **1 past** the last element. **It is very important to understand why ends are past the last element, not at the last element.**

### analogy - size-based iteration

If `size == 8` elements are `v[0] ... v[7]`. The condition in loop is `i < size()`. `v[8]` is not correct - it's 1 past the last element, just like end iterator. The core part is that `i` never reaches `8` - it's always *less than* `size`.

### analogy

A good analogy is this tricky question:

> A book chapter begins on page 10 and ends on page 15. How many pages does it have?

If you think it's 5 - you are wrong! It's 6: 10, 11, 12, 13, 14, 15.

But why? Why simple subtraction does not work? Where is this annoying off-by-one error coming from?

The answer is: because 15 is not an end. Page 15 is the last element of the chapter. We need **1 past** the last element to be an end. The more intuitive question form would be:

> A book chapter starts on page 10. The next chapter begins on page 16. How many pages does the first chapter have?

Now the subtraction works. You shoud now get how iterators interact: the end of some sequence is the beginning of another:

```
        chapter X elements        | end of
     ------------------------     | chapter X
   /                          \  \|/
--+----+----+----+----+----+----+----+----+----+--
  | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 |
--+----+----+----+----+----+----+----+----+----+--
   /|\                           /|\
    |  begin of                   |  begin of
    |  chapter X                  |  chapter Y
```
Such `end` iterator functionality gives important advantages:

- `size` is always equal to `end - begin`. No off-by-one errors. Test it on first example: `0xA8 - 0xA0 = 8` - the array indeed contains 8 alphabet letters.
- It is possible to represent an empty sequence. In such case `begin == end` and thus `size == 0`. If the end iterator pointed to the last element, there would be no way to distinguish empty sequence from sequence of size 1.

This is how a sequence of 1 element looks like:

```
                    |
                    |  end
                   \|/
--+---+---+---+---+---+---+---+---+--
  |   |   |   | a |   |   |   |   |
--+---+---+---+---+---+---+---+---+--
               /|\
                |  begin
                |
```

And this is how an empty sequence looks like:

```
                |
                |  end
               \|/
--+---+---+---+---+---+---+---+---+--
  |   |   |   |   |   |   |   |   |
--+---+---+---+---+---+---+---+---+--
               /|\
                |  begin
                |
```

### back to the code

```c++
for (auto it = v.begin(); it != v.end(); ++it)
    std::cout << *it << '\n';
```

Now it's obvious: the `begin` method returns a beginning iterator and `end` returns an end iterator. Iterator is incremented using `operator++`, just like ordinary index.

But what about the comparison? Why `!=` instead of `<`?

The answer is because `<` does not make sense for many iterator types. Of course, it's easy to think of less-than concept in terms of elements of an array - but what for trees or linked lists? If we have iterators (or even plain pointers) to 2 different tree/list nodes - how would it be possible to determine which one is greater? Memory is not continuous so addresses have random values. It's not even apparent how it's possible to reach one node from another.

This is why **iterators guarantee only the concept of equality**. Some iterators offer more, but only equality is required to be an iterator.

### iterator types

TODO

### iterator invalidation

TODO