---
layout: article
---

* * *

# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6

```markdown
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
```

## Preformatted Text

Below is just about everything you’ll need to style in the theme. Check the source code to see the many embedded elements within paragraphs.

Typographically, preformatted text is not the same thing as code. Sometimes, a faithful execution of the text requires preformatted text that may not have anything to do with code. Most browsers use Courier and that’s a good default — with one slight adjustment, Courier 10 Pitch over regular Courier for Linux users.

## Blockquotes

Let’s keep it simple. Italics are good to help set it off from the body text. Be sure to style the citation.

> Good afternoon, gentlemen. I am a HAL 9000 computer. I became operational at the H.A.L. plant in Urbana, Illinois on the 12th of January 1992\. My instructor was Mr. Langley, and he taught me to sing a song. If you’d like to hear it I can sing it for you. <cite>— [HAL 9000](http://en.wikipedia.org/wiki/HAL_9000)</cite>

* * *

## Text-level semantics - markdown

The [a element](#) example

The **strong element** example

The _em element_ example

The `code element` example

```markdown
The [a element](#) example
The **strong element** example
The _em element_ example
The `code element` example
```

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/

```markdown
Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
```

## Text-level semantics - HTML in markdown

The <abbr>abbr element</abbr> and <abbr title="Title text">abbr element with title</abbr> examples

The <cite>cite element</cite> example

The <del>del element</del> example

The <dfn>dfn element</dfn> and <dfn title="Title text">dfn element with title</dfn> examples

The <ins>ins element</ins> example

The <kbd>kbd element</kbd> example

The <mark>mark element</mark> example

The <q>q element <q>inside</q> a q element</q> example

The <s>s element</s> example

The <samp>samp element</samp> example

The <small>small element</small> example

The <span>span element</span> example

The <sub>sub element</sub> example

The <sup>sup element</sup> example

The <var>var element</var> example

The <u>u element</u> example

```html
The <abbr>abbr element</abbr> and <abbr title="Title text">abbr element with title</abbr> examples
The <cite>cite element</cite> example
The <del>del element</del> example
The <dfn>dfn element</dfn> and <dfn title="Title text">dfn element with title</dfn> examples
The <ins>ins element</ins> example
The <kbd>kbd element</kbd> example
The <mark>mark element</mark> example
The <q>q element <q>inside</q> a q element</q> example
The <s>s element</s> example
The <samp>samp element</samp> example
The <small>small element</small> example
The <span>span element</span> example
The <sub>sub element</sub> example
The <sup>sup element</sup> example
The <var>var element</var> example
The <u>u element</u> example
```
* * *

## List Types

### Definition List

<dl>

<dt>Definition List Title</dt>

<dd>This is a definition list division.</dd>

<dt>Definition</dt>

<dd>An exact statement or description of the nature, scope, or meaning of something: our definition of what constitutes poetry.</dd>

</dl>

```html
<dl>
    <dt>Definition List Title</dt>
    <dd>This is a definition list division.</dd>

    <dt>Definition</dt>
    <dd>An exact statement or description of the nature, scope, or meaning of something: our definition of what constitutes poetry.</dd>
</dl>
```

### Ordered List

1.  List Item 1
1.  List Item 2
    1.  Nested list item A
    1.  Nested list item B
1.  List Item 3

### Unordered List

*   List Item 1
*   List Item 2
    *   Nested list item A
    *   Nested list item B
*   List Item 3

```markdown
### Ordered List
(numbers doesn't matter)

1.  List Item 1
1.  List Item 2
    1.  Nested list item A
    1.  Nested list item B
1.  List Item 3

### Unordered List

*   List Item 1
*   List Item 2
    *   Nested list item A
    *   Nested list item B
*   List Item 3
```

* * *

## Table

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>Table Header 1</th>
                <th>Table Header 2</th>
                <th>Table Header 3</th>
            </tr>
            <tr>
                <td>Division 1</td>
                <td>Division 2</td>
                <td>Division 3</td>
            </tr>
            <tr class="even">
                <td>Division 1</td>
                <td>Division 2</td>
                <td>Division 3</td>
            </tr>
            <tr>
                <td>Division 1</td>
                <td>Division 2</td>
                <td>Division 3</td>
            </tr>
        </tbody>
    </table>
</div>

```html
<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>Table Header 1</th>
                <th>Table Header 2</th>
                <th>Table Header 3</th>
            </tr>
            <tr>
                <td>Division 1</td>
                <td>Division 2</td>
                <td>Division 3</td>
            </tr>
            <tr class="even">
                <td>Division 1</td>
                <td>Division 2</td>
                <td>Division 3</td>
            </tr>
            <tr>
                <td>Division 1</td>
                <td>Division 2</td>
                <td>Division 3</td>
            </tr>
        </tbody>
    </table>
</div>
```

Column A | Column B | Column C
:--------|:--------:|---------:
left align | middle | right align
left align | middle | right align

```markdown
Column A   | Column B |    Column C
:----------|:--------:|-----------:
left align |  middle  | right align
left aligh |  middle  | right align
```

* * *

### Code

Code can be presented inline, like `<?php bloginfo('stylesheet_url'); ?>`, or within a `<pre>` block.

CSS code

```css
#container {
    float: left;
    margin: 0 -240px 0 0;
    width: 100%;
}
```
Ruby code

```ruby
class Song
  def initialize(title, artist, album)
    @title  = name
    @artist = artist
    @album  = album
  end
end

class InstrumentalSong < Song
  def initialize(name, artist, album, lyrics)
    super(name, artist, album)
    @lyrics = lyrics
  end
end
```
### Gists via GitHub Pages

{% gist 5555251 gist.md %}

```
{% gist 5555251 gist.md %}
```

#### Custom C++ highlight

<pre class="highlight"><code><span class="prep_direct">#</span><span class="prep_direct">include</span>&nbsp;<span class="prep_hdr">&lt;execution&gt;</span>
<span class="prep_direct">#</span><span class="prep_direct">include</span>&nbsp;<span class="prep_hdr">&lt;thread&gt;</span>
<span class="prep_direct">#</span><span class="prep_direct">include</span>&nbsp;<span class="prep_hdr">&lt;string&gt;</span>
<span class="prep_direct">#</span><span class="prep_direct">include</span>&nbsp;<span class="prep_hdr">&lt;fmt&gt;</span>

<span class="comm_multi">/*</span>
<span class="comm_multi">&nbsp;*&nbsp;Disjunctions&nbsp;are&nbsp;short-circuited</span>
<span class="comm_multi">&nbsp;*&nbsp;overloaded&nbsp;operators&nbsp;can&nbsp;not&nbsp;be&nbsp;used&nbsp;in&nbsp;requires&nbsp;expressions</span>
<span class="comm_multi">&nbsp;*/</span>
<span class="keyword">template</span>&nbsp;&lt;<span class="keyword">typename</span>&nbsp;<span class="tparam">T</span>&gt;
<span class="keyword">concept</span>&nbsp;<span class="concept">MoreThanComparable</span>&nbsp;=&nbsp;<span class="keyword">requires</span>(<span class="tparam">T</span>&nbsp;<span class="param">a</span>,&nbsp;<span class="tparam">T</span>&nbsp;<span class="param">b</span>)&nbsp;||&nbsp;<span class="concept">LessThanComparable</span>
{
&#9;{&nbsp;<span class="param">a</span>&nbsp;&gt;&nbsp;<span class="param">b</span>&nbsp;}&nbsp;-&gt;&nbsp;<span class="built_in">bool</span>;&nbsp;<span class="comm_single_dox">///</span>&nbsp;<span class="comm_tag_dox">@brief</span>&nbsp;<span class="comm_single_dox">expression&nbsp;"a&nbsp;&gt;&nbsp;b"&nbsp;must&nbsp;return&nbsp;bool</span>
};

<span class="keyword">template</span>&nbsp;&lt;<span class="concept">EqualityComparable</span>...&nbsp;<span class="tparam">Args</span>&gt;&nbsp;<span class="keyword">constexpr</span>
<span class="keyword">decltype</span>(<span class="keyword">auto</span>)&nbsp;<span class="func">build</span>(<span class="tparam">Args</span>&amp;&amp;...&nbsp;<span class="param">args</span>);&nbsp;<span class="comm_single">//&nbsp;constrained&nbsp;C++20&nbsp;function&nbsp;template</span>
{
&#9;<span class="keyword">if</span>&nbsp;<span class="keyword">constexpr</span>&nbsp;(<span class="keyword">sizeof</span>...(<span class="param">args</span>)&nbsp;==&nbsp;<span class="num">0</span>)
&#9;&#9;<span class="keyword">throw</span>&nbsp;<span class="namespace">std</span>::<span class="class">logic_error</span>(<span class="namespace">std</span>::<span class="class">string</span>(<span class="string">""error&nbsp;in&nbsp;file:&nbsp;""</span>)&nbsp;<span class="op_ol">+</span>&nbsp;<span class="macro_ref">__FILE__</span>&nbsp;<span class="op_ol">+</span>&nbsp;<span class="string">""on&nbsp;line:&nbsp;""</span>&nbsp;<span class="op_ol">+</span>&nbsp;<span class="macro_ref">__LINE__</span>);

&#9;<span class="keyword">return</span>&nbsp;<span class="namespace">std</span>::<span class="class">tuple</span>(<span class="namespace">std</span>::<span class="func">forward</span>&lt;<span class="tparam">Args</span>&gt;(<span class="param">args</span>)...);
}

<span class="keyword">template</span>&nbsp;&lt;<span class="keyword">typename</span>&nbsp;<span class="tparam">T</span>&gt;
<span class="keyword">concept</span>&nbsp;<span class="concept">Opaque</span>&nbsp;=&nbsp;<span class="keyword">requires</span>(<span class="tparam">T</span>&nbsp;<span class="param">x</span>)
{
&#9;{*<span class="param">x</span>}&nbsp;-&gt;&nbsp;<span class="keyword">typename</span>&nbsp;<span class="tparam">T</span>::<span class="class">inner</span>;&nbsp;<span class="comm_single">//&nbsp;the&nbsp;expression&nbsp;*x&nbsp;must&nbsp;be&nbsp;valid</span>
&#9;<span class="comm_single">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//&nbsp;AND&nbsp;the&nbsp;type&nbsp;T::inner&nbsp;must&nbsp;be&nbsp;valid</span>
&#9;<span class="comm_single">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//&nbsp;AND&nbsp;the&nbsp;result&nbsp;of&nbsp;*x&nbsp;must&nbsp;be&nbsp;convertible&nbsp;to&nbsp;T::inner</span>
};

<span class="keyword">using</span>&nbsp;<span class="alias">cw</span>&nbsp;=&nbsp;<span class="namespace">std</span>::<span class="namespace">chrono</span>::<span class="enumerator">weekday</span>;
<span class="keyword">static_assert</span>(<span class="alias">cw</span>::<span class="enum">Saturday</span>&nbsp;<span class="ol_op">-</span>&nbsp;<span class="alias">cw</span>::<span class="enum">Monday</span>&nbsp;==&nbsp;<span class="num">5</span>);

<span class="built_in">int</span>&nbsp;<span class="func">main</span>()
{
&#9;<span class="keyword">constexpr</span>&nbsp;<span class="namespace">std</span>::<span class="class">array</span>&lt;<span class="built_in">int</span>,&nbsp;<span class="num">5</span>&gt;&nbsp;<span class="var_local">a1</span>&nbsp;=&nbsp;{&nbsp;<span class="num">0</span>,&nbsp;<span class="num">2</span>,&nbsp;<span class="num">4</span>,&nbsp;<span class="num">6</span>,&nbsp;<span class="num">8</span>&nbsp;};
&#9;<span class="keyword">constexpr</span>&nbsp;<span class="namespace">std</span>::<span class="class">array</span>&lt;<span class="built_in">int</span>,&nbsp;<span class="num">5</span>&gt;&nbsp;<span class="var_local">a2</span>&nbsp;=&nbsp;{&nbsp;<span class="num">1</span>,&nbsp;<span class="num">3</span>,&nbsp;<span class="num">5</span>,&nbsp;<span class="num">7</span>,&nbsp;<span class="num">9</span>&nbsp;};
&#9;<span class="keyword">auto</span>&nbsp;<span class="var_local">it</span>&nbsp;=&nbsp;<span class="namespace">std</span>::<span class="func">find_first_of</span>(<span class="mutparam">std</span><span class="mutparam">::</span><span class="mutparam">execution</span><span class="mutparam">::</span><span class="mutparam">par_unseq</span>,&nbsp;<span class="var_local">a1</span>.<span class="func">begin</span>(),&nbsp;<span class="var_local">a1</span>.<span class="func">end</span>(),&nbsp;<span class="var_local">a2</span>.<span class="func">begin</span>(),&nbsp;<span class="var_local">a2</span>.<span class="func">end</span>());
&#9;<span class="namespace">std</span>::<span class="class">thread_pool</span>&nbsp;<span class="var_local">tp</span>;
&#9;<span class="var_local">tp</span>.<span class="func">add_task</span>([&amp;,&nbsp;<span class="var_local">it</span>]()&nbsp;{&nbsp;<span class="namespace">std</span>::<span class="namespace">fmt</span>::<span class="func">print</span>(<span class="string">""index&nbsp;=&nbsp;{}\n""</span>,&nbsp;<span class="var_local">a1</span>.<span class="func">end</span>()&nbsp;-&nbsp;<span class="var_local">it</span>);&nbsp;}).<span class="func">repeat</span>(<span class="num">1337</span>);
}
</code></pre>

* * *

## Media

Quisque consequat sapien eget quam rhoncus, sit amet laoreet diam tempus. Aliquam aliquam metus erat, a pulvinar turpis suscipit at.

![placeholder](http://placehold.it/800x400 "Large example image")
![placeholder](http://placehold.it/400x200 "Medium example image")
![placeholder](http://placehold.it/200x200 "Small example image")

### Big Image

![Test Image](https://unsplash.imgix.net/photo-1429371527702-1bfdc0eeea7d)

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

### Small Image

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore.

![Small Test Image](https://instagram.fmnl2-1.fna.fbcdn.net/t51.2885-15/s640x640/sh0.08/e35/13437309_1167174123346027_1743223026_n.jpg)

Labore et dolore.

* * *

## Embeds

Sometimes all you want to do is embed a little love from another location and set your post alive.

## Spoiler tag
<details>
    <summary>Click to expand</summary>
    <p>whatever</p>
</details>


## Spiler tag 2
<details> 
    <summary>Q1: What is the best Language in the World? </summary>
    <p> A1: JavaScript </p> 
</details>


## Info notes

TODO move "\<i\>" to CSS, div with "note info" etc should be enough

<div class="note info">
#### Info
<i class="fas fa-info-circle"></i>
Tips info box, for Xeverous blog
</div>

<div class="note warning">
#### Warning
<i class="fas fa-exclamation-circle"></i>
Tips warning box, for Xeverous blog
</div>

<div class="note error">
#### Error
<i class="fas fa-times"></i>
Tips error box, for Xeverous blog
</div>

<div class="note pro-tip">
#### Pro-Tip !
<i class="fas fa-star-exclamation"></i>
Tips pro-tips box, for Xeverous blog
</div>

{::comment}
The success div below should have automatically added an image
{:/comment}

<div class="note success">
#### Success !

Tips success box, for Xeverous blog
~~~
test code
~~~
</div>

## test img

Short warning
{: .fas .fa-exclamation-circle}

## test0

{::comment}
Working as intended.
{:/comment}

{:refdef: .note .warning markdown="span"}
<i class="fas fa-exclamation-circle"></i>**Warning**

warning text
{: refdef}

## test1

{::comment}
Working as intended.
{:/comment}

{:refdef: .note .warning markdown="0"}
**Warning**

warning text
{: refdef}

## test2

{::comment}
Embedds both paragraphs in div, but it's a bad workaround.
{:/comment}

{:refdef: .note .warning}
<div><i class="fas fa-exclamation-circle"></i>
**Warning**

warning text
</div>
{: refdef}

## LaTeX

When $a \ne 0$, there are two solutions to $ax^2 + bx + c = 0$ and they are

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$

Other examples:

$$E=mc^2$$

$$\frac{n!}{k!(n-k)!} = \binom{n}{k}$$

$$\begin{equation}
  x = a_0 + \cfrac{1}{a_1 
          + \cfrac{1}{a_2 
          + \cfrac{1}{a_3 + \cfrac{1}{a_4} } } }
\end{equation}$$

$$( a ), [ b ], \{ c \}, | d |, \| e \|,
\langle f \rangle, \lfloor g \rfloor,
\lceil h \rceil, \ulcorner i \urcorner$$

$$
( \big( \Big( \bigg( \Bigg(
$$

$$
A_{m,n} = 
 \begin{pmatrix}
  a_{1,1} & a_{1,2} & \cdots & a_{1,n} \\
  a_{2,1} & a_{2,2} & \cdots & a_{2,n} \\
  \vdots  & \vdots  & \ddots & \vdots  \\
  a_{m,1} & a_{m,2} & \cdots & a_{m,n} 
 \end{pmatrix}
$$