# Inch

A documentation measurement tool for Ruby, based on YARD.

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'inch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inch

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/rrrene/inch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODOs

* Recognize all relevant options in .yardopts file
  * --plugin
  * --no-public
  * --protected
  * --private
  * --no-private
  * --[no-]api API
* Generalize filter options for visible code objects
  (adapt from YARD::CLI::Yardoc)
* Update `inch show` to display natural language descriptions of the detected
  roles. Maybe provide current version of show as `inch inspect`
* Add support for multiple method signatures for methods
  (realized via the @overload tag in YARD)
* Add some kind of "pedantic" mode that suggests even "okay" looking objects if they don't meet all the criteria

## License

Inch is released under the MIT License. See the LICENSE file for further details.

For YARD's licensing, see https://github.com/lsegal/yard
