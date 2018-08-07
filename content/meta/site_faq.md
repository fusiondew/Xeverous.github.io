---
layout: article
---

## Site FAQ

### Site content

#### Why tutorials are build over feature X, Y, Z but not incrementally over consecutive C++ standards?

This not a good idea. If you play any online game - do you learn it how it is at the given moment or read patch notes for every update since the beginning? It's good to know what things have been introduced in what order, but it doesn't do well in terms of learning. A lot of features can be mixed together, so the order of presentation matters, not the chronological order of their introduction.

It's better to study a complete feature in one go than to jump back to it periodically because there was a language update. It makes searching hard (unstructured lessons) and requires jumping between features when learning which may be confusing and counter-productive. Plus you are not going to remember when everything was introduced anyway (unless you really want to or work on tools or in committee).

However, newer features are explicitly marked and most chapters about certain features do go upfront from the start to the latest changes. Where possible, I did go from the past to newer stuff, where not I focused more on the best order to understand things with least struggle.

### Site creation

#### What was the hardest part of writing the content?

2 things:

1\. Deciding whether X amount of text for an explanation of ABC is enough. I might write 2X but will it not overwhelm the reader? Is more, simpler text always better? Some readers may find 0.5X to be enough (and more text to be redundant or boring) while some may find 2X + examples to be necessary to understand the thing. I think I may spend to much time on text-meta and think too deeply about each site user.

Regardless of text, I'm sure more examples are always a good idea. They don't distract the user much and each gives a chance to look how something is used.

Sometimes I struggle with creating examples - especially for design patterns. And it's better not to provide bad examples.

2\. The order of presented features. Multiple ones are very often mixed together and they don't offer much alone. Sometimes there are like 3 things, and I struggle to find a way to showcase them because A needs B, B needs C and C needs A.

It was easy with lambdas - they were build on top of ordinary functions and further lambda features were mostly going upwards in depth, not adding a lot of complexity - this is why lambda expression chapter is pretty straightforward, then adding more about mutability and generic programming.

It was hard with templates. Templates by their nature may be hard to grasp, and even short examples use a lot of features. Many features were added as syntax sugar or more complex versions of existing ones. The depth comes from mixing complex features, not from diving deeper into one. Some examples are overly trivial and may not represent well real use cases but at least they don't overwhelm the reader - at first stages it's more important to understand how it works, not what are applications of it.

Still, as with first point - I find that more examples are always better.

#### What was the motivation to create the site?

**Practically everything besides few websites about C++ is garbage. Not only sites - there are many bad books too!!! Nothing has really motivated me so strong as the amount of trash tier content.** So many sites copy-paste average C or "C without C-only features" and claim it to be C++ "because we added a class", "because it compiles":

- cprogramming (ironically most of their C++ is C)
- geeksforgeeks (take any exercise, C and C++ solutions are often the same code or have marginal differences)
- code project (countless beginner level mistakes in most articles)

A unique exception is thisPointer.com. It has some good idiomatic STL examples.

learncpp.com is regarded as one of the best sites for learning C++. Site is good but it still has many mistakes. Still, I rate it \#1 after mine which hopefully will be \#0 for you.

There is a C++ language tutorial on cplusplus.com. It is not bad, assuming we read it in 2003. Most content on the site is heavily outdated. Tutorial is pretty fast and compact, but:

- does not give any reasoning about desicions - readers do not learn, they just follow recomemndations with no understanding
- many features lack recommendation - reader can remember them, but has no idea what's their purpose and when to use them
- even for old C++98/03, the site does not mention many features
- some features are not presented in very convenient order
- the site does not seem to be maintained

Initially, I wanted to contribute to learncpp.com, but [Alex said](http://www.learncpp.com/site-news/find-something-wrong/comment-page-2/#comment-310505) it's not currently possible and "technology is not there yet".

There are few other good sites (eg fluent C++, bfilipek), but since they are more blog-oriented for periodic news and posts, I disregarded them and planned to build own guide based on plain markdown repository. I wanted a structured, step-by-step guide, not random blog posts about certain problems - 90% of C++ problems are already solved by Stack Overflow.

Soon then, I realized GitHub has opened GitHub Pages and allowed for free static website hosting also offering integrated Jekyll. That's much better than reading pure markdown.

Other consequences

- I will learn one of countless web frameworks
- I will consolidate my skills and knowledge (and even use the site myself)
- the site is a good portfolio for both of us (creators)

#### What technologies are used for this website?

- [Jekyll](https://jekyllrb.com/) - static site generator using Ruby language and Liquid template engine
- (obviously) HTML 5, CSS 3, JavaScript
- Bootstrap 4.0.0
- theme is heavily modified version of [BlackDoc](https://github.com/karloespiritu/BlackDoc)

[Site repository](https://github.com/Xeverous/Xeverous.github.io)

#### Who is behind the site?

So far all the content is written by me ([/u/Xeverous](https://www.reddit.com/user/Xeverous/) on reddit, [Xeverous](https://github.com/Xeverous) on GitHub) and all the frontend is done by <a style="font-weight: 300 !important;" href="mailto:miks.szymon@gmail.com">Szymon Miks</a>.
