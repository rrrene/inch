# TODOs

* Recognize all relevant options in .yardopts file
  * --plugin
  * --[no-]api API
* Provide reusable context that filters code objects according to the
  visibility options
* Add support for multiple signatures for methods
  (realized via the @overload tag in YARD)

* Think about implicit cases in terms of evaluation:
  * attr_* methods are automatically assigned a docstring and @param tag

* Think about limiting the number of `B`-objects in `inch suggest`
  `inch suggest` shows too many `B`s even though there are still undocumented
  objects in the codebase. this becomes a problem, when one thinks of `B` as
  "good enough", which Inch itself suggests.
