---
layout: article
---

I'm sorry if this is an unpleasant surprise, there will be almost no code in this chapter. Before actual programming, there are multiple things you should know before.

If you find this chapter boring (or already know the thing), just move on. But be warned - this chapter adheres to RTFM rule.

<div class="note pro-tip">
<h4>RTFM</h4>
READ THE FUCKING MANUAL. If you end up not being able to configure your IDE or compiler it will be your own fault.
</div>

<div class="note info">
a lot of additional info is covered in FAQ and the glossary. Additionally, multiple articles have embedded questions which may raise for relevant stuff.
</div>

#### Question: Do I need to be good in math to program?

You can already find a lot about this question on the internet.

In my opinion, the enough level is understanding functions and second-degree equations. Anything more will be an advantage. We program so that we are not bothered with math, this is the task for computers. Still, any additional knowledge will be beneficial.

#### Question: Do I need to understand the binary system?

It is not required, but it is an advantage. At worst you will just skip bit operations lessons. Fortunately nothing really depends on them so you can learn everything else.

Still, I recommend to learn the binary system. Numberphile has a [great video](https://www.youtube.com/watch?v=lNuPy-r1GuQ) explaining how logic gates work using dominos as the current.

#### Question: Do I need to be good in English?

I try to write in easy language on this website but I encourage you to learn English first (or during the reading) if you have problems reading the content.

In the IT industry, English is the main language - most companies require certain skill to be hired. The more the better. Should you find yourself not enduring the feeling of being verdant amidst sophisticated jist you better postpone the lecture in regards to seizing the exquisite English language.

#### Question: Do I need a powerful computer to program?

No. The essential part of programming is writing code. I hardly doubt your computer is not capable of launching a text editor. If you can view this website, you can program too.

*Whta about creating games?*

This is somewhat a different thing. You can build (make) games, they just may not run as smoothly as on more powerful machines. Still, you can do a ton in the programming field which does not require top end graphic card and you would need to make a quite big game to hit performance problems anyway.

#### Quesion: Does it cost?

All tools presented on this site are free and very often (if not always) open source. Unless you want to use advanced paid features of these tools or commercial software you should only bother for the electricity bill.

#### Question: Why there are multiple programming languages?

The reason is simple: In the beginning, there was only pure machine code. Then, basic abstractions such as assembly appeared. These only mapped codes to named instructions so you could write `add`, `mov` instead of directly working on the binary system. Then, more advanced abstractions appeared allowing to write even easier to read code.

No solution can fully satisfy everyone, some appeared independently and this is why we have multiple human and programming languages. Someone preferred `begin`, `end`, someone else `{` and `}` symbols. Someone wanted more convenience, someone else more performance.  Different languages have different aims. All in all everything ends up in machine instructions.

**So why C++?**

I predict you are reading this tutorial mostly for these reasons:

- you heard C++ is very fast
- you heard C++ can do things which some other languages can't 
- you heard C++ is better than C
- you know C and want to leverage your skills
- you know C++ is complex and you like it (well, I prefer chess to checkers)
- you already know other programming language and are searching for extra challenge
- you are interested in template metaprogramming

All of these reasons are good, although not required to start this tutorial.

More about types of programming languages and their differences later.

C++ relies on 2 core pillars:

- direct map to hardware
- zero-overhead abstraction

Language aims:

- You do not pay what you do not use (unused features should not impact performance).
- User-defined types need to have the same support and performance as built-in types.
- It must be driven by actual problems and its features should be useful immediately in real world programs.
- Every feature should be implementable (with a reasonably obvious way to do so).
Programmers should be free to pick their own programming style, and that style should be fully supported by C++.
- Allowing a useful feature is more important than preventing every possible misuse of C++.
- It should provide facilities for organising programs into well-defined separate parts, and provide facilities for combining separately developed parts.
- No implicit violations of the type system (but allow explicit violations; that is, those explicitly requested by the programmer).
- There should be no language beneath C++ (except assembly language).
- C++ should work alongside other existing programming languages, rather than fostering its own separate and incompatible programming environment.
- If the programmer's intent is unknown, allow the programmer to specify it by providing manual control.

C++ is well-know for:

- it's performance
- being one of (if not the most) complex programming language
- being hard to learn but covering most features of many other languages together
- having 40 years long history


#### Question: Where is C++ used?

Explained in the FAQ. TODO link

#### Question: What is ...?

Lookup in the glossary. TODO link

## core recommendations

- do not copy paste code, rewrite it instead - this will help you to memorize the syntax and prevent coming back to first examples
- experiment with examples - change things and see what happens
- don't stay too long if you can't accomplish something - it's likely that later chapters will explain the thing or the knowlege of next lessons will allow you to understand something better
- move on if you can't find a way to understand something - many features depend on each other, and you need to first grasp overview of one, then learn second and then finish first - I tried to make the tutorial linear but if someting sounds you need more knowledge - move on and came there back later
