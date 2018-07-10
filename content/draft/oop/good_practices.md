
## good practices

This lesson showcases full code samples demonstrating accessors and conventions when writing object-oriented code. One thing is not an OOP problem, it's related to floating-point math.

The only very new thing here is `static` keyword. Rest is just presentation of multiple good practices when writing code.

```c++
#include <iostream>

class triangle
{
public:
    void set_side(double value);
    void set_height(double value);
    double get_area() const;

private:
    static bool is_valid(double value); // (1) static

    // (2) member variables
    double m_side;
    double m_height;
};

void triangle::set_side(double value)
{
    if (!is_valid(value)) // (3) private methods
    {
        std::cout << "error: side must be positive\n";
        return;
    }

    m_side = value;
}

void triangle::set_height(double value)
{
    if (!is_valid(value))
    {
        std::cout << "error: height must be positive\n";
        return;
    }

    m_height = value;
}

double triangle::get_area() const
{
    return m_side * m_height / 2.0;
}

bool triangle::is_valid(double value)
{
    return value > 0.0; // (4) floating-point problem
}

int main()
{
    triangle t;
    t.set_side(-1); // prints error (length must be positive)
    t.set_side(10);
    t.set_height(5);

    std::cout << t.get_area() << "\n";

    t.set_height(3);

    std::cout << t.get_area() << "\n";
}
```

### static

`is_valid` is a static function. `static` means that this function is not actually tied to any object.

Static functions are global functions inside class scope. Static functions do not have hidden `this` parameter. This means you don't need any object to call them - if you make it public you can just write `triangle::is_valid(-1)`.

**2:**

**3:**


**4:** If implementation does not support non-numeric values (NaNs, infinities) there is no problem. If it does, the comparison should yield false if implementation satisfies IEEE-754 standard (floating-point math). So far all implementations that offer NaNs and infinities do satisfy IEEE-754 so the code is safe. There is a trait to check it - [`is_iec559`](https://en.cppreference.com/w/cpp/types/numeric_limits/is_iec559).
