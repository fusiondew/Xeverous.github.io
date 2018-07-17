---
layout: article
---

There is a special feature which lets ignore access specifiers: friends.

Friends have access to anything, including private members.

```c++
#include <iostream>

class foo
{
private:
    int x = 3;

    friend void func(const foo& f); // this is not a member function but a friend declaration
};

void func(const foo& f)
{
    std::cout << "f.x = " << f.x << "\n"; // friends can access private and protected members
}

int main()
{
    foo f;
    func(f);
}
```
