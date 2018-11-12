---
layout: article
---

*This article has been inspired by [CppCon 2018: Richard Powell “How to Argue(ment)"](https://www.youtube.com/watch?v=ZbVCGCy3mGQ)*.

There has been a lot of confusion on C++ type system regarding passing arguments to functions. There are so many possibilities that many do not understand what are the conventions and how they deal with lifetime or performance.

**Prerequirements:**
- RAII and smart pointers
- `std::optional`

## passing arguments

### copy vs const copy

```c++
void func(T);
void func(const T);
```

As far as only the caller is concerned, there is no difference. Compiler treats both as the same overload.

The const form can be used in a source file to avoid some mistakes, but besides this there is no benefit. In the header it has no special meaning and this is why most people never use the second form.

### copy vs reference

The simplest overload we can write is to simply copy.

Const lvalue references have similar effect for the function except they optimize the call mechanism to use pointers to avoid potentially expensive copies.

```c++
void func(T);
void func(const T&);
```

This mechanism is really helpful for objects that are heavy, especially if they perform memory allocation.

But it does not work well for trivial types. Look at a simple call:

```c++
void foo();

int func(int val)
{
	if (val > 0)
		foo();

	return val;
}
```

```asm
func(int):
        test    edi, edi
        push    rbx
        mov     ebx, edi
        jle     .L2
        call    foo()
.L2:
        mov     eax, ebx
        pop     rbx
        ret
```

The compiler tests the variable and then jumps over the call if it is not needed. In both cases, function returns the passed value.

Now with a reference:

```c++
void foo();

int func(const int& val) // only this changed
{
	if (val > 0)
		foo();

	return val;
}
```

```asm
func(int const&):
        mov     eax, DWORD PTR [rdi] ; dereference
        test    eax, eax
        jle     .L4
        push    rbx
        mov     rbx, rdi
        call    foo()
        mov     eax, DWORD PTR [rbx] ; dereference
        pop     rbx
        ret
.L4:
        rep ret
```

Value is first dereferenced to perform the test. Then we have a surprise - if another function needs to be called, argument is dereferenced again before returning.

Why? We do not know whether the second function modifies argument. It could be like this:

```c++
int x = 0;

void foo()
{
	++x;
}

void bar()
{
	func(x);
}
```

Dereferences can be a bit expensive (cache invalidation) which makes them worse in this case.

Thus, we should copy trivial types.

<div class="note warning" markdown="block">
Some guides may wrongly recommend to pass every class type by (const) reference. This has no sense since there can be types that occupy less space than few larger arguments.

```c++
struct point { int x; int y; };

void foo(long x, long y, long z); // 3 x 8 = 24 bytes to copy
void bar1(const point& p); // bad: loses low-cost-copy optimization
void bar2(point p);        // good: 2 x 4 = 8 bytes to copy
```
</div>

The note above raises a question: *what is the minimal size of an object to be worth not to copy and access by reference?*

There is no universal answer. It depends on the platform architecture, what the function does and how often it is called. As with all performance questions: **test both and measure**.

### pointer to const

```c++
void func(const T*);
```

This is basically the same as with reference to const, with the only difference that users can potentially pass null pointers. The function then should have a special behaviour when no object is given.

### pointer to non-const vs non-const lvalue reference

```c++
void func(T*);
void func(T&);
```

Both do the same at the machine level, but in C++ a pointer expresses the opportunity to pass no object. References were created to express that something can never be null and this is the case here too.

Second overloads expresses "give me an object I can modify" but first "you may give me an object I can modify".

Use the second overload if wanting a modifiable object. Any user of such overload will then know that they need to pass something with lifetime - lvalue references to non-const do not accept temporaries (rvalues).

The first overload expresses it has some special behaviour for no object. Do not use this overload for out parameters.

### non-const rvalue reference vs const rvalue reference

```c++
void func(T&&);
void func(const T&&);
```

The first overload expresses that it wants to take ownership (steal) resources from the passed object. That object should then not be used after the call or recounstructed/reassigned before reuse.

Second overload pretty much contradicts itself. We use rvalue references to move resources and const to express that no changes can be made. One blocks another. This overload has no sense apart from very rare cases in template metaprogramming.

### pointer vs optional

```c++
void func(T*);
void func(std::optional<T>);
```

Both express that the caller does not have to provide an object, but do it differently.

The first one is more generic and applicable to any type.

The second one allows low-cost-copy optimization - worth for lightweight types.

Use the first one by default and switch to optional if the type is cheap to copy.

### non-const reference to pointer

```c++
void func(T*&);
void func(const T*&);
```

This is weird. You give the callee a pointer and ability to reassign it? Why would you want this? What if the pointer is null? What would that mean about the lifetime?

There is no sense in passing references to pointers, apart from rare cases when implementing allocators.

### const lvalue reference to pointer

```c++
void func(      T* const&);
void func(const T* const&);
```

This does not make any sense. Const reference has the same semantics as a copy but is more complex for the machine. Just copy pointers instead.

### rvalue reference to pointer

```c++
void func(T*&&);
void func(const T*&&);
```

Pointers are not resources. You can not move a primitive type, only copy it - overloads above are nonsensical.

### unique pointer

```c++
void func(std::unique_ptr<T>);
void func(std::unique_ptr<const T>);
```

This clearly expresses passing ownership. Unique pointer is non-copyable so only move or "sink" operations are allowed.

Use it to express that you want to take the ownership of a unique resource.

### const lvalue reference to unique pointer

```c++
void func(std::unique_ptr<T> const&);
void func(std::unique_ptr<const T> const&);
```

The same as with const references to raw pointers - nonsense. If you would like to pass objects around that are managed by smart pointers, use just reference. Users of the function should not care how object's lifetime is managed and you should not limit the interface - someone might want to pass an automatic object.

### rvalue reference to unique pointer

```c++
void func(std::unique_ptr<T>&&);
void func(std::unique_ptr<const T>&&);
```

Same as with rvalues to raw pointers. Unique pointer already has to be passed by rvalue, no sense in this explicit form.

### shared pointer

```c++
void func(std::shared_ptr<T>);
void func(std::shared_ptr<const T>);
```

Clearly expresses sharing ownership. When the function starts, it copies the smart pointer somewhere else effectively increasing the number of object users.

### const reference to shared pointer

```c++
void func(std::shared_ptr<T> const&);
void func(std::shared_ptr<const T> const&);
```

This might seem nonsensical in the first place (why not just take object by reference) but might be used to express that the function might or might not share ownership. Likely in the function body there is some condition where on one branch it performs actual shared pointer copy.

Still, I would question these overloads and benchmark first if they make any difference from shared pointer copy.

### rvalue reference to shared pointer

```c++
void func(std::shared_ptr<T>&&);
void func(std::shared_ptr<const T>&&);
```

As with rvalue references to unique pointers - nonsense. We can not move the pointer itself (only resources it manages) and should copy the smart pointer instead.

### non-const lvalue reference to smart pointer

```c++
void func(std::unique_ptr<T>&);
void func(std::unique_ptr<const T>&);
void func(std::shared_ptr<T>&);
void func(std::shared_ptr<const T>&);
```

Expresses reassigning resources. Not bad, but very rarely used.

## summary

- passing read-only lightweight objects
  - always want it: `T`
  - object is optional: `std::optional<T>`
- passing read-only heavy objects
  - always want it: `const T&`
  - object is optional: `const T*`
- changing state
  - as a side effect: `T&`
  - as an optional side effect: `T*`
- ownership
  - stealing resources: `T&&`
  - moving ownership: `std::unique_ptr<T>`, `std::unique_ptr<const T>`
  - sharing ownership: `std::shared_ptr<T>`, `std::shared_ptr<const T>`
  - reassigning resource:
    - `std::unique_ptr<T>&`
    - `std::unique_ptr<const T>&`
    - `std::shared_ptr<T>&`
    - `std::shared_ptr<const T>&`

Note: template-specific scenarios may use forwarding reference and/or very unusual overloads.

Advices:

- There is no universal way to classify type as lightweight or heavy, but types that perform memory allocation (eg strings and any kind of resizeable data structure) are definitely heavy
- Use raw pointers when you do want to allow null inputs
- Prefer returning to out parameters
- Do not write a function taking smart pointer if you want to just access the object - this is unnecssary interface limitation (someone might use a different lifetime mechanism) - pass by (const) reference/pointer instead
