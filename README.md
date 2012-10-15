dom-o
=====

dom-o is a DSL (DOM-specific language) that unifies HTML markup and CSS style into JavaScript syntax, by providing global functions for HTML5 elements and CSS declarations. To see it in action, head over to [JSBin](http://jsbin.com/egapim/1/edit).

Features
--------

- Most of what you'd want from HAML or LESS, in pure JavaScript.
- Small, dependency-free footprint (less than 1KB minizipped).
- Straight from JS to DOM without HTML reduces XSS attack vectors.
- Sugars well with (but completely agnostic to) CoffeeScript.

Example
-------

```javascript
document.replaceChild(

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
      "For more details about dom-o, see the source: ",
      A({href: "//github.com/jed/dom-o/blob/master/dom-o.js"}, "View source")
    )
  )
)

, document.documentElement)

function roundedCorners(radius) {
  return {
    borderRadius       : radius,
    WebkitBorderRadius : radius,
    MozBorderRadius    : radius
  }
}
```

API
---

dom-o extends the global object with functions for CSS rules and HTML5 element types, allowing you to create DOM objects anywhere in your code without compiling templates from separate `script` tags.

### *element*([*attributes*], [*childNodes*...])

This returns a new DOM element of the specified name, with the optionally specified attributes, and child nodes.

*element* can be any of the following valid HTML5 tag names: `A`, `ABBR`, `ACRONYM`, `ADDRESS`, `AREA`, `ARTICLE`, `ASIDE`, `AUDIO`, `B`, `BDI`, `BDO`, `BIG`, `BLOCKQUOTE`, `BODY`, `BR`, `BUTTON`, `CANVAS`, `CAPTION`, `CITE`, `CODE`, `COL`, `COLGROUP`, `COMMAND`, `DATALIST`, `DD`, `DEL`, `DETAILS`, `DFN`, `DIV`, `DL`, `DT`, `EM`, `EMBED`, `FIELDSET`, `FIGCAPTION`, `FIGURE`, `FOOTER`, `FORM`, `FRAME`, `FRAMESET`, `H1`, `H2`, `H3`, `H4`, `H5`, `H6`, `HEAD`, `HEADER`, `HGROUP`, `HR`, `HTML`, `I`, `IFRAME`, `IMG`, `INPUT`, `INS`, `KBD`, `KEYGEN`, `LABEL`, `LEGEND`, `LI`, `LINK`, `MAP`, `MARK`, `META`, `METER`, `NAV`, `NOSCRIPT`, `OBJECT`, `OL`, `OPTGROUP`, `OPTION`, `OUTPUT`, `P`, `PARAM`, `PRE`, `PROGRESS`, `Q`, `RP`, `RT`, `RUBY`, `SAMP`, `SCRIPT`, `SECTION`, `SELECT`, `SMALL`, `SOURCE`, `SPAN`, `SPLIT`, `STRONG`, `STYLE`, `SUB`, `SUMMARY`, `SUP`, `TABLE`, `TBODY`, `TD`, `TEXTAREA`, `TFOOT`, `TH`, `THEAD`, `TIME`, `TITLE`, `TR`, `TRACK`, `TT`, `UL`, `VAR`, `VIDEO`, or `WBR`.

The first argument is an optional attributes object, mapping camelCased attribute names to attribute values.

All subsequent arguments are optional and appended as child nodes, with any non-DOM arguments turned into text nodes.

### CSS(*selector*, [*properties*...])

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
