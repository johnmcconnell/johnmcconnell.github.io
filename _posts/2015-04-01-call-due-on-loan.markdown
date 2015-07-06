---
layout: post
title:  "Accounting Checkpoint"
date:   2015-04-01 14:33:34
categories: jekyll update
---

# Accounting Checkpoint

## Example Loans

### Loan #28717056 <- example call due
1. 2010-09-22 - 5th obligation is paid.
2. 2010-10-06 - 6th obligation receives payment. 6th obligation is due.
3. 2010-10-08 - 6th obligation payment is cancelled causing the
   6th obligation to default.
4. 2010-10-20 - A payment comes in paying off the defaulted 6th
   obligation.
5. 2010-10-21 - No payment is applied to the 7th obligation and it defaults.
4. 2010-10-22 - The payment of the defaulted 6th obligation is cancelled.
   Causing the two consecutive defaults, 6th and 7th. Thus,
   triggering a call due effective on 2010-10-21.
5. We do not support cure the call due

### Loan #29912832 <- example charge off
1. 2011-01-21 - Payoff of first obligation
2. 2011-01-25 - Cancel of first obligation payoff causing a default
   effective on 2011-01-22
3. 2011-02-04 - Payoff of the defaulted first obligation. Causing the
   second obligation to default on 2011-02-05.
4. 2011-02-08 - Cancel task of the first obligation payment again.
   Causing the loan to be called due effectively 2011-02-05.
5. 2011-03-23 - Charge off task which is 60 days after 2011-01-22.

{% highlight text %}
Loaner accrues 116.52 of interest cnuapp only 98.87. Cnuapp adjusts
interest on a default when the loan is only called due. We must record
this change or we will accrue too much unrecognized_interest.
{% endhighlight %}

## Not Supported Currently
1. Obligation interest adjustements in chargeoff, calldue, or default tasks.
2. Curring calldue or chargeoff amounts
