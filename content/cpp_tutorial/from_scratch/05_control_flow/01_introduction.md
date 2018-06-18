---
layout: article
---

So far all the programs were strictly ordered and didn't have any sort of branching. One of key aspects of computer programs is to do something *depending* on other thing.

There are multiple types of control flow instructions:

- jumps - **go to** other code line, breaking line-by-line execution order
- conditionals - do something **if** something is true
- loops - repeat something **as long as** something is true
- exceptions - abandon something and **skip** something **until** something

All of these are the same at the machine instruction level - in the assembly, there are only jumps. The program is a sequence of instructions, and depending on some state program can move to arbitrary other instruction and continue execution from there.

Multiple control flow keywords exist - all of these do similar things. The key is to choose the right instruction for the given task. All of the methods above end in machine instruction jumps, but you will see that each has different code structure and certain, strict rules - with plain "jump from this code line to that" you can easily screw up things or find yourself in a mindfuck of "Where will I land after this?".

<div class="note pro-tip">
<h4>Appropriate choices</h4>
In programming, there is <s>often</s> almost always a situation where multiple solutions are possible. The key is to choose appropriately - overgeneric solutions are easy to <s>use</s> abuse and create more doubt than certainty. When possible, use more specific solutions which are better suited for the task.
</div>

Exceptions are much more complex compared to the rest, they will be explained much much later.
