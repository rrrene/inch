---
layout: post
title:
---


# Philosophy

Inch was ***created to help people document their code***, therefore it may be more important to look at what it does *not* do than at what it does.

* It does not aim for "fully documented" or "100% documentation coverage".
* It does not tell you to document all your code (neither does it tell you not to).
* It does not impose rules on how your documentation should look like.
* It does not require that, e.g."every method's documentation should be a single line under 80 characters not ending in a period" or that "every class and module should provide a code example of their usage".

Inch ***takes a more relaxed approach*** towards documentation measurement and tries to show you places where your codebase *could* use more documentation.



## The Grade System

<div class="screenshot">
  <div style="height: 90px; background-image: url(public/images/quickstart-optparse.png); background-position: 0 -324px;"></div>
</div>

Inch ***assigns grades to each class, module, constant or method*** in a codebase, based on how complete the docs are.

The grades are:

* `A` - Seems really good
* `B` - Properly documented, but could be improved
* `C` - Needs work
* `U` - Undocumented

Using this system has some advantages compared to plain coverage scores:

* You can get an `A` even if you "only" get 90 out of 100 possible points.
* Getting a `B` is basically good enough.
* ***Undocumented objects are assigned a special grade***, instead of scoring 0%.

The last point might be the most important one: If objects are undocumented, there is nothing to evaluate. Therefore you can not simply give them a bad rating, ***because they might be left undocumented intentionally***.




<div class="screenshot">
  <div style="height: 20px; background-image: url(public/images/introduction-grade-distribution.png);"></div>
</div>

Inch ***does not give you a grade for your whole codebase***.

"Why?" you might ask. Look at the example above.

***You can see a grade distribution that*** tells you three things:

* There is a significant amount of documented code.
* The present documentation seems really good.
* There are still many undocumented methods.

This ***provides a lot more insight than an overall grade could***, because an overall grade for the above example would either be an `A` (if the evaluation ignores undocumented objects) or a weak `C` (if the evaluation includes them).

The grade distribution ***does a much better job of painting the bigger picture***.



## Priorities  ↑ ↓

<div class="screenshot">
  <div style="height: 20px; background-image: url(public/images/quickstart-optparse.png); background-position: 0 -575px;"></div>
</div>

Every class, module, constant and method in a codebase is assigned a priority which reflects how important Inch thinks it is to be documented.

This process follows some reasonable rules, like

* it is more important to document public methods than private ones
* it is more important to document methods with many parameters than methods without parameters
* it is not important to document objects marked as `:nodoc:`

Priorities are displayed as arrows. Arrows pointing north mark high priority objects, arrows pointing south mark low priority objects.



## Format requirements

Inch ***can handle all forms of inline docs***, but was built with an emphasis on [YARD](http://yardoc.org/), [RDoc](http://rdoc.rubyforge.org/) and [TomDoc](http://tomdoc.org/).


These inline-docs below all score an `A` despite being written in different styles:

<small></small>

```ruby
# Detects the size of the blob.
#
# @example
#   blob_size(filename, blob) # => some value
#
# @param filename [String] the filename
# @param blob [String] the blob data
# @param mode [String, nil] optional String mode
# @return [Fixnum,nil]
def blob_size(filename, blob, mode = nil)
```

<small></small>

```ruby
# Detects the size of the blob.
#
#   blob_size(filename, blob) # => some value
#
# Params:
# +filename+:: String filename
# +blob+:: String blob data
# +mode+:: Optional String mode (defaults to nil)
def blob_size(filename, blob, mode = nil)
```

<small></small>

```ruby
# Public: Detects the size of the blob.
#
# filename - String filename
# blob - String blob data
# mode - Optional String mode (defaults to nil)
#
# Examples
#
#   blob_size(filename, blob)
#   # => some value
#
# Returns Fixnum or nil.
def blob_size(filename, blob, mode = nil)
```


But you don't have to adhere to any specific syntax. This gets an `A` as well:

```ruby
# Returns the size of a +blob+ for a given +filename+.
#
#   blob_size(filename, blob)
#   # => some value
#
def blob_size(filename, blob, mode = nil)
```

Inch ***let's you write your documentation the way you want***.


