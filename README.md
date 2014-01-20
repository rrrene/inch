# Inch

Inch is a documentation measurement tool for Ruby, based on
[YARD](http://yardoc.org/).

It does not simply measure documentation *coverage*, but grades and
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

### inch suggest

Inch can suggest places where a codebase suffers a lack of documentation.

    $ inch suggest

    94 objects seem properly documented (26% of relevant objects).

    # The following objects could be improved:
    ┃  B  ↑  Inch::CLI::Command::Suggest#run
    ┃  B  ↑  Inch::CLI::Command::List#run
    ┃  B  ↑  Inch::CodeObject::Proxy::MethodParameterObject#initialize
    ┃  B  ↗  Inch::CLI::Command::Stats#run
    ┃  B  ↗  Inch::CLI::CommandParser#run
    ┃  B  ↗  Inch::CLI::CommandParser.run
    ┃  B  ↗  Inch::CLI::Command::Base.run
    ┃  B  ↗  Inch::Evaluation::Base#object=
    ┃  B  ↗  Inch::CodeObject::Proxy::Base#object=
    ┃  C  ↑  Inch::CLI::Command::Output::Stats#initialize
    ┃  C  ↑  Inch::CLI::Command::Output::Suggest#initialize
    ┃  C  ↑  Inch::CodeObject::NodocHelper#implicit_nodoc_comment?
    ┃  C  ↑  Inch::CLI::Command::Output::Console#initialize
    ┃  C  ↑  Inch::Evaluation::NamespaceObject#evaluate
    ┃  C  ↑  Inch::Evaluation::ConstantObject#evaluate
    ┃  C  ↑  Inch::SourceParser#find_object

    You might want to look at these files:

    ┃ lib/inch/cli/command/suggest.rb
    ┃ lib/inch/cli/command/list.rb
    ┃ lib/inch/code_object/proxy/method_parameter_object.rb
    ┃ lib/inch/cli/command/stats.rb
    ┃ lib/inch/cli/command_parser.rb

The grades (A, B, C) show how good the present documentation seems.
The arrows (↑ ↗ → ↘ ↓) hint at the importance of the object being documented.


### inch show

Inch can show you details about what can be approved in a specific object.

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

Inch can list all objects in your codebase with their grades.

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

Add this to your Rakefile:

    require 'inch/rake'

    Inch::Rake::Suggest.new

Use the `args` config option to add any command-line arguments from `ìnch suggest --help`.

    require 'inch/rake'

    Inch::Rake::Suggest.new("doc:suggest") do |suggest|
      suggest.args << "--no-protected"
      suggest.args << "--no-private"
    end


## Limitations

Inch can't actually tell how good your docs are, if your code examples work
or if you have just added "TODO: write docs" to each and every method. But
it can make reasonable guesses based on how much and what kind of
documentation is there and recommend places to improve the existing
docs.


## How is this different from ...?

### Documentation coverage

Documentation coverage (like it can be found in cane) simply looks at all
code objects and determines if the found documentation meets a certain
threshold.

Inch takes a different approach as it aims for "proper documentation" rather
than "100% coverage".

### Yardstick

[Yardstick](https://github.com/dkubb/yardstick) is a tool that verifies
documentation coverage of Code and is specifically designed for
[YARD-style documentation](http://yardoc.org/). It is a great tool to see
where your docs could benefit from YARD's extra features over RDoc, but, at
the same time, it is very overwhelming when applied to a codebase that does
not yet adhere to YARD's standards.

Inch takes a less YARD specific, more "relaxed" approach: It recognizes
different forms of documentation (even in the same codebase) and assigns
grades instead of coverage measurements. So you can get an "A" rating without
employing every technique YARD has to offer.


## Contributing

1. Fork it ( http://github.com/rrrene/inch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Authors

* René Föhring (@rrrene)


## Credits

Inch would not exist without Loren Segal's YARD.


## TODOs

* Recognize all relevant options in .yardopts file
  * --plugin
  * --[no-]api API
* Generalize filter options for visible code objects
  (maybe adapt from YARD::CLI::Yardoc)
* Add support for multiple method signatures for methods
  (realized via the @overload tag in YARD)
* Refactor some of the messy CLI::Output classes


## License

Inch is released under the MIT License. See the LICENSE file for further
details.

For YARD's licensing, see YARD's README under http://yardoc.org/
