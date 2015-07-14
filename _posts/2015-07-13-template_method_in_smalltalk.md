---
layout: post
title: "Template Method Design Pattern"
description: ""
category: 'Design Patterns'
tags: []
---
{% include JB/setup %}

## The Template Method
The template method is a tool to prototype algorithms which follow a general
pattern but need customization. In this example we will be using baking a cake.

### The Vanilla Baker
First we have the vanilla cake baker. The baker API is quite simple. A baker
has method `bakeCake` and returns a cake for the given baker.

{% highlight smalltalk %}
VanillaCakeBaker>>bakeCake
    | ingredients batter cake |

    "obtain ingredients for vanilla cake"
    ingredients := Set new.
    ingredients add: (kitchen fetch: #eggs withAmount: 2).
    ingredients add: (kitchen fetch: #milk withCups: 1).
    ingredients add: (kitchen fetch: #flour withCups: 2).
    ingredients add: (kitchen fetch: #vanilla withTeaspons: 2).

    batter := self mix: ingredients.
    cake := self bake: batter.
    self addFrosting: cake.
    ^ cake
{% endhighlight %}

We can notice the process as follows:

1. fetch ingredients (#eggs, #milk, #flour, #vanilla)
2. mix ingredients
3. bake batter
4. add frosting
5. return cake

### The Chocolate Baker
Now, comes the chocolate cake baker.

{% highlight smalltalk %}
ChocolateCakeBaker>>bakeCake
    | ingredients batter cake |

    "obtain ingredients for chocolate cake"
    ingredients := Set new.
    ingredients add: (kitchen fetch: #eggs withAmount: 2).
    ingredients add: (kitchen fetch: #flour withCups: 2).
    ingredients add: (kitchen fetch: #milk withCups: 1).
    ingredients add: (kitchen fetch: #cocoa withCups: 0.75).
    ingredients add: (kitchen fetchDash: #salt).

    batter := self mix: ingredients.
    cake := self bake: batter.
    self addFrosting: cake.
    self addSprinkles: cake.
    self addCandles: cake.
    ^ cake
{% endhighlight %}

We can notice the process as follows:

1. fetch ingredients (#eggs, #milk, #flour, #cocoa)
2. mix ingredients
3. bake batter
4. add frosting
5. add sprinkles
6. add candles
7. return cake

Wow. There is a lot of duplication.

### Reflection
It is important to realize most of time this occurs in development, we start off
with what appears to be two orthogonal business features. It is not until we
are finished coding up our solutions (in this case VanillaCakeBaker and
ChocolateCakeBaker), that we notice the duplication. Taking the time out now
to refactor will yield a positive return on investment in the future.

### Refactor
We notice we can combine the steps.

1. fetch ingredients
2. mix ingredients
3. bake batter
4. return cake

Now, its hard to tell but we also include a decorate method with is in charge
of frosting for vanilla and frosting, sprinkles, and candles for chocolate.

We can now implement the template method strategy by making a base baker.

### Base CakeBake
{% highlight smalltalk %}
CakeBaker>>bakeCake
    | ingredients batter cake |

    "template method for baking a cake"

    ingredients := fetchIngredients.
    batter := self mix: ingredients.
    cake := self bake: batter.
    self decorate: cake.

    ^ cake
CakeBaker>>fetchIngredients
    self subclassResponsibility
CakeBaker>>mix: ingredients
    ^ HeterogenousMixture from: ingredients
CakeBaker>>bake: batter
    ^ kitchen oven cook: batter at: 425 for: (20 minutes)
CakeBaker>>decorate: cake
{% endhighlight %}

### New VanillaCakeBaker
{% highlight smalltalk %}
VanillaCakeBaker>>fetchIngredients
    | ingredients |

    ingredients := Set new.

    ingredients add: (kitchen fetch: #eggs withAmount: 2).
    ingredients add: (kitchen fetch: #milk withCups: 1).
    ingredients add: (kitchen fetch: #flour withCups: 2).
    ingredients add: (kitchen fetch: #vanilla withTeaspons: 2).

    ^ ingredients
VanillaCakeBaker>>decorate: cake
    self addFrosting: cake.
{% endhighlight %}

### New ChocolateCakeBaker
{% highlight smalltalk %}
ChocolateCakeBaker>>fetchIngredients
    | ingredients |

    ingredients := Set new.

    ingredients add: (kitchen fetch: #eggs withAmount: 2).
    ingredients add: (kitchen fetch: #flour withCups: 2).
    ingredients add: (kitchen fetch: #milk withCups: 1).
    ingredients add: (kitchen fetch: #cocoa withCups: 0.75).
    ingredients add: (kitchen fetchDash: #salt).

    ^ ingredients
ChocolateCakeBaker>>decorate: cake
    self addFrosting: cake.
    self addSprinkles: cake.
    self addCandles: cake.
{% endhighlight %}

Great! Now when we instantiate a ChocolateCakeBaker or VanillaCakeBaker
they will come built with a bakeCake method working out of the box.
