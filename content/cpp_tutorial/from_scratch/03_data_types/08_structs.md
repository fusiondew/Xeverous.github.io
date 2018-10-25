Structures are simply custom types that consist of built-in types or other structures.

```c++
#include <iostream>

struct point
{
    int x;
    int y;
};

struct triangle
{
    point a;
    point b;
    point c;
};

int main()
{
    point p1;
    p1.x = 5; // structure members are accessed by .
    p1.y = 7;
    point p2 = p1; // copies both members
    p2.y = 3;
    point p3;
    p3.x = 0;
    p3.y = 2;

    triangle t;
    t.a = p1;
    t.b = p2;
    t.c = p3;

    std::cout << "triangle points:\n";
    std::cout << "(" << t.a.x << ", " << t.a.y << "), ("
                     << t.b.x << ", " << t.b.y << "), ("
                     << t.c.x << ", " << t.c.y << ")\n";
}
```

Structures are useful to group closely related variables. Later you will learn about classes which offer a huge amount of features.
