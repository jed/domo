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
      (RULE ".#{key}", {color} for key, color of {
        pln: "#000", str: "#080", kwd: "#008", com: "#800", typ: "#606"
        lit: "#066", pun: "#660", opn: "#660", clo: "#660", tag: "#008"
        atn: "#606", atv: "#080", dec: "#606", var: "#606", fun: "red"
      })

    STYLE type: "text/css",
      RULE ".prettyprint"                        , padding: 2
      RULE ".linenums"                           , marginTop: "0 auto 0"
      RULE ".L0,.L1,.L2,.L3,.L4,.L5,.L6,.L7,.L8" , listStyleType: "none"
      RULE ".L1,.L3,.L5,.L7,.L9"                 , background: "#eee"

    STYLE type: "text/css",

      RULE "body"
        background: "#eee"
        color: "#222"
        fontFamily: "Helvetica, Arial, sans-serif"
        fontSize: 18
        lineHeight: "1.5"
        margin: "0 0 2em"
        padding: 0

      RULE "h1, h2, h3, h4, p, ul, ol, pre"
        width: 750
        margin: "1em auto"

      RULE "h1"
        margin: "30px auto -60px auto"
        fontSize: 150
        fontFamily: "Titillium Web"

      RULE "a"
        color: "#596C86"

      RULE "a:visited"
        color: "#582525"

      RULE ".sub"
        background: "#fff"
        margin: "1em 0 0"
        padding: "1em 0"
        boxShadow "1px 1px 6px #ccc"

      RULE "pre, code"
        fontSize: "0.9em"
        fontFamily: "Monaco, Courier New, monospace"

      RULE ".github"
        position: "absolute"
        top: 0
        right: 0
        border: 0

      RULE ".why-domo"
        RULE "li"
          marginTop: 15

      RULE "iframe"
        display: "none"

      RULE "textarea"
        width: 500
        height: 300

  BODY onload: "prettyPrint()",
    IFRAME id: "renderer", src: "javascript:0", tabindex: -1

    A href: "https://github.com/jed/domo",
      IMG
        class: "github"
        src: "//s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"
        alt: "Fork me on GitHub"

    H1 "dōmo"
    H2 "Markup, style, and code in one language."

    P {},
      "dōmo lets you write ", A(href: "#html", "HTML markup"), " and ", (A href: "#css", "CSS styles"), " in JavaScript syntax, in the browser and ", (A href: "#server", "on the server"), ". "
      "At ", (B "less than #{Math.ceil(domo.stats.size / 100) / 10}kb"), " of minizipped JavaScript, dōmo is a simpler, easier, and more reliable alternative to template engines and CSS pre-processors."

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
                  RULE("body", {textAlign: "center", fontSize: 50}),
                  RULE("h1", opacity(50), {background: "#000", color: "#fff"})
                )
              ),

              BODY(H1("Welcome to dōmo"))
            )
          <\/script>
        """

    # H3 "Why dōmo?"

    # P {},
    #   "Creating a good workflow for web application development is hard. "
    #   "As our applications become more dynamic and complex, we demand more from the technologies we use, often beyond what they can offer. "

    # P {},
    #   "We want to generate markup more dynamically than "

    #   "We want smarter styles"
    #   "We want code that"

    # UL class: "why-dōmo",
    #   LI B "Reduce your exposure to XSS attacks. "
    #   "Writing straight from JavaScript to DOM without an HTML step means you don't need to rely on a library to sanitize your rendered data because the browser does it for you automatically."

    #   LI B "Eliminate a separate compile step. "
    #   "With dōmo, 'compilation' is done in the same JavaScript process as your code, which means that any syntax errors are thrown with line numbers in the same JavaScript process."

    #   LI B "Don't let implementations drive architectural decisions. "
    #   "If you're writing a view that renders a DOM node, you can write it directly within the rendering code for convenience, and then pull it out into its own file when the size of your app requires it."

    #   LI B "Use JavaScript syntax everywhere. "
    #   "Instead of remembering which HAML or LESS symbols map to which behaviors, like looping or escaping or conditionals or negation, just use JavaScript."

    #   LI B "Decouple your syntax sugar. "
    #   "Instead of choosing a template engine or RULE compiler with the ideal syntax, just use JavaScript, and do your sweetening on a more reliable level. CoffeeScript can go a long way in making DOM building code look like HAML, for example."

    #   LI B "Reduce the number of moving parts. "
    #   "Instead of shipping HTML containing strings that compile into JavaScript functions that return HTML used to create DOM nodes, just use JavaScript to create DOM nodes, potentially eliminating underscore.js/jQuery dependencies at the same time."

    #   LI B "Reuse existing infrastructure. "
    #   "Any tools you use in your JavaScript workflow, such as minification or packaging, can now be used for your styles and markup too. You can even use something like [browserify][browserify] to easily discover all app dependencies and maintain code modularity."

    #   LI B "Lessen the burden of context switching. "
    #   "Whether using JavaScript on both the client and server enables code reuse is debatable, but that it prevents the overhead of switching contexts between languages is less so. It may be subjective, but I think using one language everywhere reduces the congitive overhead for web app development."

    A name: "html"
    H3 "Using dōmo instead of HTML"

    P "dōmo brings the semantics as HTML into JavaScript, by providing a function for "

    A name: "css"
    H3 "Using dōmo instead of CSS"

    A name: "server"
    H3 "Using dōmo on the server"

    P {},
      "dōmo really shines when used to build DOM code on the client. "
      "But since you'll likely need to render an HTML client in the first place, dōmo also ships with a ", (CODE "window.document"), " shim for rendering HTML on the server. "
      "It's a small (under 1KB minizipped) mock DOM implementation with just enough logic to render HTML. "

    P {},
      "Once you've run npm install domo, the API for the server is the same as that for the client. "
      "Just `require('domo')`, create a DOM, and then use the `outerHTML` property to serialize it into HTML."

    P {},
      "dōmo also adds a top-level `DOCUMENT` function for creating an entire HTML document with doctype, like this:"

    A name: "convenience"
    H3 "Convenience versus cleanliness"

    P {},
      "By default, ", CODE("domo.global(true)"), " is auto-executed to export all of dōmo's functions to the global object, allowing you to call them without using the ", CODE("domo"), " namespace. "
      "This allows dōmo to mimic an in-code DSL, and given that only uppercase key names are exported, usually won't conflict with existing code."

    P {},
      "However, if you're not cool with polluting the global scope, you still have some options. "
      "Stash a reference to the ", CODE("domo"), " object by calling ", CODE("domo.global(false)"), " immediately after the dōmo script is loaded, like this:"

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "html", """
          <script src="domo.js"><\/script>
          <script>window.domo = domo.global(false)<\/script>
        """

    P "This does two things:"

    OL {},
      LI "It reverts the global object to its original state (much like jQuery's ", CODE(".noConflict()"), " method)."
      LI "It returns the ", CODE("domo"), " object, which you can then assign for subsequent use."

    P "(Note that ", CODE("domo.global(false)"), " and ", CODE("domo.global(true)"), " are idempotent, and can be called multiple times to extend and unextend the global object.)"


    P "Once you have a reference to the ", CODE("domo"), " object, you have some options about how to access its functions:"

    H4 "Access them directly as ", CODE("domo"), " object members."

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
      "This is especially nice if you only use a few DOM element types, and your flavor of JavaScript supports destructuring, like ", A(href: "http://coffeescript.org/#destructuring", "CoffeeScript"), " or ", A(href: "http://wiki.ecmascript.org/doku.php?id=harmony:destructuring", "ES6"), "."

    DIV class: "sub",
      PRE class: "prettyprint",
        CODE class: "javascript", """
          {HTML, HEAD, TITLE, BODY} = domo.global(false)

          HTML(
            HEAD(TITLE("Hello, world.")),
            BODY("Hello, world.")
          )
        """

    H4 "Access them using the oft-maligned ", CODE("with"), " statement."

    P {},
      "Don't just cargo cult ", A(href: "http://www.yuiblog.com/blog/2006/04/11/with-statement-considered-harmful/", "Crockford"), ", ", A(href: "http://www.youtube.com/watch?v=MFtijdklZDo", "think for yourself"), ". "
      "As long as you're not assigning members or declaring functions, ", A({href: "https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Statements/with"}, "the ", CODE("with"), " statement"), " is a very elegant way of temporarily importing a namespace:"

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

    SCRIPT src: "docs/vendor/prettify.js"
