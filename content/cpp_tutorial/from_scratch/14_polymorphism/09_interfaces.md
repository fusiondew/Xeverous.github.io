---
layout: article
---

**Interface** is a class that:

- has no member variables
- has only pure virtual functions

Interfaces are very popular because:

- no member variables means no invariants means no bugs
- every type can inherit from an interface and allow itself to be treated through the interface
- interfaces require minimum maintenance - the interface creator has practically no responsibilities
- interfaces are convenient for testing (mocking)

## example interfaces

```c++
class logger
{
public:
    virtual void add_note(const std::string& str) = 0;
    virtual void add_warning(const std::string& str) = 0;
    virtual void add_error(const std::string& str) = 0;
    virtual void save() const = 0;
};
```

With such `logger` interface, we can implement `file_logger`, `email_logger`, `gui_logger` etc. Given such code:

```c++
bool my_engine::some_very_important_operation(/* params */, logger& log)
{
    log.add_note("beginning of ...");

    if (!engine.is_ready())
    {
        log.add_error("Engine not ready!");
        return false;
    }

    if (!resource_manager.has_enough_oil())
    {
        log.add_error("No oil!");
        return false;
    }

    if (!resource_manager.has_low_oil())
    {
        log.add_warning("Low oil.")
    }

    // important stuff...

    log.add_note("launch success");
    return true;
}
```

Generally we do not care what `logger` actually is. It might output information to screen, save it to the file, count warnings/errors etc. The code above realizes polymorphism and allows great extensibility - engine only wants to inform something about it's actions. It's possible that multiple logger types exist and the user chooses in settings which one is created and where errors are output.

```c++
class printer
{
public:
    virtual bool has_paper() const = 0;
    virtual bool needs_service() const = 0;
    virtual bool print(const pdf_file& file) = 0;
    virtual bool print(const html_file& file) = 0;
};
```

Should we really care if the actual object is `ink_printer` or `laser_printer`? From the viewpoint of someone calling a printer, it only matters whether the operation succeeded (returned `true`).

```c++
class gui_widget
{
    virtual void process_event(const event& e) = 0;
    virtual rectangle get_size_requirements() const = 0;
    virtual void draw(const paintable& p) const = 0;
};
```

We can have very rich graphical programs displaying many widgets on the screen. Such classes are often used in GUI programs to provide uniform treatment for all widgets - all the programs needs to know is size of the widget (when drawn) and a way to pass events into it (button presses, mouse position changes etc) so that the widget ca react accordingly.

In the example above there is 1 more interface - `paintable`. A widget could be drawn on the screen, on another widget and also saved as an image (assuming `image` inherits from `drawable`).

## in other languages

Many programming languages do not allow multiple inheritance but they allow:

- 0 or 1 parent class (can be abstract)
- any number of parent interfaces

Generally it is a very good idea because once you have 2 parents which have member variables, keeping the invariants becomes really hard. Code gets complicated and the more such **mixin** is used, the harder it becomes to refactor it when there is a need for a change.

C++ does not limit inheritance in any way (everything is a `class`, there is no `interface` keyword which disallows member variables) but still it's recommended to follow typical 1 parent + N interfaces pattern.

If you do really want to have multiple parents with member variables, make them `private` to make sure it's only the business of parents what they store there. Whenever you inherit from a class which contains protected data, you get more variables to mess with and more chances to create a bug (eg by overwriting/changing something in a way not expected by the parent class).

Certain, characteristic inheritance hierarchies of classes and interfaces are known as **design patterns**.

## naming style

Some languages have maintaned strong convention for interface names. C++ does not have any strong or recomemnded one but you might encounter borrowed styles in real code:

- C# (prepend "I"): `IAnimal`, `IPrinter`, `IGuiWidget`
- Java (append "Interface"): `AnimalInterface`, `PrinterInterface`, `GuiWidgetInterface`

Extended version of C# style is used in Unreal Engine - they have multiple prefixes ("I" for interface, "A" for actor, "E" for exception and such).
