# Inch

Inch is a documentation measurement tool for Ruby, based on
[YARD](http://yardoc.org/).

It does not measure documentation *coverage*, but grades and
prioritizes code objects to give you hints where to improve your docs.
One Inch at a time.


## Installation

Add this line to your application's Gemfile:

    gem 'inch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inch


## Usage

To run Inch, simply type

    $ inch

Given a `lib` directory with the following code inside:

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

Inch does not report coverage scores for code objects. It assigns grades and shows you the grade distribution rather then an overall grade.

The grades (A, B, C) show how good the present documentation seems. The grade `U` is assigned to all undocumented objects. The arrows (↑ ↗ → ↘ ↓) hint at the importance of the object being documented.


### Inch does not judge

Inch uses grades instead of scores to take a more relaxed approach. You can
get an `A` without employing every trick from a predetermined list of checks.

The reason for using the grade distribution instead of an overall score is
that the distribution says more about your codebase than a coverage percentage
ever could:

    Grade distribution (undocumented, C, B, A):  ▄  ▁ ▄ █

In this example we have a good chunk of code that is still undocumented, but
the vast majority of code is rated A or B. This tells you three things:

* There is a significant amount of documentation present.
* The present documentation seems good.
* There are still undocumented methods.

Inch does not really tell you what to do from here. It suggests objects and
files that could be improved to get a better rating, but that is all.

This way, it is perfectly reasonable to leave parts of your codebase
undocumented. Instead of reporting

    coverage: 67.1%  46 ouf of 140 checks failed

and leaving you with a bad feeling, Inch tells you there are still
undocumented objects without judging.

Inch does not tell you to document all your methods. Neither does it tell you
not to. It does not tell you "methods documentation should be a single line
under 80 characters not ending in a period".



### Limitations

How you document your code is up to you and Inch can't actually tell you how good your docs are.

It can't tell if your code examples work or if you described parameters
correctly or if you have just added `# TODO: write docs` to each and every
method.

It is just a tool, that you can use to find parts of a codebase lacking
documentation.



## Features

Inch is build to parse [YARD](http://yardoc.org/),
[RDoc](http://rdoc.rubyforge.org/) and [TomDoc](http://tomdoc.org/)
style documentation comments, but works reasonably well with unstructured
comments.

It comes with four sub-commands: `suggest`, `stats`, `show`, and `list`



### inch suggest

Suggests places where a codebase suffers a lack of documentation.

    $ inch suggest

    # Properly documented, could be improved:

    ┃  B  ↑  Inch::CLI::Command::BaseObject#prepare_objects
    ┃  B  ↑  Inch::CLI::Command::BaseList#prepare_list
    ┃  B  ↑  Inch::CLI::Command::Suggest#run
    ┃  B  ↑  Inch::CLI::Command::List#run
    ┃  B  ↑  Inch::CodeObject::Proxy::MethodParameterObject#initialize
    ┃  B  ↗  Inch::CLI::Command::Stats#run
    ┃  B  ↗  Inch::CLI::CommandParser#run
    ┃  B  ↗  Inch::CLI::CommandParser.run

    # Not properly documented:

    ┃  C  ↑  Inch::CodeObject::NodocHelper#implicit_nodoc_comment?
    ┃  C  ↑  Inch::CLI::Command::Output::Console#initialize
    ┃  C  ↑  Inch::CLI::Command::Output::Suggest#initialize
    ┃  C  ↑  Inch::Rake::Suggest#initialize

    # Undocumented:

    ┃  U  ↑  Inch::Evaluation::NamespaceObject#evaluate
    ┃  U  ↑  Inch::Evaluation::ConstantObject#evaluate
    ┃  U  ↑  Inch::Evaluation::MethodObject#evaluate
    ┃  U  ↑  Inch::SourceParser#find_object

    You might want to look at these files:

    ┃ lib/inch/code_object/proxy/base.rb
    ┃ lib/inch/code_object/proxy/method_object.rb
    ┃ lib/inch/evaluation/role/constant.rb
    ┃ lib/inch/evaluation/role/method_parameter.rb
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
    ┃  A  ↗  Inch
    ┃  A  ↗  Inch::CodeObject::Proxy::Base#depth
    ┃  A  ↗  Inch::CodeObject::Proxy::Base#height
    ┃  A  ↗  Inch::CLI::Command::Base#description
    ┃  A  ↗  Inch::CodeObject::NodocHelper#nodoc?
    ┃  A  ↗  Inch::CLI::YardoptsHelper#parse_yardopts_options
    ┃  A  ↗  Inch::Evaluation::NamespaceObject
    ┃  A  ↗  Inch::SourceParser
    ┃  A  ↗  Inch::Evaluation::ScoreRange#range=
    ┃ ...  (omitting 75 objects)

    # Proper documentation present

    ┃  B  ↑  Inch::CLI::Command::Suggest#run
    ┃  B  ↑  Inch::CLI::Command::List#run
    ┃  B  ↑  Inch::CodeObject::Proxy::MethodParameterObject#initialize
    ┃  B  ↗  Inch::CLI::Command::Stats#run
    ┃  B  ↗  Inch::CLI::CommandParser#run
    ┃  B  ↗  Inch::CLI::CommandParser.run
    ┃  B  ↗  Inch::CLI::Command::Base.run
    ┃  B  ↗  Inch::Evaluation::Base#object=
    ┃  B  ↗  Inch::CodeObject::Proxy::Base#object=

    # Needs work

    ┃  C  ↑  Inch::CLI::Command::Output::Stats#initialize
    ┃  C  ↑  Inch::CLI::Command::Output::Suggest#initialize
    ┃  C  ↑  Inch::CodeObject::NodocHelper#implicit_nodoc_comment?
    ┃  C  ↑  Inch::CLI::Command::Output::Console#initialize
    ┃  C  ↑  Inch::Evaluation::NamespaceObject#evaluate
    ┃  C  ↑  Inch::Evaluation::ConstantObject#evaluate
    ┃  C  ↑  Inch::SourceParser#find_object
    ┃  C  ↑  Inch::Evaluation::MethodObject#evaluate
    ┃  C  ↗  Inch::CLI::Command::Show#run
    ┃  C  ↗  Inch::CodeObject::Proxy::Base
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
