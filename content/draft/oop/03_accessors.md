

The `triangle` class has 2 setters and 1 getter. We can add more getters in case someone wants to get the side and height back:

```c++
// inside class
    double get_side() const;
    double get_height() const;

// outisde class
double triangle::get_side() const
{
    return side;
}

double triangle::get_height() const
{
    return height;
}
```

## different approach

We can define the triangle class in a very different way:

```c++
#include <iostream>
#include <cmath> // for std::sqrt

class triangle
{
private:
    double a;
    double b;
    double c;

    bool verify_value(double side) const;

public:
    void set_values(double new_a, double new_b, double new_c);

    double get_area() const;
    double get_perimeter() const;

    double get_height_for_a() const;
    double get_height_for_b() const;
    double get_height_for_c() const;
};

bool triangle::verify_value(double value) const
{
    if (value <= 0.0)
    {
        std::cout << "error: side value must be positive\n";
        return false;
    }

    return true;
}

void triangle::set_values(double new_a, double new_b, double new_c)
{
    if (!verify_value(new_a))
        return;

    if (!verify_value(new_b))
        return;

    if (!verify_value(new_c))
        return;

    a = new_a;
    b = new_b;
    c = new_c;
}

double triangle::get_perimeter() const
{
    return a + b + c;
}

double triangle::get_area() const
{
    const double s = get_perimeter() / 2.0;
    return std::sqrt(s * (s - a) * (s - b) * (s - c));
}

double triangle::get_height_for_a() const
{
    return get_area() / a * 2.0;
}

double triangle::get_height_for_b() const
{
    return get_area() / b * 2.0;
}

double triangle::get_height_for_c() const
{
    return get_area() / c * 2.0;
}

int main()
{
    triangle t;
    t.set_values(3, 4, 5);

    std::cout << "perimeter: " << t.get_perimeter() << "\n";
    std::cout << "area     : " << t.get_area() << "\n";
    std::cout << "heights  : " << t.get_height_for_a() << ", " << t.get_height_for_b() << ", " << t.get_height_for_c() << "\n";
}
```

Instead of storing side and height we store lengths of each side. This allows us to provide more functionality - such as calculating perimeter.

We can still calculate the area by using [Heron's formula](https://en.wikipedia.org/wiki/Heron%27s_formula):

$$
s = \frac{a + b + c}{2} \\
A = \sqrt{s(s - a)(s - b)(s - c)}
$$

The code is reused - `get_perimeter` is called inside `get_area` to avoid duplicated math. Note that inside `get_area` `get_perimeter` is called without `.` - the code is inside member function - it's calling this method on the object itself.

`get_height_for_` functions allow to calculate heights for respective sides thanks to the area - since $A = \frac{ah}{2}$, $h = \frac{A}{h} * 2$. This is done for each side. These functions showcase even larger code reuse - they call `get_area` which in turn calls `get_perimeter`. 

Additionally, there is a private function used to validate the input - it's private because we do not want to use it from the outside, only from inside other methods.

The class setter prevents from violating each side invariant but it does not check for triangle's invariant - we can not set -1, -2, -3 but we can set values 1, 2, 10 and they will be accepted but such triangle can not exist.

## exercise

Add more methods to the triangle class to check all triangle's invariants. Make sure it's not possible to set invalid values such as 1, 2, 10 or 2, 4, 100.
