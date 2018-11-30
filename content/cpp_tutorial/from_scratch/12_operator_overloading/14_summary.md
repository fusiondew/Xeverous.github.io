---
layout: article
---

Operator overloading is a powerful feature but can be easily abused. In practice operators are rarely overloaded and if so, it's usually just `=`.

If a type overloads some, it should have clear semantics. If there is any doubt, ordinary named functions should be used instead.

Common conventons:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>type description</th>
                <th>overloaded operators</th>
                <th>purpose</th>
                <th>standard library</th>
            </tr>
            <tr>
                <td>someting arithmetic (time, date, complex number, matrix)</td>
                <td>+ - * / % += -= *= /= %=</td>
                <td>encapsulate math, syntax sugar</td>
                <td>std::complex, std::chrono:: types</td>
            </tr>
            <tr>
                <td>someting modelling multiple states, flags</td>
                <td>& | ^ &= |= ^=</td>
                <td>encapsulate math, syntax sugar</td>
                <td>std::byte (models bits in a byte)</td>
            </tr>
            <tr>
                <td>type that models valid/invalid state</td>
                <td>bool, !</td>
                <td>encapsulate checking, syntax sugar for control flow keywords</td>
                <td>std::optional, any std::*stream</td>
            </tr>
            <tr>
                <td>type that offers data insertion/extraction</td>
                <td>&lt;&lt; &gt;&gt;</td>
                <td>syntax sugar for data insertion/extraction</td>
                <td>any std::*stream</td>
            </tr>
            <tr>
                <td>container with indexed access</td>
                <td>[]</td>
                <td>syntax sugar</td>
                <td>std::array, std::vector, std::deque, std::map, std::unordered_map</td>
            </tr>
            <tr>
                <td>functor</td>
                <td>()</td>
                <td>syntax sugar</td>
                <td>stuff from &lt;functional&gt;</td>
            </tr>
            <tr>
                <td>iterator</td>
                <td>* -></td>
                <td>uniform interface regardless of data layout in the container</td>
                <td>supplied by any container</td>
            </tr>
            <tr>
                <td>smart pointer</td>
                <td>* -></td>
                <td>syntax sugar</td>
                <td>std::unique_ptr, std::shared_ptr</td>
            </tr>
        </tbody>
    </table>
</div>

## arguments and return types

- Some overloaded operators need to take objects by non-const reference (stream insertion/extraction) in order to modify them.
- Operators which do not need to modify objects should take arguments either by const reference or by copy (depending on which is cheaper).
- Operators that want to allow chaining should return their left operand by reference.

## other notes

- Operator implementations should minimize code by reusing other operators:
  - postfix can reuse prefix
  - compound assignments can reuse arithmetic operators
  - `operator!` can reuse `operator bool`
