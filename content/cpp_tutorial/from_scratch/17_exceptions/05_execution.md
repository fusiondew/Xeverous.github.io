---
layout: article
---

## unhandled exceptions

You might have already thought - what happens if...

- ...an exception is thrown, it is not catched and exits main function?
- ...`noexcept` function actually throws or lets some inner exception get out?
- ...a constructor or destructor of static object throws?
- ...an exception is thrown and during stack unwinding another one is thrown by some local object destructor?
- ...an exception gets out of separate `std::thread` object?
- ...generally: an exception is thrown and it's impossible to catch it?

**In all of these cases, `std::terminate` is called.**

<div class="note pro-tip">
Be careful when declaring high-level functions `noexcept`. It might be hard to prove they never throw. Do it if you want termination in such case.
</div>

## termination

`std::terminate` by default calls `std::abort`, which in turn, *causes abnormal program termination and returns implementation-defined status to the host environment that indicates unsuccessful execution*.

Most of program terminating functions (including these 2 above) do not call destructors and do not free up resources. Note that all recources are reclaimed by the host environment (eg operating system) anyway when the program terminates.

Generally, these are situations you would like to avoid. In some scenarios, aborts are desired - when there is a problem impossible to deal with (eg heap exhaustion, specific POSIX signal) self-termination informs the system about the problem. Some OSes (eg Android) simply restart programs that self-terminate.

## signals

<div class="note info">
This is a different mechanism from C++ exceptions which is used on Unix and POSIX-compliant systems. Read it if you are interested in system-specific stuff.

Note: Windows somewhat supports signals but in a quite limited fashion.
</div>

<div class="note info" markdown="block">
More information - [Signal](https://en.wikipedia.org/wiki/Signal_\(IPC\)).
</div>

**Short description**

Anytime a program runs (except atomic operations) OS can send an asynchronous signal to the program. The "sending" signal happens by interrupting the program and calling a specific function known as *signal handler*. Most signals are caused by hard errors and their default action is to terminate the program.

- It's possible to *install* a custom signal handler - `std::signal()`
- It's possible to send a signal to the current program - `std::raise()`
- Some signals are not possible to be ignored or handled - eg **SIGKILL** or **SIGSEGV** (this one is caused by segmentation faults)
