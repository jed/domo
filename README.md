dōmo
====

dōmo unifies HTML markup and CSS style into one JavaScript syntax (optionally sugared with CoffeeScript). It's a pure JavaScript alternative to HAML and LESS, with a much smaller footprint (currently less than 1KB minizipped).

Demo
----

To see dōmo in action, check out [these slides](http://s3.amazonaws.com/domojs/domo.html#0) and make sure you [view source](view-source:http://s3.amazonaws.com/domojs/domo.html#0) when you're done.

Example
-------

```html
<!DOCTYPE html>

<!-- dōmo doesn't require CoffeeScript, but looks a lot better
     with it. I'm including it here for illustrative purposes,
     but make sure you're compiling on the server. -->
<script src="http://coffeescript.org/extras/coffee-script.js"></script>

<!-- dōmo registers a global function for each HTML5 tag name,
     in upper-case, as well as a `CSS` function for styles. -->
<script src="/domo.js"></script>

<script type="text/coffeescript">
  # CSS mixins are just functions...
  roundedCorners = (radius = 5) ->
    borderRadius       : radius
    WebkitBorderRadius : radius
    MozBorderRadius    : radius

  # ...which we reuse by calling them anywhere.
  # This will create a STYLE element with two
  # styles both extended by the roundedCorners
  # mixin.
  styleSheet =
    STYLE type: 'text/css',
      CSS '.round-white',
        roundedCorners 5
        color: 'white'

      CSS '.rounder-black',
        roundedCorners 10
        color: 'black'

        # we can also nest our CSS rules. the
        # selector for the following will end
        # up as ".rounder-black a". camelCase is
        # automatically converted to hyphens.
        CSS "a",
          textDecoration: "none"

  # now we can stick this stylesheet in
  # the HEAD, which we create just like
  # HTML.
  head =
    # if the first argument is an object,
    # it is handled as an attribute map.
    HEAD {},

      # all subsequent arguments are children.
      META charset: "utf-8"

      META
        name: "viewport"
        content: """
          width=device-width,
          initial-scale=1.0,
          maximum-scale=1.0,
          user-scalable=0
        """

      TITLE "introducing dōmo"

      SCRIPT src: "https://raw.github.com/tmcw/big/gh-pages/big.js"

      # any part of our DOM can be a variable.
      styleSheet

  # create the document element...
  html =
    HTML lang: "en"
      head
      BODY "Hellow, world"

  # ...and stick it in the document
  document.replaceChild html, document.documentElement
</script>
```
