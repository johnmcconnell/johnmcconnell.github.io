---
layout: post
title: "Strategy Design Pattern"
description: ""
category: "design patterns"
tags: [smalltalk, design patterns, strategy]
---
{% include JB/setup %}

## The Strategy Pattern
The strategy design pattern allows a family of algorithms to be interchanged at
runtime. This is accomplished by having the algorithms share the same interface.

### The Problem
We are looking to serialize Elements to disk, socket, file, etc...
Our current legacy system, represents data using a base class of `Element`
with many subclasses like `ElementA`, `ElementB`, etc... Each `Element` has a
`serializeTo` method. Unfornately, there was no architect at the company
when they were building out there database schema so these elements have no
general logic for parsing (blame business requirements, if you feel like it).
In other words, each one needs its own solution for serialization.

{% highlight smalltalk %}
Element>>serializeTo: stream
    self subclassResponsibility
ElementA>>serializeTo: stream
    "serialization code belongs here"
...
ElementZ>>serializeTo: stream
    "serialization code belongs here"
{% endhighlight %}

### Current Approach
The current approach is to have each class have its own `serializeTo:` method
in order to solve the complex serialization logic. I should clarify that there
is nothing inherently wrong with this. Although, we will find out that taking
the time out now to build the correct solution will save us time in the future.

### Strategy Solution
How can we write all the methods needed to support each type of serialization
logic? We can initialize each element with its own strategy object which will
be in charge of serialization.

### Context
Under the strategy pattern the element contains it's own concrete strategy.
Each concrete strategy shares the same interface so they can be swapped at
runtime. For example:

{% highlight smalltalk %}
Element>>serializeStrategy: strategy
    serializeStrategy := strategy
Element>>serializeTo: stream
    serializeStrategy serialize: self to: stream.
SerializeStrategy>>serialize: element to: stream
    self subclassResponsbility
{% endhighlight %}

Notice how we no longer need to implement concrete serialization instructions
for each subclass of `Element`. Now they all share the same way of serializing
through a strategy.

### Example Strategies

We define our strategies following this pattern:

{% highlight smalltalk %}
SerializeStrategyA>>serialize: elementA to: aStream
    "complex logic here"
...
SerializeStrategyZ>>serialize: elementZ to: aStream
    "complex logic here"
{% endhighlight %}

For example, suppose `ElementA` had this serialization code:

{% highlight smalltalk %}
ElementA>>serializeTo: aStream
    "this is a *terrible* example of a JSON serialization method..."

    '{' printOn: aStream.
    '"name": "' printOn: aStream.
    name printOn: aStream.
    '", "value": "' printOn: aStream.
    value printOn: aStream.
    '"}' printOn: aStream.
{% endhighlight %}

Then our `SerializeStrategyA` serialization code will be:

{% highlight smalltalk %}
SerializeStrategyA>>serialize: elementA To: aStream
    "this is a *terrible* example of a JSON serialization method..."

    '{' printOn: aStream.
    '"name": "' printOn: aStream.
    elementA name printOn: aStream.
    '", "value": "' printOn: aStream.
    elementA value printOn: aStream.
    '"}' printOn: aStream.
{% endhighlight %}

The statements are the same as before except we are passing the element to
the method. And now each element is initialized using this code:

{% highlight smalltalk %}
ElementA>>initialize
    "other initialize code"
    serializeStrategy := SerializeStrategyA new.
...
ElementZ>>initialize
    "other initialize code"
    serializeStrategy := SerializeStrategyZ new.
{% endhighlight %}

### Conclusion
Now our application can serialize elements and the logic will be handled
in serialization strategy objects.
