---
layout: article
---

## C++ FAQ

#### Why "this" is a pointer, not a reference?

Because `this` was introduced before references have been added to the language. If references came earlier, `this` would be a reference. Relevant [SO question](https://stackoverflow.com/questions/645994/why-this-is-a-pointer-and-not-a-reference).