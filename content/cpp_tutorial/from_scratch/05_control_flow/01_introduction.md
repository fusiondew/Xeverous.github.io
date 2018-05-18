---
layout: article
---

So far all the programs were strictly ordered and didn't have any sort of branching. One of key aspects of computer programs is to do something *depending* on other thing.

There are multiple types of control flow instructions:

- jumps - **go to** other code line, breaking line-by-line execution order
- conditionals - do something **if** something
- loops - repeat something **as long as** something
- exceptions - abandon something and **skip** the task

All of these are the same at the machine instruction level - in the assembly, there are only jumps. The program is a sequence of instructions, and depending on some state program can move to arbitrary other instruction and continue execution there.

Multiple control flow keywords exist - all of these do similar things. The key is to choose the right instruction for the given task.

<div class="note pro-tip">
#### Appropriate choices
<i class="fas fa-star-exclamation"></i>
In programming, there is <s>often</s> almost always a situation where multiple solutions are possible. The key is to choose appropriately - overgeneric solutions are easy to <s>use</s> abuse and create more doubt than certainty. When possible, use more specific solutions which are better suited for the task.
</div>

Exceptions are much more complex compared to the rest, they will be explained much much later.
