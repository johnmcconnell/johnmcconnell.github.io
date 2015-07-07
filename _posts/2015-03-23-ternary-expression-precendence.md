---
layout: post
title:  "Bitten by Ternary Expression Precendence"
date:   2015-03-23 13:34:32
categories: jekyll update
---
Here is an interesting one about C++ and ruby. A friend of mine was
working a project when this chunk of code bit him.

{% highlight ruby %}
payment_methods << task.type(:payoff) ? task.payment_method : PaymentMethod.Internal
{% endhighlight %}

Can you guess what is in `payment_methods`? (_ssh, lisp programmers.
I'm not asking you._)

It's not:

{% highlight ruby %}
[:ach, :internal, :internal, :e_check, ...]
{% endhighlight %}

Surprisingly, the correct answer is:

{% highlight ruby %}
[true, false, false, true]
{% endhighlight %}

So what is going on? Well nothing too crazy.
First, shortening the code to just the simple expressions yields:

{% highlight ruby %}
  exp1 method exp2 method exp3 ? exp4 : exp5
{% endhighlight %}

But the interpeter is parsing the expression with this precendence:

{% highlight ruby %}
  ((exp1 method exp2) method exp3) ? exp4 : exp5
{% endhighlight %}

A couple of coworkers saw this and thought the current interpreter
implementation had a bug. So we decided to see how C++ handles
this situation. Below is the example `test.cpp` file.

{% highlight cpp %}
#include<iostream>

int main()
{
  std::cout << 5 == 5 ? (std::cout << "here") : (std::cout << "here2");
  std::cout << std::endl;
}
{% endhighlight %}

When we compile we see a nice warning from the compiler.

{% highlight bash %}
jmcconnell1@john-mac:~ $ g++ test.cpp
test.cpp:5:18: warning: overloaded operator << has lower precedence than comparison operator [-Woverloaded-shift-op-parentheses]
  std::cout << 5 == 5 ? (std::cout << "here") : (std::cout << "here2");
  ~~~~~~~~~~~~~~ ^  ~
test.cpp:5:13: note: place parentheses around the '<<' expression to silence this warning
  std::cout << 5 == 5 ? (std::cout << "here") : (std::cout << "here2");
            ^
  (             )
test.cpp:5:18: note: place parentheses around comparison expression to evaluate it first
  std::cout << 5 == 5 ? (std::cout << "here") : (std::cout << "here2");
                 ^
               (     )
test.cpp:5:18: warning: comparison of constant 5 with expression of type 'bool' is always false [-Wtautological-constant-out-of-range-compare]
  std::cout << 5 == 5 ? (std::cout << "here") : (std::cout << "here2");
  ~~~~~~~~~~~~~~ ^  ~
2 warnings generated.
{% endhighlight %}

Running the code, we see ruby is behaving the same as c++ in handling
prescendence, which is arguably a good thing.

{% highlight bash %}
jmcconnell1@john-mac:~ $ ./a.out
5here2
{% endhighlight %}

Now that we understand the behavior, let's try to penetrate the mystery
of it's origin. (_To be continued..._)
