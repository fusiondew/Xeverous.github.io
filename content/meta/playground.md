---
layout: article
---

## Preformatted Text

Below is just about everything you’ll need to style in the theme. Check the source code to see the many embedded elements within paragraphs.

Typographically, preformatted text is not the same thing as code. Sometimes, a faithful execution of the text requires preformatted text that may not have anything to do with code. Most browsers use Courier and that’s a good default — with one slight adjustment, Courier 10 Pitch over regular Courier for Linux users.

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

## Media

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