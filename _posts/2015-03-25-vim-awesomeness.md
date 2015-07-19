---
layout: post
title:  "Vim Awesomeness"
date:   2015-03-25 8:34:32
categories: jekyll update
---
### Prefix
There are so many blog posts out there which praise the glory of vim.
Unfortunately, they don't have any examples of what makes vim awesome.
Going through `vimtutor` is nice but a lot the _good stuff_ isn't
shown. I am going to go through some of the most useful tricks, I've
learned.

### 1. set relativenumber
Line numbers of measured from the distance away from the cursor, instead
of the actual line number of the buffer. For example:
{% highlight vim %}
2 2 up
1 1 up
0 On cursor ▌
1 1 down
2 2 down
{% endhighlight %}
Verses
{% highlight vim %}
1 2 up
2 1 up ▌
3 On cursor
4 1 down
5 2 down
{% endhighlight %}

### 2. print the autocommands
I learned this one when I started working with go. Whenever, I saved
a go file, vim wouldn't try calling go#fmt#Format(-1) which would error
out.
{% highlight vim %}
:autocmd
{% endhighlight %}
Now let's run
{% highlight vim %}
:verbose function
{% endhighlight %}

### 3. convert uppercase and lowercase quickly.
Sometimes you want to capitalize or lower a certain region.

Steps:
1. Highlight region
2. Press `shift + U` to capitalize.
3. Press `shift + u` to lower.
