---
layout: article
---

Sometimes you may catch an exception but not be able to deal with it completely.

```c++
void game_loader::save_game_state()
{
    try
    {
        check_this();
        check_that();
        save_this();
        save_that();
        and_other_stuff();
    }
    catch (const game_save_exception& e)
    {
        // repair, do clean up
        // ...

        if (!e.is_os_problem())
        {
            log.add_error("save failed because of OS problem: ", e.what());
            throw; // rethrow exception (does not execute logging after if)
        }

        log.add_error("game save failed for non-OS-related cause: ", e.what());
    }
}
```

Then, the statement `throw` **rethrows** this exception. It will unwind the stack further until another enclosing try block is encountered.

```c++
try
{
    m_game_loader.save_game_state();
    m_game_loader.load_next_level();
}
catch (const game_save_exception& e)
{
    // inform the user about the problem (eg no write access, no disk space etc)
    m_ui.dialog_box_popup(e.what());
}
```

**Typical uses of rethrowing**

- partial cleanup
- logging
- adding more information about the problem (possibly throwing exception of different type or modifying exception object)

**Common mistakes**

- useless catch-do-nothing-and-rethrow

```c++
catch (/* ... */) { throw; } // pointless: if uncatched, would unwind the stack more
```

- throwing catched exceptions by value (there is no "throw by reference")

```c++
catch (const std::exception& e)
{
    // do something
    // ...

    throw e; // sliced copy!
}
```

<div class="note pro-tip">
When rethrowing the same exception object, write just `throw;`.
</div>
