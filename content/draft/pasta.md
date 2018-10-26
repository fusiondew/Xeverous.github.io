---
layout: article
---

.

```c
// some extreme case
int (*(*foo)(void))[3]; // define pointer to function (void) returning pointer to an array of 3 ints
//^  ^              ^ these are parts of the type "pointer to array of 3 ints"
```

{% comment %}
{% capture includeGuts %}
{% include signup-guts.html %}
{% endcapture %}
{{ includeGuts | replace: '    ', ''}}
{% endcomment %}


There are 2 hard problems in computer science: cache invalidation, naming things, and off-by-1 errors. -- Leon Bambrick
There are only two hard problems in distributed systems: 2. Exactly-once delivery 1. Guaranteed order of messages 2. Exactly-once delivery -- Mathias Verraes

for tabs-vs spaces article

```c++
bool operator<(const package& lhs, const package& rhs)
{
    return std::tie(lhs.floor, lhs.shelf, lhs.position)
         < std::tie(rhs.floor, rhs.shelf, rhs.position);
}
```

backwards compatibility articles

```c++
void f(char * p)
{
  if (p > 0) { ... } // OK in C++98..C++11, does not compile in C++14
  if (p > nullptr) { ... } // OK in C++11, does not compile in C++14
}
```


    18:32:35 **** Incremental Build of configuration Debug for project HelloWorld ****
    make all 
    'Building file: ../src/main.cpp'
    'Invoking: GCC C++ Compiler'
    g++ -std=c++1y -std=c++17 -O0 -g3 -pedantic -Wall -Wextra -c -fmessage-length=0 -MMD -MP -MF"src/main.d" -MT"src/main.o" -o "src/main.o" "../src/main.cpp"
    'Finished building: ../src/main.cpp'
    ' '
    'Building target: HelloWorld'
    'Invoking: GCC C++ Linker'
    g++  -o "HelloWorld"  ./src/main.o   
    'Finished building target: HelloWorld'
    ' '

^

    Looking for git in: C:\Program Files\Git\cmd\git.exe
    Using git 2.15.1.windows.2 from C:\Program Files\Git\cmd\git.exe
    git rev-parse --show-toplevel
    git config --get commit.template
    git status -z -u
    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git config --get commit.template
    git status -z -u
    git rev-parse --show-toplevel
    git check-ignore -z --stdin
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git check-ignore -z --stdin
    git check-ignore -z --stdin
    git config --get commit.template
    git status -z -u
    git rev-parse --show-toplevel
    git check-ignore -z --stdin
    git check-ignore -z --stdin
    git check-ignore -z --stdin
    git config --get commit.template
    git status -z -u
    git rev-parse --show-toplevel
    git rev-parse --show-toplevel
    git rev-parse --show-toplevel
    git check-ignore -z --stdin
    git check-ignore -z --stdin
    git check-ignore -z --stdin
    git check-ignore -z --stdin
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git rev-parse --show-toplevel
    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git symbolic-ref --short HEAD
    git symbolic-ref --short HEAD
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git rev-parse master
    git rev-parse --symbolic-full-name --abbrev-ref master@{u}
    git rev-parse master
    git rev-list --left-right master...origin/master
    git symbolic-ref --short HEAD
    git symbolic-ref --short HEAD
    git rev-parse --symbolic-full-name --abbrev-ref master@{u}
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git for-each-ref --format %(refname) %(objectname) --sort -committerdate
    git remote --verbose
    git rev-list --left-right master...origin/master
    git rev-parse refactor-parsing
    git rev-parse master
    git rev-parse --symbolic-full-name --abbrev-ref refactor-parsing@{u}
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    git rev-parse --show-toplevel
    fatal: no upstream configured for branch 'refactor-parsing'

    git for-each-ref --format %(refname) %(objectname) --sort -committerdate
    git remote --verbose
    git rev-parse --symbolic-full-name --abbrev-ref master@{u}
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-parse --show-toplevel
    fatal: Not a git repository (or any of the parent directories): .git

    git rev-list --left-right master...origin/master
    git for-each-ref --format %(refname) %(objectname) --sort -committerdate
    git remote --verbose
    git for-each-ref --format %(refname) %(objectname) --sort -committerdate
    git remote --verbose
