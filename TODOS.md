# TODOs

* Recognize all relevant options in .yardopts file
  * --plugin
  * --[no-]api API
* Provide reusable context that filters code objects according to the
  visibility options
* Add support for multiple signatures for methods
  (realized via the @overload tag in YARD)
* YARD assigns an implicit @return tag to methods ending in a question
  mark -- maybe this is a problem since those methods appear as `C` in
  the output, even if they don't have any other documentation
