---
layout: article
---

No keyword / token is required only in source files. Either header or both.

For obvious reasons some keywords / tokens can not be used together (eg. there are no static virtual functions).

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>group</th>
                <th>keyword / token</th>
                <th>requires instant definition</th>
                <th>required in source</th>
                <th>notes</th>
            </tr>
            <tr>
                <td rowspan="2">dispatch method</td>
                <td>static</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr class="even">
                <td>virtual</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>-</td>
                <td>constexpr</td>
                <td>&#10004;</td>
                <td></td>
                <td>implies inline</td>
            </tr>
            <tr class="even">
                <td>-</td>
                <td>inline</td>
                <td>&#10004;</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>-</td>
                <td>friend</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr class="even">
                <td>-</td>
                <td>explicit</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td rowspan="4">function type</td>
                <td>const</td>
                <td></td>
                <td rowspan="4">&#10004;</td>
                <td></td>
            </tr>
            <tr class="even">
                <td>volatile</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>&amp;</td>
                <td></td>
                <td></td>
            </tr>
            <tr class="even">
                <td>&amp;&amp;</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td rowspan="2">virtual function checks</td>
                <td>override</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr class="even">
                <td>final</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td rowspan="3">exception specification</td>
                <td>throw(types...)</td>
                <td></td>
                <td rowspan="3">&#10004;</td>
                <td>deprecated in C++11, removed in C++17</td>
            </tr>
            <tr class="even">
                <td>throw()</td>
                <td></td>
                <td>deprecated in C++11, removed in C++20</td>
            </tr>
            <tr>
                <td>noexcept</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr class="even">
                <td rowspan="3">definition generation</td>
                <td>= 0</td>
                <td></td>
                <td></td>
                <td>makes type abstract (definition still allowed)</td>
            </tr>
            <tr>
                <td>= default</td>
                <td></td>
                <td></td>
                <td rowspan="2">blocks definition</td>
            </tr>
            <tr class="even">
                <td>= delete</td>
                <td></td>
                <td></td>
            </tr>
        </tbody>
    </table>
</div>

All keywords / tokens in order:

```c++
// header (inside a class)
struct s {
    static constexpr inline virtual friend explicit
    T func() const volatile & && override final throw(X) noexcept = 0 = default = delete ;
};

// source
T s::func() const volatile & && throw(X) noexcept
{
    /* ... */
}
```
