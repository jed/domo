domo
=====

domo is a DSL (DOM-specific language) that unifies HTML markup and CSS style into JavaScript syntax, by providing global functions for HTML5 elements and CSS declarations. To see it in action, head over to [JSBin](http://jsbin.com/egapim/45/edit). Available [here](https://raw.github.com/jed/domo/master/domo.js) or on [npm](https://npmjs.org/package/domo).

Features
--------

- Most of what you'd want from HAML or LESS, in pure JavaScript.
- Small, dependency-free footprint (around 1KB minizipped).
- Straight from JS to DOM without HTML reduces XSS attack vectors.
- Sugars well with (but completely agnostic to) CoffeeScript.

Not convinced? Read a [more detailed pitch](https://gist.github.com/3916350).

Example
-------

```html
<!doctype html>
<script>
  HTML({lang: "en"},
    HEAD(
      TITLE("Hello, world"),
      STYLE({type: "text/css"},
        CSS("#container",
          {backgroundColor: "#eee"},
          roundedCorners(5)
        )
      )
    ),

    BODY(
      DIV({id: "container"},
        "For more details about domo, see the source: ",
        A({href: "//github.com/jed/domo/blob/master/domo.js"}, "View source")
      )
    )
  )

  function roundedCorners(radius) {
    return {
      borderRadius       : radius,
      WebkitBorderRadius : radius,
      MozBorderRadius    : radius
    }
  }
</script>
```

API
---

domo provides functions for CSS rules and HTML5 element types, allowing you to create DOM objects anywhere in your code without compiling templates from separate `script` tags.

### domo.noConflict()

By default, domo extends the global object (`window` in the browser or `global` in node) with itself and all of its DOM/CSS functions. This allows you to access them directly, and write code that behaves like a DSL, but without any compilation step.

If polluting the global namespace isn't your style, you can call `domo.noConflict()`. This function restores all overwritten global object properties and returns the original namespace, much like its jQuery namesake.

### domo.{element-name}([{attributes}], [{childNodes}...])

This returns a new DOM element of the specified name, with the optionally specified attributes, and child nodes. If the element name is `HTML`, the current document element will also be replaced with the returned element.

*element* can be any of the following valid HTML5 tag names: `A`, `ABBR`, `ACRONYM`, `ADDRESS`, `AREA`, `ARTICLE`, `ASIDE`, `AUDIO`, `B`, `BDI`, `BDO`, `BIG`, `BLOCKQUOTE`, `BODY`, `BR`, `BUTTON`, `CANVAS`, `CAPTION`, `CITE`, `CODE`, `COL`, `COLGROUP`, `COMMAND`, `DATALIST`, `DD`, `DEL`, `DETAILS`, `DFN`, `DIV`, `DL`, `DT`, `EM`, `EMBED`, `FIELDSET`, `FIGCAPTION`, `FIGURE`, `FOOTER`, `FORM`, `FRAME`, `FRAMESET`, `H1`, `H2`, `H3`, `H4`, `H5`, `H6`, `HEAD`, `HEADER`, `HGROUP`, `HR`, `HTML`, `I`, `IFRAME`, `IMG`, `INPUT`, `INS`, `KBD`, `KEYGEN`, `LABEL`, `LEGEND`, `LI`, `LINK`, `MAP`, `MARK`, `META`, `METER`, `NAV`, `NOSCRIPT`, `OBJECT`, `OL`, `OPTGROUP`, `OPTION`, `OUTPUT`, `P`, `PARAM`, `PRE`, `PROGRESS`, `Q`, `RP`, `RT`, `RUBY`, `SAMP`, `SCRIPT`, `SECTION`, `SELECT`, `SMALL`, `SOURCE`, `SPAN`, `SPLIT`, `STRONG`, `STYLE`, `SUB`, `SUMMARY`, `SUP`, `TABLE`, `TBODY`, `TD`, `TEXTAREA`, `TFOOT`, `TH`, `THEAD`, `TIME`, `TITLE`, `TR`, `TRACK`, `TT`, `UL`, `VAR`, `VIDEO`, or `WBR`.

The first argument is an optional attributes object, mapping camelCased attribute names to attribute values.

All subsequent arguments are optional and appended as child nodes, merging any array arguments. Each child is appended as is if it's already a node (has a `nodeType` property), or converted to a text node otherwise. This allows you to append any DOM node generated elsewhere.

### domo.CSS({selector}, [{properties}...])

This returns a CSS rule string with the specified selector and properties, for use in a stylesheet.

The first argument is a required string representing the CSS selector.

All subsequent arguments are optional objects mapping property names to property values. camelCased property names are converted to lower-case hyphenated names, and number values converted to pixels.

Multiple arguments are merged into a single property list, giving you two of the benefits of using a CSS pre-processor like LESS:

#### 1. Rules can be nested with child rules, so that the following are identical:

```javascript
STYLE({type: "text/css"},
  CSS("a", {color: "red"},
    CSS("img", {borderWidth: 0})
  )
)
```

```javascript
STYLE({type: "text/css"},
  CSS("a", {color: "red"}),
  CSS("a img", {borderWidth: 0})
)
```

#### 2. Plain functions can be used as mix-ins, to minimize common CSS repetition:

```javascript
function roundedCorners(radius) {
  return {
    borderRadius       : radius,
    WebkitBorderRadius : radius,
    MozBorderRadius    : radius
  }
}

STYLE({type: "text/css"},
  CSS("h1", roundedCorners(10)),
  CSS("h2", roundedCorners(5))
)
```
