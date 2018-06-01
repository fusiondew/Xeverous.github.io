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
