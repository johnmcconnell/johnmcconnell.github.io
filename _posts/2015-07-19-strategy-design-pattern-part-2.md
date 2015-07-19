---
layout: post
title: "Strategy Design Pattern Part 2"
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
Unfortunately, we just received a call from auditors and we need to support at
least three different ways of serializing the data. Damn, compliance! Our
current legacy system, has a base case of Element with subclass `ElementA`
through `ElementZ`. Each Element has a `serializeTo` method.

{% highlight smalltalk %}
Element>>serializeTo: stream
    self subclassResponsibility
ElementA>>serializeTo: stream
    "serialization code belongs here"
...
ElementZ>>serializeTo: stream
    "serialization code belongs here"
{% endhighlight %}

### Solution
How can we write a single method which supports each type of serialization
logic? We need to be able to let the element know the context or rules by
which to serialize. This is exactly what the strategy pattern accomplishes.
Not only does this better fit our requirements it will also decrease the
amount of code needed to write.

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

### Example Strategy

Let's suppose our auditors require JSON and XML our code would look like:

{% highlight smalltalk %}
JSONSerializeStrategy>>serialize: element to: aStream
    '{' printOn: aStream.

    "Iterate through serializable attributes"
    element attributes do: [ :attribute|
        '"' printOn: aStream.
        attribute name printOn: aStream.
        '":"' printOn: aStream.
        attribute value printOn: aStream.
        '",' printOn: aStream
    ]

    '"}' printOn: aStream.
XMLSerializeStrategy>>serialize: element to: aStream
    "Begin class element tag"
    '<' printOn: aStream.
    self class name printOn: aStream.
    '>' printOn: aStream.

    "Iterate through serializable attributes"
    element attributes do: [ :attribute|
        '<' printOn: aStream.
        attribute name printOn: aStream.
        '>' printOn: aStream.
        attribute value printOn: aStream.
        '</' printOn: aStream.
        attribute name printOn: aStream.
        '>' printOn: aStream.
    ]

    "End class element tag"
    '</' printOn: aStream.
    self class name printOn: aStream.
    '>' printOn: aStream.
{% endhighlight %}

Yes, I realize there are some serious problems with those strategies but
let's please ignore them for the purposes of this exercise.

### Example Runtime code
Now our application can write elements over its client and interchange
strategies.

{% highlight smalltalk %}
App>>main
    | strategy |
    "choose strategy based off of auditor"
    strategy := JSONSerializeStrategy new.
    audior = "bob" ifTrue: [
        strategy := XMLSerializeStrategy new.
    ]

    elements := "code to create elements here"
    elements do: [ :element|
        element serializeStrategy: strategy.
        element serializeTo: (client writeStream).
    ]
{% endhighlight %}

### *Important Note*
In the above implementation, elements are not initialized with their
strategies. Instead the strategies are set with `serializeStrategy:`.
It is perfectly valid to set the serialization strategy of the element
in the initialize method.
