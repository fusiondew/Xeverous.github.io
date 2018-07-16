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
    // getters, setters, etc
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
    // getters, setters, etc
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
    // getters, setters, etc
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
    // getters, setters, etc
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
    // getters, setters, etc
};
```

This time the structure is even deeper (class book holds object of class product which holds objects of class string...) and we are back with the same problem. Another constructor to write, book/magazine getters now need to call product getters (and product would call string getters...) and we again end up duplicating code.

It would be nice if there was some way to automatically inherit all necessary functions...

## inheritance - syntax

TODO HTML inheritance syntax

The class from which you inherit is the **parent type**. The newly formed class is **derived type** (sometimes named **descendant**).

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
    // getters, setters, etc
};

class book : public product
{
private:
    // only book-specific
    int isbn;
    std::string title;
    std::string authors;
    int issue_year;

public:
    // getters, setters, etc
};

class magazine : public product
{
private:
    // only magazine-specific
    std::string title;
    int issue_year;
    int issue_month;

public:
    // getters, setters, etc
};
```

Now both `book` and `magazine` will **inherit** all of parent class members. This means that we do not need to write name, price, etc getters for derived types - they have been inherited from the `product` class.

We can say that `book` and `magazine` are **child** classes of class `product` (which is the **parent** class).

We can say that `book` and `magazine` are types **derived** from `product` **base**.

We can say that `book` and `magazine` are `product`s.

## protected access

TODO explain access with inheritance

## constructing base type

TODO write ctor for base type example

## ???

Now, what's the amazing consequence of this **is-a** relationship?

TODO def block

Pointers (and references) to derived types can be implicitly cast to base types.

Imagine a situation where you need to calculate the total cost for some product:

```c++
// discount as % in range [0, 1] (eg: 0.0 - no bargain, 0.3 - 30% bargain)
int calculate_total_cost(const product& p, int quantity, double discount)
{
    return p.get_price() * quantity * (1.0 - discount);
}
```

It turns out that **the function above does not only accept `product` objects, it will also accept any object of type that is derived from `product`**!

## full example

TODO write full example
