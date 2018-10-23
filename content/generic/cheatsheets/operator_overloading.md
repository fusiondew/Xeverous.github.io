---
layout: article
---

## operator overloading

Scroll down for explanation and more details.

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>precendence</th>
                <th>operator</th>
                <th>name</th>
                <th>arity</th>
                <th>associativity</th>
                <th>overloading</th>
                <th>notes</th>
            </tr>
            <tr>
                <td>1</td>
                <td>::a, a::b</td>
                <td>scope resolution</td>
                <td>1, 2</td>
                <td>LtR</td>
                <td>not allowed</td>
                <td></td>
            </tr>
            <tr class="even">
                <td rowspan="7">2</td>
                <td>a++</td>
                <td>postincrement</td>
                <td rowspan="2">1</td>
                <td rowspan="2">LtR</td>
                <td rowspan="2">must be member</td>
                <td></td>
            </tr>
            <tr>
                <td>a--</td>
                <td>postdecrement</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>T(), T{}</td>
                <td>functional cast</td>
                <td>1</td>
                <td>LtR</td>
                <td>must be member</td>
                <td>also overloads some C-style casts</td>
            </tr>
            <tr>
                <td>a()</td>
                <td>function call</td>
                <td>1+</td>
                <td>LtR</td>
                <td>must be member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a[b]</td>
                <td>subscript</td>
                <td>2</td>
                <td>LtR</td>
                <td>must be member</td>
                <td></td>
            </tr>
            <tr>
                <td>a.b</td>
                <td>dot</td>
                <td rowspan="2">1</td>
                <td rowspan="2">LtR</td>
                <td>not allowed</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a->b</td>
                <td>arrow</td>
                <td>must be member</td>
                <td>works recursively; must return pointer type</td>
            </tr>
            <tr>
                <td rowspan="12">3</td>
                <td>++a</td>
                <td>preincrement</td>
                <td rowspan="2">1</td>
                <td rowspan="2">RtL</td>
                <td rowspan="2">must be member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>--a</td>
                <td>predecrement</td>
                <td></td>
            </tr>
            <tr>
                <td>+a</td>
                <td>unary plus</td>
                <td rowspan="2">1</td>
                <td rowspan="2">RtL</td>
                <td rowspan="2">must be member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>-a</td>
                <td>unary minus</td>
                <td></td>
            </tr>
            <tr>
                <td>!</td>
                <td>logical NOT</td>
                <td>1</td>
                <td>RtL</td>
                <td>must be member</td>
                <td>commonly overloaded together with operator bool</td>
            </tr>
            <tr class="even">
                <td>~</td>
                <td>bitwise NOT</td>
                <td>1</td>
                <td>RtL</td>
                <td>must be member</td>
                <td></td>
            </tr>
            <tr>
                <td>(T)</td>
                <td>C-style cast</td>
                <td>1</td>
                <td>RtL</td>
                <td>must be member</td>
                <td>discouraged to use (use functional cast instead)</td>
            </tr>
            <tr class="even">
                <td>*a</td>
                <td>dereference</td>
                <td>1</td>
                <td>RtL</td>
                <td>must be member</td>
                <td></td>
            </tr>
            <tr>
                <td>&amp;a</td>
                <td>address of</td>
                <td>1</td>
                <td>RtL</td>
                <td>must be member</td>
                <td>discouraged to overload</td>
            </tr>
            <tr class="even">
                <td>sizeof a, sizeof(a)</td>
                <td>size of</td>
                <td>1</td>
                <td>RtL</td>
                <td>not allowed</td>
                <td></td>
            </tr>
            <tr>
                <td>new, new[]</td>
                <td>dynamic memory allocation</td>
                <td>?</td>
                <td rowspan="2">RtL</td>
                <td rowspan="2">member/non-member have different purpose</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>delete, delete[]</td>
                <td>dynamic memory deallocation</td>
                <td>?</td>
                <td></td>
            </tr>
            <tr>
                <td rowspan="2">4</td>
                <td>.*</td>
                <td>?</td>
                <td>?</td>
                <td rowspan="2">LtR</td>
                <td>not allowed</td>
                <td rowspan="2">rarely used</td>
            </tr>
            <tr class="even">
                <td>->*</td>
                <td>pointer to member</td>
                <td>?</td>
                <td>must be member</td>
            </tr>
            <tr>
                <td rowspan="3">5</td>
                <td>a * b</td>
                <td>multiplication</td>
                <td rowspan="3">2</td>
                <td rowspan="3">LtR</td>
                <td rowspan="3">prefer non-member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a / b</td>
                <td>division</td>
                <td></td>
            </tr>
            <tr>
                <td>a % b</td>
                <td>remainder</td>
                <td></td>
            </tr>
            <tr class="even">
                <td rowspan="2">6</td>
                <td>a + b</td>
                <td>addition</td>
                <td rowspan="2">2</td>
                <td rowspan="2">LtR</td>
                <td rowspan="2">prefer non-member</td>
                <td></td>
            </tr>
            <tr>
                <td>a - b</td>
                <td>subtraction</td>
                <td></td>
            </tr>
            <tr class="even">
                <td rowspan="2">7</td>
                <td>a << b</td>
                <td>bitwise left shift</td>
                <td rowspan="2">2</td>
                <td rowspan="2">LtR</td>
                <td rowspan="2">prefer non-member</td>
                <td>used for stream insertion</td>
            </tr>
            <tr>
                <td>a >> b</td>
                <td>bitwise right shift</td>
                <td>used for stream extraction</td>
            </tr>
            <tr class="even">
                <td>8</td>
                <td>a <=> b</td>
                <td>three-way comparison</td>
                <td>2</td>
                <td>LtR</td>
                <td>prefer member</td>
                <td>since C++20; must return comparison type</td>
            </tr>
            <tr>
                <td rowspan="4">9</td>
                <td>a < b</td>
                <td>less than</td>
                <td rowspan="4">2</td>
                <td rowspan="4">LtR</td>
                <td rowspan="4">prefer non-member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a <= b</td>
                <td>less than or equal</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>a > b</td>
                <td>greater than</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a >= b</td>
                <td>greater than or equal</td>
                <td></td>
            </tr>
            <tr>
                <td rowspan="2">10</td>
                <td>a == b</td>
                <td>equal</td>
                <td rowspan="2">2</td>
                <td rowspan="2">LtR</td>
                <td rowspan="2">prefer non-member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a != b</td>
                <td>not equal</td>
                <td></td>
            </tr>
            <tr>
                <td>11</td>
                <td>a &amp; b</td>
                <td>bitwise AND</td>
                <td rowspan="3">2</td>
                <td rowspan="3">LtR</td>
                <td rowspan="3">prefer non-member</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>12</td>
                <td>a ^ b</td>
                <td>bitwise XOR</td>
                <td></td>
            </tr>
            <tr>
                <td>13</td>
                <td>a | b</td>
                <td>bitwise OR</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>14</td>
                <td>a &amp;&amp; b</td>
                <td>logical AND</td>
                <td rowspan="2">2</td>
                <td rowspan="2">LtR</td>
                <td rowspan="2">prefer non-member</td>
                <td></td>
            </tr>
            <tr>
                <td>15</td>
                <td>a || b</td>
                <td>logical OR</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr class="even">
                <td rowspan="13">16</td>
                <td>a ? b : c</td>
                <td>ternary conditional</td>
                <td>3</td>
                <td>RtL</td>
                <td>not allowed</td>
                <td></td>
            </tr>
            <tr>
                <td>throw, throw a</td>
                <td>throw</td>
                <td>0, 1</td>
                <td>RtL</td>
                <td>not allowed</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a = b</td>
                <td>assignment</td>
                <td rowspan="11">2</td>
                <td rowspan="11">RtL</td>
                <td rowspan="11">prefer member</td>
                <td></td>
            </tr>
            <tr>
                <td>a += b</td>
                <td>compound assignment by sum</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a -= b</td>
                <td>compound assignment by difference</td>
                <td></td>
            </tr>
            <tr>
                <td>a *= b</td>
                <td>compound assignment by product</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a /= b</td>
                <td>compound assignment by quotient</td>
                <td></td>
            </tr>
             <tr>
                <td>a %= b</td>
                <td>compound assignment by remainder</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a <<= b</td>
                <td>compound assignment by bitwise left shift</td>
                <td></td>
            </tr>
            <tr>
                <td>a >>= b</td>
                <td>compound assignment by bitwise right shift</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a &amp;= b</td>
                <td>compound assignment by bitwise AND</td>
                <td></td>
            </tr>
            <tr>
                <td>a ^= b</td>
                <td>compound assignment by bitwise XOR</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>a |= b</td>
                <td>compound assignment by bitwise OR</td>
                <td></td>
            </tr>
            <tr>
                <td>17</td>
                <td>a, b</td>
                <td>comma</td>
                <td>2</td>
                <td>LtR</td>
                <td>prefer non-member</td>
                <td>strongly discouraged to overload</td>
            </tr>
        </tbody>
    </table>
</div>

#### terms

**precedence** - order in which operators are applied, eg. `a + b * c << d` is parsed as `(a + (b * c)) << d`. If multiple operators have the same precedence they are applied according to their associativity. In common problematic cases compilers warn about unintuitive order. In case of doubt, add parenthesis.

**arity** - number of operands. Operators in expressions such as `a.b` and `a->b` are unary because `b` does not contribute to the operator output. Functions representing such operators use only 1 object (when overloaded as member 0-argument function it's `this`). Some operators exist with multiple arities, eg binary minus: `c = b - a` and unary minus: `a = -a`.

**associativity** - order in which operators of the same precedence are applied (left to right or right to left). `+` associates LtR so expression `a + b + c + d` is parsed as `((a + b) + c) + d`. `=` associates RtL so expression `a = b = c = d` is parsed as `a = (b = (c = d))`.

### restrictions

- some operators have restrictions for their return type (see details)
- new operators eg `%%` or `<-` can not be created
- arity of operators can not be changed
- some operators lose short-circuit evaluation when overloaded
- at least one of operands must be a user-defined type (class or enumeration type) - it's not allowed to redefine built-in operators

## syntax and recommendation

`@` is used as a placeholder for operator and `T` for type.

### common binary operators

For operators in expressions `a @ b` the signature is as follows:

```c++
// as non-member function
T operator@(const T& lhs, const T& rhs);
// as member function
T T::operator@(const T& rhs);
```

Const reference is not required. Use pass-by-value if object is trivial to copy.

It's recommended to use

- non-member definition for operators which treat their operands in the same way (symmetric operators)
- member definition for operators which treat their operands in a different way

Example symmetric operators: `+`, `-`, `*`, `/`, `<=`

Example asymmetric operators: `+=`, `>>=`, `[]`

Rationale: operators which are overloaded as member functions do not allow implicit convertions for their first argument. This will work in expressions like `complex(1, 2) + 3` but will not compile `1 + complex(2, 3)`.

### `++` and `--`

There exist 2 versions: prefix (`++a`) and postfix (`a++`). Both must be implemented as members.

Prefix version should return by reference because it is supposed to return the same object, after modification.

Postfix version should return by value because it is supposed to return old object, before modification.

Prefix/postfix implementations are distinguished by dummy unused argument of type `int` - this is a language requirement (`T::++operator()` would create too many syntax problems).

```c++
// prefix
T& T::operator++()
{
    // <do the change here in-place>

    return *this;
}

// postfix
T T::operator++(int)
{
    T temp = *this;
    ++(*this); // reuse prefix operator
    return *temp;
}
```

### function call

This operator can be overloaded multiple times and take any number of arguments.

0-argument overload is commonly used for types that serve only 1 strict purpose - in C++ standard library used for random number distribution types and `std::hash`.

```c++
T2 T1::operator()(/* any number of arguments */) /* const (if appropriate) */
{
    /* ... */
}
```

`operator()` in external libraries is commonly overloaded for function wrappers or classes that allow multi-key (eg complex dictionares) or N-dimensional lookup (eg matrices).

Note that lambda expressions form anonymous classes which overload `operator()`.

### subscript

Most commonly used for data structures which have sort of indexing or key-based lookup.

If the data structure wants to allow to modify the returned object 2 overloads should be implemented:

```c++
const T2& T1::operator[](/* exactly 1 argument */) const
{
    /* ... */
}

T2& T1::operator[](/* exactly 1 argument */)
{
    /* ... */
}
```

If more than 1 argument is needed use `operator()` instead.

### comparisons

There is no strict requirement on the returned type but I can't of anything meaningful other than `bool`.

It's recommended to only implement `==` and `<` and reuse them for other operators.

```c++
bool operator==(const T& lhs, const T& rhs) { /* do actual comparison */ }
bool operator!=(const T& lhs, const T& rhs) { return !(lhs == rhs); }

// main implementation
bool operator< (const T& lhs, const T& rhs) { /* do actual comparison */ }
// swap order (rhs is on the left) and reuse <
bool operator> (const T& lhs, const T& rhs) { return   rhs < lhs;  }
// less-than-or-equal is not-greater-than
bool operator<=(const T& lhs, const T& rhs) { return !(lhs > rhs); }
// greater-than-or-equal is not-less-than
bool operator>=(const T& lhs, const T& rhs) { return !(lhs < rhs); }
```

<div class="note error" markdown="block">

Do not ever use `memcmp()` to implement comparison operators (even if all members are trivial types).

It's harder for compiler to optimize, can break type safety but most importantly - it can simply not work correctly! Classes can contain padding which is not guuaranteed to be zeroed - `memcmp()` would compare it too.

Where possible, compilers already optimize comparisons to this function.
</div>

**C++20 `operator<=>`**

New comparison operator simplifies implementation and allows partially/weakly ordered objects.

```c++
// inside class definition
auto operator<=>(const T& rhs) = default;
// auto will apply most feature-rich ordering
// it's possible to write own implementation (default is lexicographical)

// possible return types (can be specified explicitly):
std::strong_ordering
std::weak_ordering
std::partial_ordering
std::strong_equality
std::weak_equality
```

TODO copy table from tutorial.

For more information, examples and rationale read tutorial TODO link.

### assignment

**Types holding a resource:**

Copy assignment is expected to:

- do nothing in case of self-assignment
- do not modify source object
- perform *deep copy* of stored data
- return reference to assigned object (to allow operator chaining)

```c++
T& T::operator=(const T& other)
{
    if (this != &other)
    {
        // perform deep copy of all data
    }

    return *this;
}
```

Move assignment is expected to:

- do nothing in case of self-assignment
- never throw exceptions
- reuse (steal) other object's resources
- leave moved-from object in any valid state (invariants still satisfied)
- return reference to assigned object (to allow operator chaining)

```c++
T& T::operator=(T&& other) noexcept
{
    if (this != &other)
    {
        // acquire other object's resources
        // detach resources from other
    }

    return *this;
}
```

It may seem strange to ever write self-assignments in code (`a = a`) but it may happen unnoticed through various indirections: `v[x] = v[y]`.

**Types not holding a resource:**

If move assignment can not benefit from resource reuse both copy and move assignment can be implemented as one function which takes argument by value.

```c++
T& T::operator=(T other) noexcept
{
    // <swap resources between *this and other>

    return *this;
}
```

This form prohibits resource reuse but provides *strong exception guuarantee*.

### stream insertion and extraction

Canonical implementation uses standard stream types as left operands:

```c++
// stream insertion
std::ostream& operator<<(std::ostream& os, const T& obj)
{
    // <write obj to stream>

    return os;
}

// stream extraction
std::istream& operator>>(std::istream& is, T& obj)
{
    // <read data from is and modify obj>

    if (/* reading error */)
        is.setstate(std::ios::failbit);

    return is;
}
```

### custom type convertions

Sometimes it's desirable to allow specific custom convertions. It's done by overloading `operator T()`.

It's recommended to make custom convertions `explicit`.

```c++
class fraction
{
public:
    explicit operator double() const { return num / den; }
private:
    // ...
};

auto d = static_cast<double>(fraction(3, 4));
```