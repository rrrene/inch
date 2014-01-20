# Inch

Inch is a documentation measurement tool for Ruby, based on 
[YARD](http://yardoc.org/).

It does not measure documentation coverage, but analyses your code and gives 
tips where to improve your docs. One Inch at a time.

## Installation

Add this line to your application's Gemfile:

    gem 'inch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inch

## Usage

### Suggestions

TODO: Write instructions for `inch suggest` here

### Showing off

TODO: Write instructions for `inch show` here

### Listing

TODO: Write instructions for `inch list` here

## How is this different from ...?

### Documentation coverage

Documentation coverage simple looks at all code objects and determines if the found documentation meets a certain threshold. 

Inch takes a different approach as it aims for "proper documentation" rather than "100% coverage".

### YARDStick

[YARDStick](https://github.com/dkubb/yardstick) is a documentation coverage tool specifically designed for [YARD](http://yardoc.org/) style documentation. It is a great tool to see where your docs could benefit from YARD's features, but, at the same time, it is very overwhelming when applied to a codebase that does not yet adhere to YARD's syntax.

Inch takes a less YARD specific approach: It recognizes different forms of documentation (even in the same codebase) and assigns grades instead of coverage measurements. So you can get an "A" rating without employing every technique YARD has to offer.

## Contributing

1. Fork it ( http://github.com/rrrene/inch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Inch would not be here without Loren Segal's YARD.

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

Inch is released under the MIT License. See the LICENSE file for further details.

For YARD's licensing, see YARD's README under http://yardoc.org/
