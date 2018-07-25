// (using aggregate initialiation)
base b{1};         // b.foo == 1
derived d{{2}, 3}; // d.foo == 2, d.bar == 3

b = d; // b.foo == 2 now, d.bar is lost