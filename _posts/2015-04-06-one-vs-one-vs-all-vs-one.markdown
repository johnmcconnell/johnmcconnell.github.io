---
layout: post
title:  "HW 5 - Machine Learning"
date:   2015-04-06 12:53:24
categories: jekyll update
---

# Homework 5

## Multiclass Classification

### Question 1
{% highlight text %}
Big O(D * N^2) for a binary classifier. N is the number of sample
instances, and D is the size of the feature vector for each instance.
All vs All:
For m classes we have (M choose 2) comparisons, which is
(m * (m - 1) / 2) comparisons.
For each comparison, we have 2 * l / m relevant instances.
Therefore the Big O for each comparison, it takes O(d * (2 * l / m)^2) to train.
In total we have O([(m^2 - m) / 2] * [d * (4 * l^2) / (m^2)]) which yields
O([1 - 1 / m] * d * 2 * l^2) => O(d * l^2)
One vs All:
For m classes we have m classifiers.
For each classifier, we have l relevant instances.
for each comparison is O(d * l^2).
In total we have O(m * d * l^2)
{% endhighlight %}

### Question 2
{% highlight text %}
Big O(D^2 * N) for a binary classifier. N is the number of sample
instances, and D is the size of the feature vector for each instance.
All vs All:
For m classes we have (M choose 2) comparisons, which is
(m * (m - 1) / 2) comparisons. Big O of O(m^2)
For each comparison, we have 2 * l / m relevant instances. Therefore the Big O
for each comparison is O(d^2 * (2 * l / m)). Big O of (d^2 * l/m)
In total we have O([(m^2 - m)] * [d^2 * l / m]) which yields
O((m - 1) * [d^2 * l]) => O(m * d^2 * l)
One vs All:
For m classes we have m classifiers.
For each classifier, we have l relevant instances.
for each comparison is O(d^2 * l).
In total we have O(m * d^2 * l)
{% endhighlight %}

### Question 3
{% highlight text %}
A given has a prediction cost of Big O(d)
Majority: Big O(m * (m - 1) / 2) => O(d * m^2)
Knockout: Big O(m) => O(d * m)
{% endhighlight %}


## Probability
{% highlight text %}
P(w) = 0.45
P(r) = 0.3
P(w|r) = 0.99
P(w|r) = P(w,r) / P(r)
P(w,r) = P(w|r) * P(r) = 0.99 * 0.3 = 0.297
{% endhighlight %}

### Question 1
{% highlight text %}
What is P(r|~w)?
P(r|~w) = P(r,~w) / P(~w)
P(~w) = 1 - P(w) = 0.55
P(r,~w) = P(~w|r) * P(r)
P(~w|r) = 1 - P(w|r) = 0.01
P(r,~w) = 0.01 * 0.3 = 0.003
P(r,~w) / P(~w) = 0.003 / 0.55 = 0.005454545
trunc: 0.0054
{% endhighlight %}

### Question 2
{% highlight text %}
What is P(r|w)?
P(r|w) = P(w,r) / P(w)
P(r|w) = 0.297 / 0.45 = 0.66
{% endhighlight %}

### Question 3
{% highlight text %}
E[x] = 0.7 or P(X = h) * 1
{% endhighlight %}

### Question 4
{% highlight text %}
Expected number of children town U?
E[X] = 1
Expected number of children town C?
2^-1 * 1 + 2^-2 * 2 + 2^-3 * 3... = 2
E[X] = 2... I think...
{% endhighlight %}

### Question 5
{% highlight text %}
Boy girl ratio at the end of one generation?
Town U: 1:1
Town C: 1:1
Males: count * probability = 1*1
Females: 0 * 2^-1 + 1 * 2^-2 + 2 * 2^-3 + 3 * 2^-4 + ... = 1
I should really look up the math on this problem
{% endhighlight %}

## Boosting with Ada Boosting

### Question 1
{% highlight text %}
The initial weight vector is 1/10 because there are 10 items.
{% endhighlight %}

### Question 2
{% highlight text %}
First learner is if y > 4 then + else -
{% endhighlight %}

### Question 3
{% highlight text %}
One mistake therefore [(et = (1/10) / 1) = 1/10]
{% endhighlight %}

### Question 4
{% highlight text %}
αt = 0.5 * ln(0.9 / 0.1) = 1.09861228867
{% endhighlight %}

### Question 5
{% highlight text %}
Dt+1(i) = Dt(i) / Zt * exp(αt) if missed
Dt+1(i) = Dt(i) / Zt * exp(-αt) if correct
Dt(i) = (1/10)
Zt = 1
αt = 1.09861228867
Dt+1(i) = 1/10 * exp(1.09861228867) = 0.3 if missed
Dt+1(i) =  1/10 * exp(-1.09861228867) = 0.03 if correct
Index 4: is correct therefore 0.055555
Index 7: is missed therefore 0.5
{% endhighlight %}

### Question 6
{% highlight text %}
First learner is if y > 8 then + else - misclassified: 4
First learner is if y > 9 then + else - misclassified: 4
First learner is if x > 11 then + else - misclassified: 4
I'll choose x > 11 why not?
et = 4 * 0.0555555 / (0.5 + 9 * 0.0555555) = 0.2222222222 = 0.2222222
{% endhighlight %}

### Question 7
{% highlight text %}
αt = 0.5 * ln((1 - 0.2222) / 0.2222) = 0.626381
{% endhighlight %}

### Question 8
{% highlight text %}
0.626381 * h2 + 1.09861 * h1
{% endhighlight %}

## Naive Bayes

### Question 1
{% highlight text %}
P(Y = <=50K) == 0.7510775147536636
{% endhighlight %}

### Question 2
{% highlight text %}
P(X = Bachelors | Y = >50K) == 0.28273295227967565
{% endhighlight %}

### Question 3
{% highlight text %}
P(correct) == 0.7940239043824702
{% endhighlight %}

