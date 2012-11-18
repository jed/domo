boxShadow = (values) ->
  MozBoxShadow    : values
  WebkitBoxShadow : values
  boxShadow       : values

HTML lang: "en",
  HEAD {},
    TITLE "dōmo: Markup, style, and code in one language."

    LINK
      rel: "stylesheet"
      type: "text/css"
      href: "//fonts.googleapis.com/css?family=Titillium+Web:900&subset=latin-ext"

    STYLE type: "text/css",
      (STYLE.on ".#{key}", {color} for key, color of {
        pln: "#000", str: "#080", kwd: "#008", com: "#800", typ: "#606"
        lit: "#066", pun: "#660", opn: "#660", clo: "#660", tag: "#008"
        atn: "#606", atv: "#080", dec: "#606", var: "#606", fun: "red"
      })

    STYLE type: "text/css",
      STYLE.on ".prettyprint"                  , padding: "2px"
      STYLE.on ".linenums"                     , marginTop: "0 auto 0"
      STYLE.on (".L#{n}" for n in [0..8])      , listStyleType: "none"
      STYLE.on (".L#{n}" for n in [1..9] by 2) , background: "#eee"

    STYLE type: "text/css",

      STYLE.on "body"
        background: "#f6f6f6"
        color: "#222"
        fontFamily: "Helvetica, Arial, sans-serif"
        fontSize: "18px"
        lineHeight: "1.5"
        margin: "0 0 2em"
        padding: 0

      STYLE.on ["h1", "h2", "h3", "h4", "p", "ul", "ol", "pre", ".narrow"],
        width: "750px"
        margin: "1em auto"
        display: "block"

      STYLE.on "h1"
        margin: "30px auto -60px auto"
        fontSize: "150px"
        fontFamily: "Titillium Web"

      STYLE.on "a"
        color: "#596C86"

      STYLE.on "a:visited"
        color: "#582525"

      STYLE.on ".sub"
        background: "#fff"
        margin: "1em 0 0"
        padding: "1em 0"
        boxShadow "1px 1px 6px #ccc"

      STYLE.on ["pre", "code"],
        fontSize: "0.9em"
        fontFamily: "Monaco, Courier New, monospace"

      STYLE.on ".github"
        position: "absolute"
        top: 0
        right: 0
        border: 0

      STYLE.on ".why-domo"
        STYLE.on "li"
          marginTop: "15px"

      STYLE.on "code.inline"
        margin: "0 2px"
        padding: "0px 5px"
        border: "1px solid #eee"
        backgroundColor: "#fff"
        borderRadius: "3px"

  BODY onload: "prettyPrint()",
    A href: "https://github.com/jed/domo",
      IMG
        class: "github"
        src: "//s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"
        alt: "Fork me on GitHub"

    H1 "dōmo"
    H2 "Markup, style, and code in one language."

    P {},
      "dōmo lets you write ", (A href: "#html", "HTML markup"), " and ", (A href: "#css", "CSS styles"), " in JavaScript syntax, in the browser and ", (A href: "#server", "on the server"), ". "
      "dōmo is a simpler, easier, and more reliable alternative to template engines and CSS pre-processors, and works well with all the tools you already use."

    P {},
      "You can download ", (A href: "http://domo-js.com/lib/domo.js", "dōmo for the browser"), " (under ", (B "#{Math.ceil(domo.stats.size / 100) / 10}kb"), " minizipped), or install ", (A href: "https://npmjs.org/package/domo", "dōmo for node.js"), "."

    H3 "Example"

    P {},
      "Here's a simple, self-contained example using dōmo in the browser. "
      "This code replaces the existing root HTML element with its own DOM tree, using a simple opacity function as a CSS mixin."

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "html", """
          <!doctype html>
          <script src="domo.js"><\/script>
          <script>
            function opacity(pct) {
              return {opacity: String(pct / 100), filter: "alpha(opacity=" + pct + ")"}
            }

            HTML({lang: "en"},
              HEAD(
                TITLE("Welcome to dōmo"),
                STYLE({type: "text/css"},
                  STYLE.on("body", {textAlign: "center", fontSize: 50}),
                  STYLE.on("h1", opacity(50), {background: "#000", color: "#fff"})
                )
              ),

              BODY(H1("Welcome to dōmo"))
            )
          <\/script>
        """

    P "If you'd like to see a larger, real-world use of dōmo, just view ", (A href: "https://github.com/jed/domo/blob/master/docs/index.coffee", "the source of this very page"), "."

    A name: "why"
    H3 "Why?"

    P "We all know CSS. We all know HTML. We mostly agree that neither is powerful enough to build modern web apps, hence the explosion of ", (A href: "http://lesscss.org", "CSS pre-processors"), " and ", (A href: "http://haml.info", "templating engines"), "."
    P "If we're building tools to improve browser technologies like CSS and HTML, let's build them using another browser technology: JavaScript. Instead of adding incompatible extensions to CSS and HTML, let's first port them to a general-purpose language and do the extending there, where at least our tools can interoperate."
    P "dōmo replaces the syntax of CSS and HTML syntax with JavaScript, leaving the semantics the same. You don't have to learn ad-hoc, underpowered syntax for looping or arithmetic or functions in your styles or markup, you can just use what you already know in JavaScript."
    P "This means you can decouple your architecture from arbitrary implementation details, and render your app wherever it makes the most sense: on the server, on the browser, or both."

    A name: "html"
    H3 "Using dōmo instead of HTML"

    P "dōmo lets you write concise JavaScript views for dynamic content, without having to choose between the lesser evil of verbose DOM code and embedding/compiling/escaping overhead of string templates."

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "js", """
          var withDomo = A({href: "http://domo-js.com"}, "Learn about dōmo")

          var withoutDomo = document.createElement("a")
          withoutDomo.setAttribute("href", "http://domo-js.com")
          withoutDomo.appendChild(document.createTextNode("Learn about dōmo"))

          alert(withDomo.outerHTML == withoutDomo.outerHTML)
        """

    P "dōmo's API is simple: it provides one function for ", (A href: "https://developer.mozilla.org/en-US/docs/HTML/HTML5/HTML5_element_list", "every standard HTML5 element"), ":"

    H4 "domo.", (EM "elementName"), "(", (EM "attributes"), ", ", (EM "childNodes..."), ")"

    P "Each function returns a namesake DOM element, and be accessed by UPPERCASE or lowercase name as a member of the ", (CODE "domo"), " object. These functions can also be ", (A href: "#convenience", "exported to the global namespace"), " for convenience by calling ", (CODE "domo.global(true)"), ", which is done automatically in browsers and other non-commonJS environments."

    P {},
      "The ", (EM "attributes"), " argument is an optional object that maps attribute names to their values. For easier use with JavaScript object literals, all camelCased attribute names are lowercased and hyphenated, so that names like ", (CODE class: "inline", "httpEquiv"), " and ", (CODE class: "inline", "http-equiv"), " are identical."

    P {},
      "The ", (EM "childNodes"), " argument is an optional list of children to be appended to the element. Any child that is already a node (has a ", (CODE class: "inline", "nodeType"), " property) is appended as-is, or converted to a text node otherwise. This allows you to append nodes generated elsewhere, to facilitate DOM composition. "
      "Additional arguments can also be specified, in which case they will be flattened into a single list of children."

    P "Note that in addition to returning the generated element, the ", (CODE "HTML"), ", ", (CODE "HEAD"), ", and ", (CODE "BODY"), " functions will also replace the existing element in the current document."

    P "dōmo provides functions for the following HTML5 DOM elements out of the box:"

    DIV class: "sub",
      CODE class: "narrow", "A ABBR ACRONYM ADDRESS AREA ARTICLE ASIDE AUDIO B BDI BDO BIG BLOCKQUOTE BODY BR BUTTON CANVAS CAPTION CITE CODE COL COLGROUP COMMAND DATALIST DD DEL DETAILS DFN DIV DL DT EM EMBED FIELDSET FIGCAPTION FIGURE FOOTER FORM FRAME FRAMESET H1 H2 H3 H4 H5 H6 HEAD HEADER HGROUP HR HTML I IFRAME IMG INPUT INS KBD KEYGEN LABEL LEGEND LI LINK MAP MARK META METER NAV NOSCRIPT OBJECT OL OPTGROUP OPTION OUTPUT P PARAM PRE PROGRESS Q RP RT RUBY SAMP SCRIPT SECTION SELECT SMALL SOURCE SPAN SPLIT STRONG STYLE SUB SUMMARY SUP TABLE TBODY TD TEXTAREA TFOOT TH THEAD TIME TITLE TR TRACK TT UL VAR VIDEO WBR"

    P "If you need to use non-standard or custom HTML elements outside those provided by dōmo, pass the ", (EM "nodeName"), " of the element as the first argument of the ", (CODE style: "inline", "domo.ELEMENT"), " function:"

    H4 "domo.ELEMENT(", (EM "nodeName"), ", ", (EM "attributes"), ", ", (EM "childNodes..."), ")"

    P "Or if you need DOM comments, just use ", (CODE "domo.COMMENT"), " with the specified node value:"

    H4 "domo.COMMENT(", (EM "nodeValue"), ")"

    P "But dōmo isn't just limited to markup..."

    A name: "css"
    H3 "Using dōmo instead of CSS"

    P "dōmo also lets you write CSS rules in JavaScript just as you would in CSS, by specifying a selector and style block per rule."

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "js", """
          var styleSheet =

          STYLE({type: "text/css"},
            STYLE.on("a", {color: "red"}),
            STYLE.on("*", {margin: 0, padding: 0})
          )

          alert(styleSheet.innerHTML == "a{color:red;}\\n*{margin:0px;padding:0px;}\\n")
        """

    P "dōmo exposes CSS generation through a single function, attached to ", (CODE "domo.STYLE"), ":"

    H4 "domo.STYLE.on(", (EM "selector"), ", ", (EM "properties..."), ")"

    P "This generates the text source for a CSS rule, any number of which can be included in a stylesheet."

    P {},
      "The ", (EM "selector"), " is a string, ", "and the ", (EM "properties"), " are an object mapping property names to their values. "
      "As with DOM attributes, all camelCased attribute names are lowercased and hyphenated for easier use with JavaScript object literals."
      "If multiple property objects are specified, they are rolled into a single object."

    P {},
      "The interesting thing about using JavaScript to render CSS is that you have the full power of the language to make your stylesheets dynamic. "
      "This means you can use plain old JavaScript functions to achieve the same rich CSS variables, mixins, operations, and functions that something like ", (A href: "http://lesscss.org/", "LESS"), " would provide, without any new syntax or compilation overhead, like this:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "js", """
          var blue = "#3B5998"
          var gray = "#3B3B3B"
          var defaultRadius = 10

          function roundedCorners(radius) {
            return {
              borderRadius       : radius,
              WebkitBorderRadius : radius,
              MozBorderRadius    : radius
            }
          }

          var styleSheet =

          STYLE({type: "text/css"},
            STYLE.on("h2", {color: gray}, roundedCorners(defaultRadius)),
            STYLE.on("h1", {color: blue}, roundedCorners(defaultRadius * 2))
          )
        """

    P "dōmo also lets you nest rule declarations within other rule declarations, to help keep your related style declarations together:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "js", """
          var nestedStyles =
          STYLE({type: "text/css"},
            STYLE.on("a", {color: "red"},
              STYLE.on("img", {borderWidth: 0})
            )
          )

          var normalStyles =
          STYLE({type: "text/css"},
            STYLE.on("a", {color: "red"}),
            STYLE.on("a img", {borderWidth: 0})
          )

          alert(nestedStyles.innerHTML == normalStyles.innerHTML)
        """

    P {},
      "Generating your styles on the client means that you don't need to ship redundant vendor-prefixed properties: you know the exact vendor at runtime. "
      "And since the source of a stylesheet with multiple rules is fully concatenated before the DOM node is even created, the overhead in generating styles on the client is minimal. "
      "If this is still a performance concern, you can move the code to the server and use a ", (CODE "LINK"), "element just as with server-side CSS pre-processors. It's your choice."

    A name: "server"
    H3 "Using dōmo on the server"

    P {},
      "dōmo really shines when used to build DOM code on the client. "
      "But since you'll likely need to render an HTML client to run dōmo in the first place, dōmo also ships with a ", (A href: "https://github.com/jed/domo/blob/master/lib/document.js", "window.document shim"), " that mocks just enough of the DOM API to render HTML. "

    P {},
      "Using dōmo on the server is the same as that for the client; just ", (CODE class: "inline", "require('domo')"), " create a DOM, and use the ", (CODE class: "inline", "outerHTML"), " property to serialize it into HTML. "
      "dōmo also adds a top-level ", (CODE class: "inline", "DOCUMENT"), " function that creates a doctype'd HTML document, allowing you to render HTML from an HTTP server like this:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "js", """
          require("domo").global() // pollution is opt-in on CommonJS environments

          var http = require("http")

          http.createServer(function(req, res) {
            res.writeHead(200, {"Content-Type": "text/html"})
            res.end(

              DOCUMENT(
                HTML({lang: "en"},
                  BODY("You accessed ", req.url, " at ", new Date)
                )
              ).outerHTML

            )
          }).listen(80)
        """

    A name: "convenience"
    H3 "Convenience versus cleanliness"

    P {},
      (CODE class: "inline", "domo.global(true)"), " can be called to export all of dōmo's functions to the global object, so that you can call them without using the ", (CODE class: "inline", "domo"), " namespace. "
      "This allows dōmo to mimic an in-code DSL, and given that only uppercase key names are exported, usually won't conflict with existing code. "
      "Note that this is auto-executed by default in the browser and other non-CommonJS environments, and opt-in otherwise."

    P {},
      "However, if you're not cool with polluting the global scope, you still have some options. "
      "Stash a reference to the ", (CODE class: "inline", "domo"), " object by calling ", (CODE class: "inline", "domo.global(false)"), " immediately after the dōmo script is loaded, like this:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "html", """
          <script src="domo.js"><\/script>
          <script>window.domo = domo.global(false)<\/script>
        """

    P "This does two things:"

    OL {},
      LI "It reverts the global object to its original state (much like jQuery's ", CODE(".noConflict()"), " method)."
      LI "It returns the ", (CODE class: "inline", "domo"), " object, which you can then assign for subsequent use."

    P "(Note that ", (CODE class: "inline", "domo.global(false)"), " and ", (CODE class: "inline", "domo.global(true)"), " are idempotent, and can be called multiple times to extend and unextend the global object.)"


    P "Once you have a reference to the ", (CODE class: "inline", "domo"), " object, you have some options about how to access its functions:"

    H4 "Access them directly as ", (CODE class: "inline", "domo"), " object members."

    P "This is safe, but a little verbose:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "javascript", """
          domo = domo.global(false)

          domo.HTML(
            domo.HEAD(domo.TITLE("Hello, world.")),
            domo.BODY("Hello, world.")
          )
        """

    H4 "Assign them to local variables"
    P {},
      "Since all dōmo functions are already bound to the current document object, they don't need to be called as methods. "
      "This is especially nice if you only use a few DOM element types, and your flavor of JavaScript supports destructuring, like ", (A href: "http://coffeescript.org/#destructuring", "CoffeeScript"), " or ", (A href: "http://wiki.ecmascript.org/doku.php?id=harmony:destructuring", "ES6"), "."

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "javascript", """
          {HTML, HEAD, TITLE, BODY} = domo.global(false)

          HTML(
            HEAD(TITLE("Hello, world.")),
            BODY("Hello, world.")
          )
        """

    H4 "Access them using the oft-maligned ", (CODE class: "inline", "with"), " statement."

    P {},
      "Don't just cargo cult ", (A href: "http://www.yuiblog.com/blog/2006/04/11/with-statement-considered-harmful/", "Crockford"), ", ", A(href: "http://www.youtube.com/watch?v=MFtijdklZDo", "use what JavaScript gives you"), ". "
      "As long as you're not assigning members or declaring functions, ", (A {href: "https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Statements/with"}, "the ", (CODE class: "inline", "with"), " statement"), " is a very elegant way of temporarily importing a namespace:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "javascript", """
          domo = domo.global(false)

          with (domo)

          HTML(
            HEAD(TITLE("Hello, world.")),
            BODY("Hello, world.")
          )
        """

    P SMALL "Copyright © Jed Schmidt 2012"

    SCRIPT src: "docs/vendor/prettify.js"
