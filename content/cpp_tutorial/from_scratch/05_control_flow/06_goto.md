---
layout: article
---

`goto` performs unconditional jumps to labels. A label is simply an identifier followed by a colon.

## example loop with goto

```c++
#include <iostream>

int main ()
{
    int n = 10;
mylabel:
    std::cout << n << ", ";
    --n;

    if (n > 0)
        goto mylabel;

    std::cout << "countdown finished\n";
}
```

`goto` is a problematic control structure due to multiple reasons:

- jumps are absolute, with no scope restrictions - you can easily break the progam by jumping out of nested scopes (jumping to different indentiation level, skipping multiple `{` or `}`)
- jumps do not cause any automatic stack unwinding - this can cause leaks and/or memory errors or uninitialized variables
- it's unclear from the reader point of view where the jump lands - the label can be anywhere - code flow is hard to understand
- the entire feature gets very messy when few jumps and labels overlap

`goto` is kept for backwards compability, but it's so bad that multiple new C++ features do not allow it to be used inside their code. Multiple programming languages do not have `goto`.

<div class="note pro-tip" markdown="block">

Don't use `goto`. Ever.
</div>

## legitimate uses

There are no legitimate uses of `goto` in C++. There are some in C (which must be used carefully) but in C++ multiple features (return statements from function/lambda, flag-based breaks, exceptions, destructors) replace any potential use of `goto`.
