---
layout: post
title: "Visitor Design Pattern"
description: ""
category: "design patterns"
tags: [smalltalk, design patterns, visitor]
---
{% include JB/setup %}

### The Problem
We are looking to serialize "elements" to disk, socket, file, etc...
Unfortunately, we just received a call from auditors and we need to support at
least three different ways of serializing the data. Damn, compliance! Our
current legacy system, has a base case of `Element` with subclass `ElementA`
through `ElementZ`. Each `Element` has a `serializeAsXMLTo` method.

{% highlight smalltalk %}
Element>>serializeAsXMLTo: stream
    self subclassResponsibility
ElementA>>serializeAsXMLTo: stream
    "serialization code belongs here"
...
ElementZ>>serializeAsXMLTo: stream
    "serialization code belongs here"
{% endhighlight %}

### Solution
How can we write all of our parse logic in a single serializer and support multiple
types of serialization? Well we have our different serializers visit each element
and run the parse logic there. This is exactly what the visitor pattern
accomplishes. Not only does this better fit our requirements it will also
decrease the amount of code needed to write.

### Accept
Under the visitor pattern the element contains it's own concrete callback to
the object visiting.
Each visitor shares the same interface so they can be swapped at
runtime. For example:

{% highlight smalltalk %}
ElementVisitor>>visitElementA: elementA
    self subclassResponsbility
...
ElementVisitor>>visitElementZ: elementZ
    self subclassResponsbility
Serializer>>stream: aStream
    stream := aStream
Element>>accept: aSerializer
    self subclassResponsbility
ElementA>>accept: aSerializer
    aSerialize visitElementA: self
...
ElementZ>>accept: aSerializer
    aSerialize visitElementZ: self
{% endhighlight %}

Notice how each element invokes a different visit method on the serializer
(also accomplished through method overloading). This allows the serializer
to contain the logic for all the different serializations in one class.

### Example Serializers

Let's suppose our auditors require JSON and XML. Let's also assume our
previous serialization method on `ElementA` looked like:

{% highlight smalltalk %}
ElementA>>serializeAsXMLTo: aStream
    "this is a terrible example of an XML serialization method..."

    '<elementa>' printOn: aStream.

    '<name>' printOn: aStream.
    name printOn: aStream.
    '</name>' printOn: aStream.

    '<value>' printOn: aStream.
    value printOn: aStream.
    '</value>' printOn: aStream.

    '</elementa>' printOn: aStream.
{% endhighlight %}

Now we move that code into:

{% highlight smalltalk %}
XMLSerializer>>visitElementA: elementA
    "this is a terrible example of an XML serialization method..."

    '<elementa>' printOn: stream.

    '<name>' printOn: stream.
    elementA name printOn: stream.
    '</name>' printOn: stream.

    '<value>' printOn: stream.
    elementA value printOn: stream.
    '</value>' printOn: stream.

    '</elementa>' printOn: stream.
{% endhighlight %}

Notice, that we fetch name and value from elementA not self. And we move
it into a JSON serializer as well:

{% highlight smalltalk %}
JSONSerializer>>visitElementA: element
    "this is a *terrible* example of a JSON serialization method..."

    '{' printOn: stream.
    '"name": "' printOn: stream.
    elementA name printOn: stream.
    '", "value": "' printOn: stream.
    elementA value printOn: stream.
    '"}' printOn: stream.
{% endhighlight %}

### Example Runtime code
Now our application can write elements over its client and interchange
strategies.

{% highlight smalltalk %}
App>>main
    | serializer |
    "choose strategy based off of auditor"
    serializer := JSONSerializer new.
    audior = "bob" ifTrue: [
        serializer := XMLSerializer new.
    ]
    serializer stream: (client writeStream).

    elements := "code to create elements here"
    elements do: [ :element|
        element accept: serializer.
    ]
{% endhighlight %}

### Conclusion
And that is it! Now if you wanted to serializer to your own bespoke protocol
just add it as one of the serializers. It is important to remember that the
visitor pattern works best when you want to separate the data from the
algorithm. Accordingly, it allows algorithms to not care how the nodes/data is
traversed but their function on it. It does not work well when there is
algorithmic dependencies between nodes. In short, this allows you to avoid
having to break up the algorithm into different parts on each element.
Instead, you keep the logic centralized in one class. Also, look to see if
multiple algorithms can be solved using the visitor pattern.
