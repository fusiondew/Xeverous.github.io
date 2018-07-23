---
layout: article
---

You can build aggregate classes by composing them from multiple objects, which themselves can be classes. This forms **has-a** relationship. The enclosing class **has** some members.

Inheritance represents **is-a** relationship. The **child** class **is also** a **parent** class. The **derived** type **is also** a **base** type.

## example

Suppose there is a shop which sells products of multiple *types*. All products share few common properties (price, name, amount in stock, etc).

```c++
class book
{
private:
    // common properties
    std::string name;
    int price;
    int in_stock;

    // book-specific
    int isbn;
    std::string title;
    std::string authors;
    int issue_year;

public:
    // getters, setters, ctor(s) etc
};

class magazine
{
private:
    // common properties
    std::string name;
    int price;
    int in_stock;

    // magazine-specific
    std::string title;
    int issue_year;
    int issue_month;

public:
    // getters, setters, ctor(s) etc
};
```

It turns out that a lof of setters and getters for both book and magazine would look the same. Duplicated code is a very bad thing. Second thing - since each type is different we can not have `std::vector` that could hold any product. Processing objects would also cause problems because we would need to write separate function for each type.

We can try to solve this problem by creating product type which contains common members:

```c++
class product
{
private:
    std::string name;
    int price;
    int in_stock;

public:
    // getters, setters, ctor(s) etc
};
```

and embedding it into the actual products:

```c++
class book
{
private:
    product product_info;

    // book-specific
    int isbn;
    std::string title;
    std::string authors;
    int issue_year;

public:
    // getters, setters, ctor(s) etc
};

class magazine
{
private:
    product product_info;

    // magazine-specific
    std::string title;
    int issue_year;
    int issue_month;

public:
    // getters, setters, ctor(s) etc
};
```

This time the structure is even deeper (class `book` holds object of class `product` which holds objects of class `std::string`...) and we are back with the same problem. Another constructor to write, book/magazine getters now need to call product getters (and product would call string getters...) and we again end up duplicating code.

It would be nice if there was some way to automatically inherit all necessary functions...

## inheritance - syntax

TODO HTML inheritance syntax

The class from which you inherit is the **base type** (**parent**). The newly formed class is **derived type** (**child**) (sometimes named **descendant**).

Derived types **inherit all of parent type members**. This causes derived types object representation in memory to consist both of members of the parent class and additional members of derived class. The offset between members is implementation-defined.

## back to the example

```c++
class product
{
protected: // <-- protected!
    std::string name;
    int price;
    int in_stock;

public:
    // getters, setters, ctor(s) etc
};

class book : public product // public inheritance
{
private:
    // only book-specific
    int isbn;
    std::string title;
    std::string authors;
    int issue_year;

public:
    // getters, setters, ctor(s) etc
};

class magazine : public product // public inheritance
{
private:
    // only magazine-specific
    std::string title;
    int issue_year;
    int issue_month;

public:
    // getters, setters, ctor(s) etc
};
```

Now both `book` and `magazine` will **inherit** all of parent class members. This means that we do not need to write name, price, stock getters for derived types - they have been inherited from the `product` class.

## terminology

We can say that `book` and `magazine` are **child** classes of class `product` (which is the **parent** class).

We can say that `book` and `magazine` are types **derived** from `product` **base** type.

We can say that `book` and `magazine` are `product`s.

## protected access

Example above uses `protected` access. If a member is `public`, then there are no restrictions. If a member is `private`, only the enclosing class can access it. `protected` is between `public` and `private` - it restricts the access like `private`, but allows derived types to also access the member (`private` would not - see table below).

If `product` used `private` for name/price/stock variables, `book` and `magazine` could not access them (but might still call `public` getters).

## access when inheriting

Example above uses pulic inheritance. When inheriting, acess specifiers may change access to elements from base class.

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>access in parent</th>
                <th>access in child derived as public</th>
                <th>access in child derived as protected</th>
                <th>access in child derived as private</th>
            </tr>
            <tr>
                <td>public</td>
                <td>public</td>
                <td>protected</td>
                <td>private</td>
            </tr>
            <tr>
                <td>protected</td>
                <td>protected</td>
                <td>protected</td>
                <td>private</td>
            </tr>
            <tr>
                <td>private</td>
                <td>(no access)</td>
                <td>(no access)</td>
                <td>(no access)</td>
            </tr>
        </tbody>
    </table>
</div>

Conclusions:

- private members of the parent class are never accessible in child classes
- public inheritance does not affect access to members from parent
- protected and private inheritance restrict base member access to their level

**public inheritance**

In >99% of cases, you will use public inheritance. It doesn't change anything and defines derived type as just extension to base. Everything in base type is left as-is.

**non-public inheritance**

The other 2 ways of inheritance restrict public members from base to private/protected access. Since it affects all members, this also makes getters/setters unavailable outside and constructors become private/protected which pretty much kills the possibility to use an object of derived type in most scenarios.

Non-public inheritance has some niche uses (very often combined with templates) but it's not the typical object-oriented programming as one might say. Many languages do not even offer that type of inheritance - other languages have "just inheritance" (only 1 keyword instead of 3) and it works like the C++ public inheritance. Private and protected inheritance are C++ specific.

**examples**

All of typical polymorphism examples will use public inheritance. Almost all (if not all) design patters will use only public inheritance.

For meaningful uses of protected/private inheritance, you will need to dive into templates tutorial. These will use features which exist only in C++ or very few languages.

## constructing base type

Constructors are inevitable: if you don't use base class constructor in member initializer list, it will automatically call default 0-argument one. If it doesn't exist - compilation error.

TODO std::move in ctor?

```c++
book::book(int isbn, std::string title, std::string authors, int issue_year)
    // requires 0-argument constructor of product
    : isbn(isbn), title(std::move(title)), authors(std::move(authors)), issue_year(issue_year)
{
}
```

You know that you can initialize (construct) any member in the initializer list. But what if the parent class has no default constructor? It's not a named member but some type. The solution is simple - just call it like a function - using type name instead of variable name.

```c++
book::book(
    std::string name,
    int price,
    int in_stock,
    int isbn,
    std::string title,
    std::string authors,
    int issue_year)
    : product(std::move(name), price, in_stock), // calling base type ctor like a function
    isbn(isbn), title(std::move(title)), authors(std::move(authors)), issue_year(issue_year)
{
}
```

## upward casts

Now, what's the amazing consequence of this **is-a** relationship?

TODO def block

Pointers (and references) to derived types can be implicitly cast to base types.

Imagine a situation where you need to calculate the total cost for some product:

```c++
// 'discount' as % in range [0, 1] (eg: 0.0 - no bargain, 0.3 - 30% bargain)
int calculate_total_cost(const product& p, int quantity, double discount)
{
    return p.get_price() * quantity * (1.0 - discount);
}
```

It turns out that **the function above does not only accept `product` objects, it will also accept any object of type that is derived from `product`**!

How it works for `product`: it's the expected type. Const reference under the hood is a pointer and the compiler just adds the offset to the pointer for first member, then larger offset for the second, even larger for third member and so on.

How it works for derived types: the same way. We don't care about additional members since they are after* the base members in memory. Function needs only `product` object and is not aware that there might be something more at further offset.

**after:** The C++ standard does not actually mandate any strict order for members. Only states that consecutive members with the same access restriction are next to each other (with possible padding) in the same order as their declaration. Still, I haven't seen any compiler that for classes `A`, `B`, `C` with N members each with various accesses would place their members in memory in a different layout than a1, a2, b1, b2, c1, ...

Second thing, as far as the tutorial is concerned it's intuitive to think of consecutive members like they occupy consecutive blocks in memory.

<div class="note warning">
For the above function to work, it must take (const) reference or a (const) pointer to the product type. If you pass by copy, bad thing will happen (not necessarily UB but it's still bad) which is <strong>object slicing</strong>. It's discussed in further lessons.
</div>

## upward cast example

<div class="note warning">
You might want to experiment with the following example and come with an idea to put different types of products (books, magazines or even your classes derived from `product`) into one `std::vector&lt;product>`.

Don't do it; at least now. It will cause <strong>object slicing</strong>. You will learn why and how to do it properly in polymorphism chapter.
</div>

TODO write full example

Typical function that takes base type (here: `product`) by reference. It also accepts any derived type. Also note the order of construction and destruction - parents are constructed first, then derived types. Destruction - in reverse order.

## downward casts

Sometimes you might want to do the reverse:

```c++
int calculate_total_cost(const product& p, int quantity)
{
    const double book_discount = 0.4;
    const double magazine_discount = 0.3;

    if ( /* p is a book */ )
        return p.get_price() * quantity * (1.0 - book_discount);
    else if ( /* p is a magazine */ )
        return p.get_price() * quantity * (1.0 - magazine_discount);
    else
        // ...
}
```

It's not that simple. The function takes a reference to `product` - it doesn't know whether passed object is of some derived type - in other words, whether the passed object contains more members than the ones from `product`.

We could add an enumeration to product type which would be set in derived types constructors differently and then query that enumeration. That would be a sort of manual RTTI - it would work but it's not the best thing to do. What is RTTI (and it's uses) - of course, later. Just remember that casting downwards is usually a code smell.
