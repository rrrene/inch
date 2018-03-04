require 'term/ansicolor'

module Inch
  module StringExt
    def color(color_name)
      Term::ANSIColor.color(color_name, self)
    end

    def on_color(color_name)
      Term::ANSIColor.on_color(color_name, self)
    end
  end
end

String.send(:include, Inch::StringExt)
