
```c++
template <typename B, typename T, Size SZ> concept Buffer =
    Regular<T>       // T is well-behaved
    && Integer<Size> // Size can be used as an integer
    && requires (B b, Size i) -> { {b[i]} -> T&; };
```
