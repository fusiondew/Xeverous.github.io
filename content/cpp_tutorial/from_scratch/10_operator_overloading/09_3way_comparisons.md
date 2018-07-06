---
layout: article
---

<div class="note info">
This lesson describes feature added in C++20
</div>

## defaulted comparisons

Since C++20 it's possible to default comparison just like ctor/dtors.

```c++
struct package
{
    int floor;
    int shelf;
    int position;
    double weight;

    // note the return type
    auto operator<=>(const package& rhs) const = default;
};
```

New operator `<=>` represents 3-way comparison and behaves similarly to string compare function.

It has it's own language rules and can be safely declared as member function.

Compiler automatically generates all comparison operators. By default all members of the type are compared in order of their appearance, making it a usual lexicographical comparison. Basically it applies operators to consecutive members which may have operator overloads themselves.

`<=>` operator can also be used directly: `if ((a <=> b) < 0)` (but better not do it). The return type of `<=>` can only be compared with literal `0` or specific relational terms.

## custom comparisons

When default semantics are not suitable (order/amount of compared members), `<=>` operator can be defined with specific return type and custom implementation.

### ordering

These should be obvious (applicable to any objects of the same type):

- `x < x` is always `false` (irreflexivity).
- if `x < y` is `true` then `y < x` is `false` (asymmetry).
- if `x < y` and `y < z` then `x < z` (transitivity).
- either `x < y` or `x > y` or `x == y`

The above rules form **strong ordering**.

A type that implements strong ordering should compare all of it's members - otherwise substitutability can be compromised (operator `==` returns `true` but some member variables can be different). If this is the case then it's **weak ordering**. If some values can not be compared (for various reasons) then it's **partial ordering**.

#### mathematical example

Given a set of numbers:

$$
S = \{ 1, 3, -7, 5, -10, -13, 8, -3, 10 \}
$$

we can sort it using various methods that implement different ordering guarantees:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>sorting criteria</th>
                <th>result</th>
                <th>term</th>
            </tr>
            <tr>
                <td>$f(x) => x$</td>
                <td>${-13, -10, -7, -3, 1, 3, 5, 8, 10}$</td>
                <td>strong ordering</td>
            </tr>
                <td>$g(x) => abs(x)$</td>
                <td>${1, 3, -3, 5, -7, 8, -10, 10, -13}$</td>
                <td>weak ordering</td>
            </tr>
            <tr>
                <td>$h(x) => \sqrt{x}$</td>
                <td>${1, 3, 5, 8, 10}$</td>
                <td>partial ordering</td>
            </tr>
        </tbody>
    </table>
</div>

$f(x)$ (identity function) results in strong ordering. Values are sorted with full respect and without any transformation that loses information. If 2 values would be equal in this ordering, they are exactly the same numbers.

$g(x)$ forms weak ordering. The sorting criteria loses some information (here: sign) which creates a possibility that actually different values compare equal ($abs(3) = abs(-3)$). All values are still sorted but there is more than 1 way to achieve the same treatment.

$h(x)$ forms partial ordering. Some values are higher/lesser but some values can not be compared (here because they are out of domain of square root function).

#### Different examples:

- weak ordering: case-insensitive string search - `word` will match `wOrD` but they are actually different; still all words can be sorted
- partial ordering: comparing floating-point numbers. Different values can be equal ($0 * 2^1 = 0 * 2^{-2}$); some values (NaN, +/-infinity) can not be compared

#### code example

We have some data and class which represents people's ancestry. Not all people can be proved to be parents/childs of others so it's patial ordering.

```c++
class person
{
public:
    std::partial_ordering operator<=>(const person& that) const
    {
        if (this->is_the_same_person_as ( that)) return std::partial_ordering::equivalent;
        if (this->is_transitive_child_of( that)) return std::partial_ordering::less;
        if (that. is_transitive_child_of(*this)) return std::partial_ordering::greater;
        return std::partial_ordering::unordered; // unrelated people
    }

    // ...
};
```

### equality

Some types do not make sense in ordering, but we can compare whether they are equal.

```c++
struct point
{
    int x;
    int y;

    std::strong_equaliy operator<=>(const point& rhs) const = default;
}
```

There is no point (pun intended) in sorting 2D numbers so this type should only support operators `==` and `!=`. To constrain it, simply change return type from `auto` to specific comparison category.

If the point had more members (eg color) but we wanted to compare only X, Y coordinates we would need to write custom body of the operator. By default it compares all elements. If the color is skipped, it would be **weak equality**.

Pure equality commonly appears when dealing with pointers. If 2 objects have unknown and/or different origins (they may not come from the same array), we can only check whether these 2 pointers are equal. `std::shared_ptr` (one of smart pointers) satisfies weak equality, but since it knows only about memory owner it can only tell whether it's the same (more about smart pointers later).

There is no **partial equality** (at least in C++).

#### Question: What is the comparison category when return type of operator<=> is automatic?

It depends on the members. In short, it will be the category that is common for all members (i.e. all members can satisfy it's requirements).

partial < weak < strong

equality < ordering

- If there is at least 1 weak ordering, the whole class can be at most weakly ordered (because strong can not be guaranteed).
- If there is at least 1 partial ordering, the class will be at most partially ordered.
- (...)
- If there is at least 1 weak equality, the class will be at most weakly equal (because some members can not be ordered, the class can only be tested for equality)
- If there is a member that has no defined comparison category, the class will also have no category (ill-formed program - compilation error)

There is a [type trait](https://en.cppreference.com/w/cpp/utility/compare/common_comparison_category) that can provide this information for any amount of types. Using traits requires some template knowledge.

## summary

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>category</th>
                <th>supported operators</th>
                <th>everything can be compared</th>
                <th>equal values are trully the same</th>
            </tr>
            <tr>
                <td>`std::strong_ordering`</td>
                <td>&lt; &gt; &lt;= &gt;= == !=</td>
                <td>&#10004;</td>
                <td>&#10004;</td>
            </tr>
                <td>`std::weak_ordering`</td>
                <td>&lt; &gt; &lt;= &gt;= == !=</td>
                <td>&#10004;</td>
                <td></td>
            </tr>
            <tr>
                <td>`std::partial_ordering`</td>
                <td>&lt; &gt; &lt;= &gt;= == !=</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>`std::strong_equality`</td>
                <td>== !=</td>
                <td>&#10004;</td>
                <td>&#10004;</td>
            </tr>
            <tr>
                <td>`std::weak_equality`</td>
                <td>== !=</td>
                <td>&#10004;</td>
                <td></td>
            </tr>
        </tbody>
    </table>
</div>

In later tutorials you will be using STL data structures and algorithms - they offer certain operation complexity guarantees but require certain conditions to be satisfied - for example `std::sort` requires at least weak ordering, `std::find` requires at least weak equality.

If you understand these concepts, you should have easier way understanding different data structures (each has diffeent advantages/disadvantages).

## exercise

Which comparison categories are in the following situations?

- points by the sum of their X, Y coordinates
- files by their size
- files by their paths
- files by their directories
- users by their ID
- people by their birth date
- people by their living place
- game results by the score of each player

<details>
<summary>answers</summary>
<p markdown="block">

- weak ordering (points 3,5 and 4,4 are equal) OR partial ordering if we consider that the sum might be outside integer range
- weak ordering (files with same size can be different)
- weak equality (symlinks can create multiple paths for the same file)
- partial ordering (files may not have common parent directory) - this example is similar to persons in family trees
- strong equality (IDs are unique) OR strong ordering if IDs are treated as numbers
- weak ordering (date can be the same for different people)
- weak equality (the same place can be inhabited by more than 1 person)
- weak ordering (the same score can be achieved by multiple players)
</p>
</details>
