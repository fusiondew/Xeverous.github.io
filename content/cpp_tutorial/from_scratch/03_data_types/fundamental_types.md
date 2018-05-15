---
layout: article
---

So far there were used only `int`ergers. Time to get more info about what fundamental types C++ provides and how they map to actual bits in the hardware.

### The void type

`void` is a type that has no possible values. It's a keyword indicating absence of data. You can't have variables of type `void` but it can be used in other contexts.

<details>
    <summary>Technicals</summary>
    <p>`void` is an incomplete type that can not be completed.
    
- a function can return `void` - in other words, such function does not return any data
- there are no references to `void`
- there are no arrays of `void`
- pointers to `void` are allowed</p>
</details>

### The boolean type

`bool` is a type capable of holding only 2 values: `false` and `true`. It's an equivalent to logic statements in math.

`bool` can also be viewed as a representation of a single bit (0 or 1), although it often occupies full byte (8 bits) or more memory - this is because in typical Von-Neumann architecture memory is addressed by bytes, not bits. Still, at the C++ language level `bool` can hold only 2 values.

### integers

TODO make more newbie-friendly (mb spoiler too mch technicals).

`int` is the most basic type. It represents a whole number in the most natural form for the target architecture.

**storage**

Integers are stored in certain amount of bytes - this means that they have finite amount of bits and therefore they have bounds - you can't represent all possible numbers in them!

In decimal system, if you are given 3 digit space, you can't go beyond 999. Similarly, in the binary system, if you are given 10 digits, you can't go beyond 1111111111 (which is 1023). Any larger number would require more digits.

`int` can be surrounded by specific other keywords which modify the size and encoding. This can be used to change the possible value range and modify how it's interpreted.

The exact size of an integer is architecture dependent, but there are many strong guarantees.

Because plain binary numbers represent sums of consecutive powers of 2 (1, 2, 4, 8, 16, ...) there is no built-in way to represent negative numbers. Representations which allow this are named *signed representations*, they usually do this by treating first bit as +/- sign and flipped representation.

**encoding**

`unsigned` - the integer is in it's simplest form, the underlying bits are treated with no modification (each more left-side bit is a bigger power of 2).

`signed` - integer sacrifices one bit for the +/- sign. This makes possible value range smaller, but allows values to be treated as negative. There are multiple signed integer encodings (difering by the place of sign bit and other rules). Most (if not all) architectures use two's complement.

See [this article](https://en.wikipedia.org/wiki/Signed_number_representations) for more information.

#### examples:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>bits</th>
                <th>interpreted as unsigned</th>
                <th>interpreted as signed in two's complement</th>
            </tr>
            <tr>
                <td>00000000</td>
                <td>0</td>
                <td>0</td>
            </tr>
            <tr>
                <td>00000001</td>
                <td>1</td>
                <td>1</td>
            </tr>
            <tr>
                <td>00000010</td>
                <td>2</td>
                <td>2</td>
            </tr>
           <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
            <tr>
                <td>01111110</td>
                <td>126</td>
                <td>126</td>
            </tr>
            <tr>
                <td>01111111</td>
                <td>127</td>
                <td>127</td>
            </tr>
            <tr>
                <td>10000000</td>
                <td>128</td>
                <td>-128</td>
            </tr>
            <tr>
                <td>10000001</td>
                <td>129</td>
                <td>-127</td>
            </tr>
            <tr>
                <td>10000010</td>
                <td>130</td>
                <td>-126</td>
            </tr>
           <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
            <tr>
                <td>11111101</td>
                <td>253</td>
                <td>-3</td>
            </tr>
            <tr>
                <td>11111110</td>
                <td>254</td>
                <td>-2</td>
            </tr>
            <tr>
                <td>11111111</td>
                <td>255</td>
                <td>-1</td>
            </tr>
        </tbody>
    </table>
</div>

From the table above you can see that unsigned integer has value range [0, 255] and signed integer has value range [-128, 127]. Negative numbers have flipped bits and are in reverse order.

#### More examples:

```
16-bit unsigned int representing decimal   2925: 0000 1011 0110 1101     (0)
16-bit signed   int representing decimal   2925: 0000 1011 0110 1101     (0)
16-bit unsigned int representing decimal  -2925: impossible to represent (1)
16-bit signed   int representing decimal  -2925: 1111 0100 1001 0011     (2)
16-bit unsigned int representing decimal 48 522: 1011 1101 1000 1010     (3)
16-bit signed   int representing decimal 48 522: impossible to represent (4)
```

- (0) The first 2 numbers are relatively small, and fit in both representations
- (1) -2925 (and all other negative numbers) can not be represented as unsigned integers, as there is no bit that would indicate +/- sign - all numbers are assumed to be non-negative.
- (2) the first bit is `1` which indicates that the number is negative, rest bits (`111 0100 1001 0011`) are two's completement representation - in this representation positive numbers look the same but negative numbers have bits flipped and added 1 to the last bit - compare (2) to (0)
- (3) the number is represented normally
- (4) the number can not be represented because the value itself needs 16 bits, but signed representation sacrifices 1 bit for +/- sign

The default representation is signed. This means that `int` is the same type as `signed int`.


