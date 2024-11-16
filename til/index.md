# index.md
---
layout: home
title: Home
---

# Today I Learned

Welcome to my TIL (Today I Learned) journal! Here I document my daily learnings across various topics in software development and technology.

## Recent Learnings

{% for post in site.posts limit:5 %}
### [{{ post.title }}]({{ post.url | relative_url }})
{{ post.date | date: "%B %d, %Y" }}

{{ post.excerpt }}

[Read more]({{ post.url | relative_url }})

---
{% endfor %}

## Topics

{% assign tags = site.tags | sort %}
{% for tag in tags %}
  - [#{{ tag[0] }}]({{ '/tags/#' | append: tag[0] | relative_url }}) ({{ tag[1] | size }} posts)
{% endfor %}