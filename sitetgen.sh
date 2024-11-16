#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "git is not installed. Please install git first."
    exit 1
fi

# Get GitHub username
read -p "Enter your GitHub username: " github_username

# Verify if directory already exists
if [ -d "til" ]; then
    print_error "Directory 'til' already exists. Please remove it or choose a different location."
    exit 1
fi

# Create main directory
print_status "Creating TIL site structure..."
mkdir -p til
cd til

# Initialize git repository
git init

# Create directory structure
mkdir -p _layouts _posts assets/css assets/js _includes _pages

# Create _config.yml
print_status "Creating configuration files..."
cat > _config.yml << EOF
title: TIL by ${github_username}
description: My learning journey - one day at a time
baseurl: "/til"
url: "https://${github_username}.github.io"
github_username: ${github_username}
markdown: kramdown
plugins:
  - jekyll-feed
  - jekyll-sitemap
collections:
  tags:
    output: true
EOF

# Create default layout
cat > _layouts/default.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ site.title }}{% if page.title %} - {{ page.title }}{% endif %}</title>
    <link rel="stylesheet" href="{{ '/assets/css/style.css' | relative_url }}">
</head>
<body>
    <header>
        <nav>
            <a href="{{ '/' | relative_url }}" class="site-title">{{ site.title }}</a>
            <div class="nav-links">
                <a href="{{ '/tags' | relative_url }}">Topics</a>
                <a href="{{ '/about' | relative_url }}">About</a>
                <a href="https://github.com/{{ site.github_username }}">GitHub</a>
            </div>
        </nav>
    </header>
    <main>
        {{ content }}
    </main>
    <footer>
        <p>© {{ 'now' | date: "%Y" }} {{ site.title }} • <a href="https://opensource.org/licenses/MIT">MIT License</a></p>
    </footer>
</body>
</html>
EOF

# Create CSS
cat > assets/css/style.css << EOF
:root {
    --primary-color: #2563eb;
    --bg-color: #ffffff;
    --text-color: #1f2937;
    --secondary-bg: #f3f4f6;
}

body {
    font-family: system-ui, -apple-system, sans-serif;
    line-height: 1.6;
    color: var(--text-color);
    background: var(--bg-color);
    margin: 0;
    padding: 0;
}

header {
    background: var(--bg-color);
    padding: 1rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

nav {
    max-width: 800px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.site-title {
    font-size: 1.5rem;
    font-weight: bold;
    color: var(--primary-color);
    text-decoration: none;
}

.nav-links a {
    margin-left: 1.5rem;
    color: var(--text-color);
    text-decoration: none;
}

main {
    max-width: 800px;
    margin: 2rem auto;
    padding: 0 1rem;
}

.post {
    background: var(--bg-color);
    border-radius: 0.5rem;
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.post-title {
    margin: 0;
    color: var(--text-color);
}

.post-meta {
    color: #6b7280;
    font-size: 0.875rem;
}

.tag {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    background: var(--secondary-bg);
    border-radius: 9999px;
    font-size: 0.875rem;
    color: var(--text-color);
    text-decoration: none;
    margin: 0.25rem;
}
EOF

# Create index page
cat > index.html << EOF
---
layout: default
---
<div class="posts">
    {% for post in site.posts %}
    <article class="post">
        <h2 class="post-title">
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </h2>
        <div class="post-meta">
            {{ post.date | date: "%B %d, %Y" }}
            {% for tag in post.tags %}
            <a href="{{ '/tags/' | relative_url }}#{{ tag }}" class="tag">#{{ tag }}</a>
            {% endfor %}
        </div>
        <div class="post-excerpt">
            {{ post.excerpt }}
        </div>
    </article>
    {% endfor %}
</div>
EOF

# Create tags page
mkdir -p tags
cat > tags/index.html << EOF
---
layout: default
title: Topics
---
{% for tag in site.tags %}
  <h3 id="{{ tag[0] }}">{{ tag[0] }}</h3>
  <ul>
    {% for post in tag[1] %}
      <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
    {% endfor %}
  </ul>
{% endfor %}
EOF

# Create about page
cat > _pages/about.md << EOF
---
layout: default
title: About
permalink: /about/
---

# About This TIL Site

This is my Today I Learned (TIL) site. Here, I document things I learn day to day across various technologies and topics.

## What to Expect

- Short, focused posts
- Code snippets and examples
- Real-world applications
- Regular updates

## Contact

Feel free to reach out:
- GitHub: [@${github_username}](https://github.com/${github_username})
EOF

# Create example post
current_date=$(date +%Y-%m-%d)
cat > _posts/${current_date}-welcome.md << EOF
---
layout: post
title: "Welcome to my TIL Journey"
date: ${current_date}
tags: [meta]
---

Welcome to my Today I Learned (TIL) journal! This is where I'll be documenting my daily learning journey. Each post will contain something new I've learned, complete with code snippets, examples, and explanations.

Stay tuned for daily updates across various topics including:
- Programming languages
- Software development
- Best practices
- Tools and technologies
EOF

# Create MIT License
cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) ${github_username}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create README
cat > README.md << EOF
# Today I Learned

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Personal collection of things I learn day to day.

## Categories

- Browse posts by [topic](https://${github_username}.github.io/til/tags)
- View [all posts](https://${github_username}.github.io/til)

## License

This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

While this is mainly a personal learning journal, if you spot any errors or have suggestions:
1. Open an issue
2. Submit a pull request

## Contact

- GitHub: [@${github_username}](https://github.com/${github_username})
EOF

# Initialize git repository
git add .
git commit -m "Initial TIL site setup"

print_success "TIL site structure created successfully!"
print_status "Next steps:"
echo "1. Create a new repository on GitHub named 'til'"
echo "2. Push this repository to GitHub:"
echo "   git remote add origin https://github.com/${github_username}/til.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo "3. Enable GitHub Pages in repository settings"
echo "4. Your site will be available at: https://${github_username}.github.io/til"