module Foo
  # The problem here is that the @param tag is not given the name of the
  # parameter it documents.
  #
  # @param [Encoding]
  # @return [String]
  def method_with_wrong_param_tag(e)

  end

  # The problem here is that the @param tag does not describe the parameter
  #
  # @param [Encoding] e
  # @return [String]
  def method_with_empty_param_tag_text(e)
  end

  # The problem here is that ...
  #
  # @param *names [Array]
  # @return [String]
  def method_with_splat_parameter(*names)
  end

  # The problem here is that ...
  #
  # @param names [Array]
  # @return [String]
  def method_with_splat_parameter2(*names)
  end
end

module Overloading
  # Creates a {Sass::Script::Value::Color Color} object from red, green, and
  # blue values.
  #
  # @see #rgba
  # @overload rgb($red, $green, $blue)
  # @param $red [Sass::Script::Value::Number] The amount of red in the color.
  #   Must be between 0 and 255 inclusive, or between `0%` and `100%`
  #   inclusive
  # @param $green [Sass::Script::Value::Number] The amount of green in the
  #   color. Must be between 0 and 255 inclusive, or between `0%` and `100%`
  #   inclusive
  # @param $blue [Sass::Script::Value::Number] The amount of blue in the
  #   color. Must be between 0 and 255 inclusive, or between `0%` and `100%`
  #   inclusive
  # @return [Sass::Script::Value::Color]
  # @raise [ArgumentError] if any parameter is the wrong type or out of bounds
  def rgb(red, green, blue)
  end
  # Creates a {Sass::Script::Value::Color Color} from red, green, blue, and
  # alpha values.
  # @see #rgb
  #
  # @overload rgba($red, $green, $blue, $alpha)
  #   @param $red [Sass::Script::Value::Number] The amount of red in the
  #     color. Must be between 0 and 255 inclusive
  #   @param $green [Sass::Script::Value::Number] The amount of green in the
  #     color. Must be between 0 and 255 inclusive
  #   @param $blue [Sass::Script::Value::Number] The amount of blue in the
  #     color. Must be between 0 and 255 inclusive
  #   @param $alpha [Sass::Script::Value::Number] The opacity of the color.
  #     Must be between 0 and 1 inclusive
  #   @return [Sass::Script::Value::Color]
  #   @raise [ArgumentError] if any parameter is the wrong type or out of
  #     bounds
  #
  # @overload rgba($color, $alpha)
  #   Sets the opacity of an existing color.
  #
  #   @example
  #     rgba(#102030, 0.5) => rgba(16, 32, 48, 0.5)
  #     rgba(blue, 0.2)    => rgba(0, 0, 255, 0.2)
  #
  #   @param $color [Sass::Script::Value::Color] The color whose opacity will
  #     be changed.
  #   @param $alpha [Sass::Script::Value::Number] The new opacity of the
  #     color. Must be between 0 and 1 inclusive
  #   @return [Sass::Script::Value::Color]
  #   @raise [ArgumentError] if `$alpha` is out of bounds or either parameter
  #     is the wrong type
  def rgba(*args)
  end

  # Changes one or more properties of a color. This can change the red, green,
  # blue, hue, saturation, value, and alpha properties. The properties are
  # specified as keyword arguments, and replace the color's current value for
  # that property.
  #
  # All properties are optional. You can't specify both RGB properties
  # (`$red`, `$green`, `$blue`) and HSL properties (`$hue`, `$saturation`,
  # `$value`) at the same time.
  #
  # @example
  #   change-color(#102030, $blue: 5) => #102005
  #   change-color(#102030, $red: 120, $blue: 5) => #782005
  #   change-color(hsl(25, 100%, 80%), $lightness: 40%, $alpha: 0.8) => hsla(25, 100%, 40%, 0.8)
  # @overload change_color($color, [$red], [$green], [$blue], [$hue],
  #   [$saturation], [$lightness], [$alpha])
  # @param $color [Sass::Script::Value::Color]
  # @param $red [Sass::Script::Value::Number] The new red component for the
  #   color, within 0 and 255 inclusive
  # @param $green [Sass::Script::Value::Number] The new green component for
  #   the color, within 0 and 255 inclusive
  # @param $blue [Sass::Script::Value::Number] The new blue component for the
  #   color, within 0 and 255 inclusive
  # @param $hue [Sass::Script::Value::Number] The new hue component for the
  #   color, in degrees
  # @param $saturation [Sass::Script::Value::Number] The new saturation
  #   component for the color, between `0%` and `100%` inclusive
  # @param $lightness [Sass::Script::Value::Number] The new lightness
  #   component for the color, within `0%` and `100%` inclusive
  # @param $alpha [Sass::Script::Value::Number] The new alpha component for
  #   the color, within 0 and 1 inclusive
  # @return [Sass::Script::Value::Color]
  # @raise [ArgumentError] if any parameter is the wrong type or out-of
  #   bounds, or if RGB properties and HSL properties are adjusted at the
  #   same time
  def change_color(color, kwargs)
  end

  # Mixes two colors together. Specifically, takes the average of each of the
  # RGB components, optionally weighted by the given percentage. The opacity
  # of the colors is also considered when weighting the components.
  #
  # The weight specifies the amount of the first color that should be included
  # in the returned color. The default, `50%`, means that half the first color
  # and half the second color should be used. `25%` means that a quarter of
  # the first color and three quarters of the second color should be used.
  #
  # @example
  #   mix(#f00, #00f) => #7f007f
  #   mix(#f00, #00f, 25%) => #3f00bf
  #   mix(rgba(255, 0, 0, 0.5), #00f) => rgba(63, 0, 191, 0.75)
  # @overload mix($color1, $color2, $weight: 50%)
  # @param $color1 [Sass::Script::Value::Color]
  # @param $color2 [Sass::Script::Value::Color]
  # @param $weight [Sass::Script::Value::Number] The relative weight of each
  #   color. Closer to `0%` gives more weight to `$color`, closer to `100%`
  #   gives more weight to `$color2`
  # @return [Sass::Script::Value::Color]
  # @raise [ArgumentError] if `$weight` is out of bounds or any parameter is
  #   the wrong type
  def mix(color1, color2, weight = 50)
  end
end

module YardError
  if defined? ::Deprecate
    Deprecate = ::Deprecate
  elsif defined? Gem::Deprecate
    Deprecate = Gem::Deprecate
  else
    class Deprecate; end
  end

  unless Deprecate.respond_to?(:skip_during)
    def Deprecate.skip_during; yield; end
  end
end
