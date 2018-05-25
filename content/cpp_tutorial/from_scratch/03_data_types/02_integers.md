---
layout: article
---

## integers

TODO make more newbie-friendly (mb spoiler too mch technicals).

`int` is the most basic type. It represents a whole number in the most natural form for the target architecture.

### storage

Integers are stored in certain amount of bytes - this means that they have finite amount of bits and therefore they have bounds - you can't represent all possible numbers in them!

In decimal system, if you are given 3 digit space, you can't go beyond 999. Similarly, in the binary system, if you are given 10 digits, you can't go beyond 1111111111 (which is 1023). Any larger number would require more digits.

`int` can be surrounded by specific other keywords which modify the size and encoding. This can be used to change the possible value range and modify how it's interpreted.

Because plain binary numbers represent sums of consecutive powers of 2 (1, 2, 4, 8, 16, ...) there is no built-in way to represent negative numbers. Representations which allow this are named *signed representations*, they usually do this by treating first bit as +/- sign and some addiional changes in intepretation.

Note that at the machine instruction level, there is notion of type - only the size. 8-bit, 16-bit, 32-bit data fields and such. It's the programmer who gives this data a meaningful interpretation.

### encoding

`unsigned` - the integer is in it's simplest form, the underlying bits are treated with no modification (each more left-side bit is a bigger power of 2).

`signed` - there are multiple variations (one's complement, two's complement, offset binary, negative base). See [this article](https://en.wikipedia.org/wiki/Signed_number_representations) for more information.

The simplest signed representations are one's/two's complement, which sacrifice first bit for +/- sign but also have shifted/reversed negative numbers order.

#### examples:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>bits</th>
                <th>interpreted as unsigned</th>
                <th>interpreted as signed in ones's complement</th>
                <th>interpreted as signed in two's complement</th>
            </tr>
            <tr>
                <td>00000000</td>
                <td>0</td>
                <td>+0</td>
                <td>0</td>
            </tr>
            <tr>
                <td>00000001</td>
                <td>1</td>
                <td>1</td>
                <td>1</td>
            </tr>
            <tr>
                <td>00000010</td>
                <td>2</td>
                <td>2</td>
                <td>2</td>
            </tr>
           <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
            <tr>
                <td>01111110</td>
                <td>126</td>
                <td>126</td>
                <td>126</td>
            </tr>
            <tr>
                <td>01111111</td>
                <td>127</td>
                <td>127</td>
                <td>127</td>
            </tr>
            <tr>
                <td>10000000</td>
                <td>128</td>
                <td>-127</td>
                <td>-128</td>
            </tr>
            <tr>
                <td>10000001</td>
                <td>129</td>
                <td>-126</td>
                <td>-127</td>
            </tr>
            <tr>
                <td>10000010</td>
                <td>130</td>
                <td>-125</td>
                <td>-126</td>
            </tr>
           <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
            <tr>
                <td>11111101</td>
                <td>253</td>
                <td>-2</td>
                <td>-3</td>
            </tr>
            <tr>
                <td>11111110</td>
                <td>254</td>
                <td>-1</td>
                <td>-2</td>
            </tr>
            <tr>
                <td>11111111</td>
                <td>255</td>
                <td>-0</td>
                <td>-1</td>
            </tr>
        </tbody>
    </table>
</div>

From the table above you can see that:

- unsigned integer has value range $\[0, 255\] \space (\[0, 2^8-1\])$
- one's complement signed integer has value range $\[-127, 127\] \space (\[-2^7+1, 2^7-1\])$; 0 has two representations
- two's complement signed integer has value range $\[-128, 127\] \space (\[-2^7, 2^7-1\])$

The reverse order of negative numbers (in both complement encodings) allows some math optimizations.

Two's complement compared to one's complement is shifted by 1 - it avoids the problem of positive and negative 0.

Most widely used architectures use two's complement for signed representation. Unsigned is treated exactly the same everywhere.

<details> 
<summary>More examples</summary>
<p markdown="block">

~~~
16-bit unsigned int representing decimal   2925: 0000 1011 0110 1101     (0)
16-bit signed   int representing decimal   2925: 0000 1011 0110 1101     (0)
16-bit unsigned int representing decimal  -2925: impossible to represent (1)
16-bit signed   int representing decimal  -2925: 1111 0100 1001 0011     (2)
16-bit unsigned int representing decimal 48 522: 1011 1101 1000 1010     (3)
16-bit signed   int representing decimal 48 522: impossible to represent (4)
~~~

- (0) The first 2 numbers are relatively small, and fit in both representations
- (1) -2925 (and all other negative numbers) can not be represented as unsigned integers, as there is no bit that would indicate +/- sign - all numbers are assumed to be non-negative.
- (2) the first bit is `1` which indicates that the number is negative, rest bits (`111 0100 1001 0011`) are two's completement representation - in this representation positive numbers look the same but negative numbers have bits flipped and added 1 to the last bit - compare (2) to (0)
- (3) the number is represented normally
- (4) the number can not be represented because the value itself needs 16 bits, but signed representation sacrifices 1 bit for +/- sign

The default representation is signed. This means that `int` is the same type as `signed int`.

</p>
</details>

### size

- `short` - makes integer occupy less bytes
- `long` - makes inteegr occupy more bytes

`long` can be used twice

The exact size of an integer is architecture and system dependent, but C++ standard guarantess minum size for each type.

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>type</th>
                <th>C++ minimum guaranteed size</th>
                <th>Actual size on x86 and x86_64</th>
            </tr>
            <tr>
                <td>char</td>
                <td>8</td>
                <td>8</td>
            </tr>
            <tr>
                <td>short int</td>
                <td>16</td>
                <td>16</td>
            </tr>
            <tr>
                <td>int</td>
                <td>16</td>
                <td>32</td>
            </tr>
            <tr>
                <td>long int</td>
                <td>32</td>
                <td>32</td>
            </tr>
            <tr>
                <td>long long int</td>
                <td>64</td>
                <td>64</td>
            </tr>
        </tbody>
    </table>
</div>

These are value ranges for integers of various lengths:

TODO table alignment

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>size (in bits)</th>
                <th>interpretation</th>
                <th>value range</th>
            </tr>
            <tr>
                <td rowspan="3">8</td>
                <td>unsigned</td>
                <td>0 - 255</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-127 - 127</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-128 - 127</td>
            </tr>
            <tr>
                <td rowspan="3">16</td>
                <td>unsigned</td>
                <td>0 - 65536</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-32767 - 32767</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-32768 - 32767</td>
            </tr>
            <tr>
                <td rowspan="3">32</td>
                <td>unsigned</td>
                <td>0 - 4'294'967'295</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-2'147'483'647 - 2'147'483'647</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-2'147'483'648 - 2'147'483'647</td>
            </tr>
            <tr>
                <td rowspan="3">64</td>
                <td>unsigned</td>
                <td>0 - 18'446'744'073'709'551'615</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-9'223'372'036'854'775'807 - 9'223'372'036'854'775'807</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-9'223'372'036'854'775'808 - 9'223'372'036'854'775'807</td>
            </tr>
        </tbody>
    </table>
</div>

### notation

keyword `int` is optional if any other keyword is used. So `unsigned` or `long` is enough, you don't have to write `unsigned int` and `long int`.

The order of applied keywords doesn't mater, but it's recommended to write intuitively - `unsigned long long`, not `long int unsigned long`.

### fixed-width integers

`<cstdint>` supplies multiple fixed-with integer types or types with strict minimal size.

The full list is available on [reference page](https://en.cppreference.com/w/cpp/types/integer).

### What you need to remember

Integers can have varying size and signess. All of them have no special notion at the hardware level - it's the programmer choice how to interpret their bits.
