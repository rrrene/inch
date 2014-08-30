Inch::Config.base do
  evaluation do
    grade(:A) do
      scores    80..100
      label     'Seems really good'
      color     :green
    end

    grade(:B) do
      scores    50...80
      label     'Proper documentation present'
      color     :yellow
    end

    grade(:C) do
      scores    1...50
      label     'Needs work'
      color     :red
    end

    grade(:U) do
      scores    0..0
      label     'Undocumented'
      color     :color141
      bg_color  :color105
    end

    priority(:N) do
      priorities  4..99
      arrow       "\u2191"
    end

    priority(:NE) do
      priorities  2...4
      arrow       "\u2197"
    end

    priority(:E) do
      priorities  0...2
      arrow       "\u2192"
    end

    priority(:SE) do
      priorities  -2...0
      arrow       "\u2198"
    end

    priority(:S) do
      priorities  -99...-2
      arrow       "\u2193"
    end
  end
end
