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

<pre class="highlight"><code><span class="prep-direct">#include</span> <span class="prep-hdr">&lt;execution&gt;</span>
<span class="prep-direct">#include</span> <span class="prep-hdr">&lt;thread&gt;</span>
<span class="prep-direct">#include</span> <span class="prep-hdr">&lt;string&gt;</span>
<span class="prep-direct">#include</span> <span class="prep-hdr">&lt;fmt&gt;</span>

<span class="comm-multi">/*
 * Disjunctions are short-circuited
 * overloaded operators can not be used in requires expressions
 */</span>
<span class="keyword">template</span> <span class="op">&lt;</span><span class="keyword">typename</span> <span class="tparam">T</span><span class="op">&gt;</span>
<span class="keyword">concept</span> <span class="concept">MoreThanComparable</span> <span class="op">=</span> <span class="keyword">requires</span><span class="op">(</span><span class="tparam">T</span> <span class="param">a</span><span class="op">,</span> <span class="tparam">T</span> <span class="param">b</span><span class="op">)</span> <span class="op">||</span> <span class="concept">LessThanComparable</span>
<span class="brace">{</span>
&#9;<span class="brace">{</span> <span class="param">a</span> <span class="op">&gt;</span> <span class="param">b</span> <span class="brace">}</span> <span class="op">-></span> <span class="built-in">bool</span><span class="op">;</span> <span class="comm-single-dox">/// </span><span class="comm-tag-dox">@brief</span> <span class="comm-single-dox">expression "a > b" must return bool</span>
<span class="brace">}</span><span class="op">;</span>

<span class="keyword">template</span> <span class="op">&lt;</span><span class="concept">EqualityComparable</span><span class="op">...</span> <span class="tparam">Args</span><span class="op">&gt;</span> <span class="keyword">constexpr</span>
<span class="keyword">decltype</span><span class="op">(</span><span class="keyword">auto</span><span class="op">)</span> <span class="func">build</span><span class="op">(</span><span class="tparam">Args</span><span class="op">&amp;&amp;...</span> <span class="param">args</span><span class="op">);</span> <span class="comm-single">// constrained C++20 function template</span>
<span class="brace">{</span>
&#9;<span class="keyword">if</span> <span class="keyword">constexpr</span> <span class="op">(</span><span class="keyword">sizeof</span><span class="op">...(</span><span class="param">args</span><span class="op">)</span> <span class="op">==</span> <span class="num">0</span><span class="op">)</span>
&#9;&#9;<span class="keyword">throw</span> <span class="namespace">std</span><span class="op">::</span><span class="class">logic_error</span><span class="op">(</span><span class="namespace">std</span><span class="op">::</span><span class="class">string</span><span class="op">(</span><span class="string">"error in file: "</span><span class="op">)</span> <span class="op-ol">+</span> <span class="macro-ref">__FILE__</span> <span class="op-ol">+</span> <span class="string">"on line: "</span> <span class="op-ol">+</span> <span class="macro-ref">__LINE__</span><span class="op">);</span>

&#9;<span class="keyword">return</span> <span class="namespace">std</span><span class="op">::</span><span class="class">tuple</span><span class="op">(</span><span class="namespace">std</span><span class="op">::</span><span class="func">forward</span><span class="op">&lt;</span><span class="tparam">Args</span><span class="op">&gt;(</span><span class="param">args</span><span class="op">)...);</span>
<span class="brace">}</span>

<span class="keyword">template</span> <span class="op">&lt;</span><span class="keyword">typename</span> <span class="tparam">T</span><span class="op">&gt;</span>
<span class="keyword">concept</span> <span class="concept">Opaque</span> <span class="op">=</span> <span class="keyword">requires</span><span class="op">(</span><span class="tparam">T</span> <span class="param">x</span><span class="op">)</span>
<span class="brace">{</span>
&#9;<span class="brace">{</span><span class="op">*</span><span class="param">x</span><span class="brace">}</span> <span class="op">-></span> <span class="keyword">typename</span> <span class="tparam">T</span><span class="op">::</span><span class="class">inner</span><span class="op">;</span> <span class="comm-single">// the expression *x must be valid</span>
&#9;                           <span class="comm-single">// AND the type T::inner must be valid</span>
&#9;                           <span class="comm-single">// AND the result of *x must be convertible to T::inner</span>
<span class="brace">}</span>

<span class="keyword">using</span> <span class="alias">cw</span> <span class="op">=</span> <span class="namespace">std</span><span class="op">::</span><span class="namespace">chrono</span><span class="op">::</span><span class="class">weekday</span><span class="op">;</span>
<span class="keyword">static_assert</span><span class="op">(</span><span class="alias">cw</span><span class="op">::</span><span class="const">Saturday</span> <span class="op-ol">-</span> <span class="alias">cw</span><span class="op">::</span><span class="const">Monday</span> <span class="op">==</span> <span class="num">5</span><span class="op">);</span>

<span class="keyword">int</span> <span class="func">main</span><span class="op">()</span>
<span class="brace">{</span>
&#9;<span class="keyword">constexpr</span> <span class="namespace">std</span><span class="op">::</span><span class="class">array</span><span class="op">&lt;</span><span class="built-in">int</span><span class="op">,</span> <span class="num">5</span><span class="op">&gt;</span> <span class="var-local">a1</span> <span class="op">=</span> <span class="brace">{</span> <span class="num">0</span><span class="op">,</span> <span class="num">2</span><span class="op">,</span> <span class="num">4</span><span class="op">,</span> <span class="num">6</span><span class="op">,</span> <span class="num">8</span> <span class="brace">}</span><span class="op">;</span>
&#9;<span class="keyword">constexpr</span> <span class="namespace">std</span><span class="op">::</span><span class="class">array</span><span class="op">&lt;</span><span class="built-in">int</span><span class="op">,</span> <span class="num">5</span><span class="op">&gt;</span> <span class="var-local">a2</span> <span class="op">=</span> <span class="brace">{</span> <span class="num">1</span><span class="op">,</span> <span class="num">3</span><span class="op">,</span> <span class="num">5</span><span class="op">,</span> <span class="num">7</span><span class="op">,</span> <span class="num">9</span> <span class="brace">}</span><span class="op">;</span>
&#9;<span class="keyword">auto</span> <span class="var-local">it</span> <span class="op">=</span> <span class="namespace">std</span><span class="op">::</span><span class="func">find_first_of</span><span class="op">(</span><span class="mutparam">std::execution::par_unseq</span><span class="op">,</span> <span class="var-local">a1</span><span class="op">.</span><span class="func">begin</span><span class="op">(),</span> <span class="var-local">a1</span><span class="op">.</span><span class="func">end</span><span class="op">(),</span> <span class="var-local">a2</span><span class="op">.</span><span class="func">begin</span><span class="op">(),</span> <span class="var-local">a2</span><span class="op">.</span><span class="func">end</span><span class="op">());</span>
&#9;<span class="namespace">std</span><span class="op">::</span><span class="class">thread_pool</span> <span class="var-local">tp</span><span class="op">;</span>
&#9;<span class="var-local">tp</span><span class="op">.</span><span class="func">add_task</span><span class="op">([&amp;,</span> <span class="var-local">it</span><span class="op">]()</span> <span class="brace">{</span> <span class="namespace">std</span><span class="op">::</span><span class="namespace">fmt</span><span class="op">::</span><span class="func">print</span><span class="op">(</span><span class="string">"index = {}\n"</span><span class="op">,</span> <span class="var-local">a1</span><span class="op">.</span><span class="func">end</span><span class="op">()</span> <span class="op-ol">-</span> <span class="var-local">it</span><span class="op">);</span> <span class="brace">}</span><span class="op">).</span><span class="func">repeat</span><span class="op">(</span><span class="num">1337</span><span class="op">);</span>
<span class="brace">}</span>
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

{::options parse_block_html="true" /}
<div class="note info">
#### Info
<i class="fas fa-info-circle"></i>
Tips info box, for Xeverous blog
</div>


{::options parse_block_html="true" /}
<div class="note warning">
#### Warning
<i class="fas fa-exclamation-circle"></i>
Tips warning box, for Xeverous blog
</div>

{::options parse_block_html="true" /}
<div class="note error">
#### Error
<i class="fas fa-times"></i>
Tips error box, for Xeverous blog
</div>

{::options parse_block_html="true" /}
<div class="note pro-tip">
#### Pro-Tip !
<i class="fas fa-star-exclamation"></i>
Tips pro-tips box, for Xeverous blog
</div>

{::options parse_block_html="true" /}
<div class="note success">
#### Success !
<i class="fas fa-check"></i>
Tips success box, for Xeverous blog
</div>

