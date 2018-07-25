#include <iostream>

struct base { int foo; };
struct derived : base { int bar; };

int main()
{
	derived d1{{1}, 2}; // d.foo == 1, d.bar == 2
	derived d2{{3}, 4}; // d.foo == 3, d.bar == 4

	base& b_ref = d1; // bind derived object to base reference (so far good)
	b_ref = d2; // object slicing!

	std::cout << "d1.foo: " << d1.foo << "\n";
	std::cout << "d1.bar: " << d1.bar << "\n";
}