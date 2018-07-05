---
layout: article
---

.

```c
// some extreme case
int (*(*foo)(void))[3]; // define pointer to function (void) returning pointer to an array of 3 ints
//^  ^              ^ these are parts of the type "pointer to array of 3 ints"
```

{% comment %}
{% capture includeGuts %}
{% include signup-guts.html %}
{% endcapture %}
{{ includeGuts | replace: '    ', ''}}
{% endcomment %}


There are 2 hard problems in computer science: cache invalidation, naming things, and off-by-1 errors. -- Leon Bambrick
There are only two hard problems in distributed systems: 2. Exactly-once delivery 1. Guaranteed order of messages 2. Exactly-once delivery -- Mathias Verraes

for tabs-vs spaces article

```c++
bool operator<(const package& lhs, const package& rhs)
{
    return std::tie(lhs.floor, lhs.shelf, lhs.position)
         < std::tie(rhs.floor, rhs.shelf, rhs.position);
}
```

backwards compatibility articles

```
void f(char * p)
{
  if (p > 0) { ... } // OK in C++98..C++11, does not compile in C++14
  if (p > nullptr) { ... } // OK in C++11, does not compile in C++14
}
```