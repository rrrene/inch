# Inch [![Build Status](https://travis-ci.org/rrrene/inch.png)](https://travis-ci.org/rrrene/inch) [![Code Climate](https://codeclimate.com/github/rrrene/inch.svg)](https://codeclimate.com/github/rrrene/inch) [![Inline docs](http://inch-ci.org/github/rrrene/inch.svg)](http://inch-ci.org/github/rrrene/inch)

`inch` gives you hints where to improve your docs. One Inch at a time.

Take a look at the [project page with screenshots (live and in full color)](http://rrrene.github.io/inch/).

## What can it do?

`inch` is a little bit like Code Climate, but for your inline code documentation (and not a webservice).

It is a command-line utility that suggests places in your codebase where documentation can be improved.

If there are no inline-docs yet, `inch` can tell you where to start.



## Installation

Add this line to your application's Gemfile:

    gem 'inch', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inch



## Usage

To run Inch, simply type

    $ inch

Given a `lib` directory with the following code inside:

```ruby
class Foo
  # A complicated method
  def complicated(o, i, *args, &block)
    # ... snip ...
  end

  # An example of a method that takes a parameter (+param1+)
  # and does nothing.
  #
  # Returns nil
  def nothing(param1)
  end

  def filename
    "#{self.class}_#{id}.foo"
  end
end
```

Inch will suggest that the docs could be improved:

    # Properly documented, could be improved:

    ┃  B  ↑  Foo#complicated

    # Undocumented:

    ┃  U  ↑  Foo
    ┃  U  ↗  Foo#filename

    You might want to look at these files:

    ┃ lib/foo.rb

    Grade distribution (undocumented, C, B, A):  █  ▁ ▄ ▄

    Only considering priority objects: ↑ ↗ →  (use `--help` for options).



## Configuration

By default, Inch looks into `{app,lib}/**/*.rb` for Ruby source files. You can customize this by either passing the desired files to the executable:

    $ inch suggest plugins/**/*.rb

or by creating a file named `.inch.yml` in your project directory:

```yaml
files:
  # define files included in the analysis (defaults to ["{app,lib}/**/*.rb"])
  included:
    - plugins/**/*.rb
  # define files excluded from the analysis (defaults to [])
  excluded:
    # you can use file paths
    - plugins/vendor/sparkr/sparkr.rb
    # or globs
    - plugins/vendor/**/*.rb
    # or regular expressions
    - !ruby/regexp /vendor/
```

As you would expect, `included` sets an array of included files (or globs) and `excluded` sets an array of files, globs or regexes of files to exclude from the evaluation.


## Philosophy

Inch was created to help people document their code, therefore it may be more important to look at **what it does not** do than at what it does.

* It does not aim for "fully documented" or "100% documentation coverage".
* It does not tell you to document all your code (neither does it tell you not to).
* It does not impose rules on how your documentation should look like.
* It does not require that, e.g."every method's documentation should be a single line under 80 characters not ending in a period" or that "every class and module should provide a code example of their usage".

Inch takes a more relaxed approach towards documentation measurement and tries to show you places where your codebase *could* use more documentation.



### The Grade System

Inch assigns grades to each class, module, constant or method in a codebase, based on how complete the docs are.

The grades are:

* `A` - Seems really good
* `B` - Properly documented, but could be improved
* `C` - Needs work
* `U` - Undocumented

Using this system has some advantages compared to plain coverage scores:

* You can get an `A` even if you "only" get 90 out of 100 possible points.
* Getting a `B` is basically good enough.
* Undocumented objects are assigned a special grade, instead of scoring 0%.

The last point might be the most important one: If objects are undocumented, there is nothing to evaluate. Therefore you can not simply give them a bad rating, because they might be left undocumented intentionally.



### Priorities ↑ ↓

Every class, module, constant and method in a codebase is assigned a priority which reflects how important Inch thinks it is to be documented.

This process follows some reasonable rules, like

* it is more important to document public methods than private ones
* it is more important to document methods with many parameters than methods without parameters
* it is not important to document objects marked as `:nodoc:`

Priorities are displayed as arrows. Arrows pointing north mark high priority objects, arrows pointing south mark low priority objects.



### No overall scores or grades

Inch does not give you a grade for your whole codebase.

"Why?" you might ask. Look at the example below:

    Grade distribution (undocumented, C, B, A):  ▄  ▁ ▄ █

In this example there is a part of code that is still undocumented, but
the vast majority of code is rated A or B.

This tells you three things:

* There is a significant amount of documentation present.
* The present documentation seems good.
* There are still undocumented methods.

Inch does not really tell you what to do from here. It suggests objects and
files that could be improved to get a better rating, but that is all. This
way, it is perfectly reasonable to leave parts of your codebase
undocumented.

Instead of reporting

    coverage: 67.1%  46 ouf of 140 checks failed

and leaving you with a bad feeling, Inch tells you there are still
undocumented objects without judging.

This provides a lot more insight than an overall grade could, because an overall grade for the above example would either be an `A` (if the evaluation ignores undocumented objects) or a weak `C` (if the evaluation includes them).

The grade distribution does a much better job of painting the bigger picture.



## Features

Inch is build to parse [YARD](http://yardoc.org/),
[RDoc](http://rdoc.rubyforge.org/) and [TomDoc](http://tomdoc.org/)
style documentation comments, but works reasonably well with unstructured
comments.

These inline-docs below all score an `A` despite being written in different styles:

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

Inch *let's you write your documentation the way you want*.


## Subcommands

It comes with four sub-commands: `suggest`, `stats`, `show`, and `list`


### inch suggest

Suggests places where a codebase suffers a lack of documentation.

    $ inch suggest

    # Properly documented, could be improved:

    ┃  B  ↑  Inch::CLI::Command::BaseList#prepare_list
    ┃  B  ↑  Inch::CodeObject::Ruby::MethodParameterObject#initialize
    ┃  B  ↗  Inch::CLI::Command::Stats#run
    ┃  B  ↗  Inch::CLI::CommandParser#run

    # Not properly documented:

    ┃  C  ↑  Inch::CodeObject::NodocHelper#implicit_nodoc_comment?
    ┃  C  ↑  Inch::CLI::Command::Output::Suggest#initialize
    ┃  C  ↑  Inch::Rake::Suggest#initialize

    # Undocumented:

    ┃  U  ↑  Inch::Evaluation::ConstantObject#evaluate
    ┃  U  ↑  Inch::Evaluation::MethodObject#evaluate
    ┃  U  ↑  Inch::SourceParser#find_object

    You might want to look at these files:

    ┃ lib/inch/code_object/proxy/base.rb
    ┃ lib/inch/code_object/proxy/method_object.rb
    ┃ lib/inch/evaluation/role/object.rb

    Grade distribution (undocumented, C, B, A):  █  ▃ ▁ ▄

    Only considering priority objects: ↑ ↗ →  (use `--help` for options).



### inch stats

Shows you an overview of the codebase.

    $ inch stats

    Grade distribution: (undocumented, C, B, A)

      Overall:  █  ▂ ▁ ▃    439 objects

    Grade distribution by priority:

            ↑   ▁  ▄ █ ▁     10 objects

            ↗   █  ▃ ▁ ▃    302 objects

            →   ▆  ▂ ▁ █     73 objects

            ↘   █  ▁ ▁ ▁     54 objects

            ↓   ▁  ▁ ▁ ▁      0 objects

    Priority distribution in grades: (low to high)

          ↓      ↘      →      ↗      ↑
      U:  ▁ ▁ ▁ ▁ ▁ ▁ ▂ ▂ ▁ █ ▁ ▁ ▁ ▁ ▁   243 objects

      C:  ▁ ▁ ▁ ▁ ▁ ▁ ▁ ▁ ▁ █ ▁ ▁ ▁ ▁ ▁    73 objects

      B:  ▁ ▁ ▁ ▁ ▁ ▁ ▁ ▁ ▁ █ ▂ ▄ ▁ ▁ ▁    19 objects

      A:  ▁ ▁ ▁ ▁ ▁ ▁ ▁ ▄ ▁ █ ▁ ▁ ▁ ▁ ▁   104 objects


    Try `--format json|yaml` for raw numbers.



### inch show

Shows you details about what can be approved in a specific object.

    $ inch show Inch::SourceParser#find_object

    # Inch::SourceParser#find_object

    ┃ -> lib/inch/source_parser.rb:16
    ┃ ------------------------------------------------------
    ┃ Grade: C - Needs work
    ┃ ------------------------------------------------------
    ┃ + Add a comment describing the method
    ┃ + Describe the parameter 'path'
    ┃ + Describe the return type of 'find_object'
    ┃ + Add a code example (optional)
    ┃ ------------------------------------------------------



### inch list

Lists all objects in your codebase with their grades.

    $ inch list

    # Seems really good

    ┃  A  ↑  Inch::CLI::Command::Output::Console#object
    ┃  A  ↗  Inch::CodeObject::Proxy#depth
    ┃  A  ↗  Inch::CLI::Command::Base#description
    ┃  A  ↗  Inch::CodeObject::NodocHelper#nodoc?
    ┃ ...  (omitting 75 objects)

    # Proper documentation present

    ┃  B  ↑  Inch::CLI::Command::Suggest#run
    ┃  B  ↑  Inch::CodeObject::Ruby::MethodParameterObject#initialize
    ┃  B  ↗  Inch::CLI::Command::Stats#run
    ┃  B  ↗  Inch::CLI::CommandParser#run

    # Needs work

    ┃  C  ↑  Inch::CodeObject::NodocHelper#implicit_nodoc_comment?
    ┃  C  ↑  Inch::CLI::Command::Output::Console#initialize
    ┃  C  ↑  Inch::Evaluation::ConstantObject#evaluate
    ┃  C  ↑  Inch::SourceParser#find_object
    ┃ ...  (omitting 248 objects)

    This output omitted 323 objects. Use `--all` to display all objects.



### Rake task

Add this to your `Rakefile`:

    require 'inch/rake'

    Inch::Rake::Suggest.new

This creates a rake task named `inch`. Change the name by passing it to the constructor. Use the `args` config option to add any command-line arguments from `inch suggest --help`.

    require 'inch/rake'

    Inch::Rake::Suggest.new("doc:suggest") do |suggest|
      suggest.args << "--private"
    end





## Limitations

How you document your code is up to you and Inch can't actually tell you how good your docs are.

It can't tell if your code examples work or if you described parameters
correctly or if you have just added `# TODO: write docs` to each and every
method.

It is just a tool, that you can use to find parts in your codebase that are
lacking documentation.



## How is this different from ...?

### Documentation coverage

Documentation coverage checks (like they can be found in
[cane](https://github.com/square/cane) and
[rubocop](https://github.com/bbatsov/rubocop)) look at all code objects and
determine if the found documentation meets a certain threshold/expectation.

Inch takes a different approach as it aims for "properly documented" rather
than "100% coverage".

### Yardstick

[Yardstick](https://github.com/dkubb/yardstick) is a tool that verifies
documentation coverage of Ruby code and is specifically designed for
[YARD-style documentation](http://yardoc.org/). It is a great tool to see
where your docs could benefit from YARD's extra features over RDoc, but, at
the same time, it is very overwhelming when applied to a codebase that does
not yet adhere to YARD's standards.

Inch takes a less YARD specific, more "relaxed" approach: It recognizes
different forms of documentation (even in the same codebase) and assigns
grades instead of coverage measurements. So you can get an "A" rating without
employing every technique YARD has to offer.



## Contributing

1. [Fork it!](http://github.com/rrrene/inch/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request



## Author

René Föhring (@rrrene)



## Credits

Inch would not exist without Loren Segal's [YARD](http://yardoc.org/).



## License

Inch is released under the MIT License. See the LICENSE.txt file for further
details.

For YARD's licensing, see YARD's README under http://yardoc.org/
