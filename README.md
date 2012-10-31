domo
====

domo is a JavaScript library that pulls HTML markup and CSS style into JavaScript syntax, in the [browser][browser] and on the [server][server]. It's a simpler, easier, and more reliable alternative to template engines and CSS pre-processors. You can find it on [github][domo_github] and [npm][npm].

[browser]: #browser
[server]: #server
[domo_github]: https://raw.github.com/jed/domo/master/domo.js
[npm]: https://npmjs.org/package/domo

Example
-------

The following is a simple, self-contained example using domo in the browser. It generates a DOM tree and replaces the existing documentElement, using a plain old function as a CSS mixin.

```html
<!doctype html>
<script src="domo.js"></script>
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
        BR,
        BR,
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

Why domo?
---------

- **Reduce your exposure to XSS attacks.** Writing straight from JavaScript to DOM without an HTML step means you don't need to rely on a library to sanitize your rendered data because the browser does it for you automatically.

- **Eliminate a separate compile step.** With DOM builders, "compilation" is done in the same JavaScript process as your code, which means that any syntax errors are thrown with line numbers in the same JavaScript process.

- **Don't let implentations drive architectural decisions.** If you're writing a view that renders a DOM node, you can write it directly within the rendering code for convenience, and then pull it out into its own file when the size of your app requires it.

- **Use JavaScript syntax everywhere.** Instead of remembering which [HAML][haml] or [LESS][less] symbols map to which behaviors like looping or escaping or conditionals or negation, just use JavaScript.

[haml]: http://haml.info
[less]: http://lesscss.org

- **Decouple your syntax sugar.** Instead of choosing a template engine or CSS compiler with the ideal syntax, just use JavaScript, and do your sweetening on a more reliable level. [CoffeeScript][coffeescript] can go a long way in [making DOM building code look like HAML][browserver], for example.

[browserver]: https://github.com/jed/browserver.org/blob/master/app.coffee
[coffeescript]: #coffeescript

- **Reduce the number of moving parts.** Instead of shipping HTML containing strings that compile into JavaScript functions that return HTML used to create DOM nodes, just use JavaScript to create DOM nodes, potentially eliminating [underscore][underscore]/[jQuery][jQuery] dependencies at the same time.

[underscore]: http://underscorejs.org/#template
[jQuery]: http://api.jquery.com/html

- **Reuse existing infrastructure.** Any tools you use in your JavaScript workflow, such as minification or packaging, can now be used for your styles and markup too. You can even use something like [browserify][browserify] to easily discover all app dependencies and maintain code modularity.

[browserify]: https://github.com/substack/node-browserify

- **Lessen the burden of context switching.** Whether using JavaScript on both the client and server enables code reuse is debatable, but that it prevents the overhead of switching contexts between languages is less so. It may be subjective, but I think using one language everywhere reduces the congitive overhead for web app development.

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

Using domo for HTML
-------------------

Coming soon.

Using domo for CSS
------------------

Coming soon.

Using domo on the server
------------------------

domo really shines when used to build DOM code on the client. But since you'll likely need to render an HTML client in the first place, domo also ships with a [window.document shim](https://github.com/jed/domo/blob/master/document.js) that can be used to render HTML on the server. It's a small (under 1KB minizipped) mock DOM implementation with just enough logic to render HTML.

Once you've run `npm install domo`, the API for the server is the same as that for the client. Just `require("domo")`, create a DOM, and then use the `outerHTML` property to serialize it into HTML. domo also adds a top-level `DOCUMENT` function for creating an entire HTML document with doctype, like this:

```javascript
require("domo")

var document =

DOCUMENT({type: "html"}
  HTML(
    HEAD(
      SCRIPT({src: "/app.js"})
    ),
    BODY("Loading...")
  )
)

console.log(document.outerHTML)
```

which would render into this:

```html
<!DOCTYPE html>
<html><head><script src="/app.js"></script></head><body>Loading...</body></html>
```

Some things to note about using domo on the server:

- The attributes passed to DOCUMENT are optional, and the `type` attribute defaults to `html`.
- All text node strings and attribute values are HTML-escaped.
- The `outerHTML` is available on the document and every element, and is a lazy ES5 getter that calls `toString()`.

Using domo with CoffeeScript
----------------------------

Coming soon.
