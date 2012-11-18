// domo.js 0.5.7

// (c) 2012 Jed Schmidt
// domo.js is distributed under the MIT license.
// For more details, see http://domo-js.com

!function() {
  // Determine the global object.
  var global = Function("return this")()

  // Valid HTML5 tag names used to generate DOM functions.
  var tags = [
    "A", "ABBR", "ACRONYM", "ADDRESS", "AREA", "ARTICLE", "ASIDE", "AUDIO",
    "B", "BDI", "BDO", "BIG", "BLOCKQUOTE", "BODY", "BR", "BUTTON",
    "CANVAS", "CAPTION", "CITE", "CODE", "COL", "COLGROUP", "COMMAND",
    "DATALIST", "DD", "DEL", "DETAILS", "DFN", "DIV", "DL", "DT", "EM",
    "EMBED", "FIELDSET", "FIGCAPTION", "FIGURE", "FOOTER", "FORM", "FRAME",
    "FRAMESET", "H1", "H2", "H3", "H4", "H5", "H6", "HEAD", "HEADER",
    "HGROUP", "HR", "HTML", "I", "IFRAME", "IMG", "INPUT", "INS", "KBD",
    "KEYGEN", "LABEL", "LEGEND", "LI", "LINK", "MAP", "MARK", "META",
    "METER", "NAV", "NOSCRIPT", "OBJECT", "OL", "OPTGROUP", "OPTION",
    "OUTPUT", "P", "PARAM", "PRE", "PROGRESS", "Q", "RP", "RT", "RUBY",
    "SAMP", "SCRIPT", "SECTION", "SELECT", "SMALL", "SOURCE", "SPAN",
    "SPLIT", "STRONG", "STYLE", "SUB", "SUMMARY", "SUP", "TABLE", "TBODY",
    "TD", "TEXTAREA", "TFOOT", "TH", "THEAD", "TIME", "TITLE", "TR",
    "TRACK", "TT", "UL", "VAR", "VIDEO", "WBR"
  ]

  // Turn a camelCase string into a hyphenated one.
  // Used for CSS property names and DOM element attributes.
  function hyphenify(text) {
    return text.replace(/[A-Z]/g, "-$&").toLowerCase()
  }

  // Cache select Array/Object methods
  var shift = Array.prototype.shift
  var unshift = Array.prototype.unshift
  var concat = Array.prototype.concat
  var has = Object.prototype.hasOwnProperty

  // Export the Domo constructor for a CommonJS environment,
  // or create a new Domo namespace otherwise.
  typeof module == "object"
    ? module.exports = Domo
    : new Domo(global.document).global(true)

  // Create a new domo namespace, scoped to the given document.
  function Domo(document) {
    if (!document) throw new Error("No document provided.")

    this.domo = this

    // Create a DOM comment
    this.COMMENT = function(nodeValue) {
      return document.createComment(nodeValue)
    }

    // Create a DOM text node
    this.TEXT = function(nodeValue) {
      return document.createTextNode(nodeValue)
    }

    // Create a DOM fragment
    this.FRAGMENT = function() {
      var fragment = document.createDocumentFragment()
      var childNodes = concat.apply([], arguments)
      var length = childNodes.length
      var i = 0
      var child

      while (i < length) {
        child = childNodes[i++]

        while (typeof child == "function") child = child()

        if (child == null) child = this.COMMENT(child)

        else if (!child.nodeType) child = this.TEXT(child)

        fragment.appendChild(child)
      }

      return fragment
    }

    // Create a DOM element
    this.ELEMENT = function() {
      var childNodes = concat.apply([], arguments)
      var nodeName = childNodes.shift()
      var element = document.createElement(nodeName)
      var attributes = childNodes[0]

      if (attributes) {
        if (typeof attributes == "object" && !attributes.nodeType) {
          for (var name in attributes) if (has.call(attributes, name)) {
            element.setAttribute(hyphenify(name), attributes[name])
          }

          childNodes.shift()
        }
      }

      element.appendChild(
        this.FRAGMENT.apply(this, childNodes)
      )

      switch (nodeName) {
        case "HTML":
        case "HEAD":
        case "BODY":
          var replaced = document.getElementsByTagName(nodeName)[0]

          if (replaced) replaced.parentNode.replaceChild(element, replaced)
      }

      return element
    }

    // Convenience functions to create each HTML5 element
    var i = tags.length
    while (i--) !function(domo, nodeName) {
      domo[nodeName] =
      domo[nodeName.toLowerCase()] =

      function() {
        unshift.call(arguments, nodeName)
        return domo.ELEMENT.apply(domo, arguments)
      }
    }(this, tags[i])

    // Create a CSS style rule
    this.STYLE.on = function() {
      var selector = String(shift.call(arguments))
      var rules = concat.apply([], arguments)
      var css = selector + "{"
      var i = 0
      var l = rules.length
      var key
      var block

      while (i < l) {
        block = rules[i++]

        switch (typeof block) {
          case "object":
            for (key in block) {
              css += hyphenify(key) + ":" + block[key] + ";"
            }
            break

          case "string":
            css = selector + " " + block + css
            break
        }
      }

      css += "}\n"

      return css
    }

    // Pollute the global scope for convenience.
    this.global = function(on) {
      var values = this.global.values
      var key
      var code

      if (on !== false) {
        global.domo = this

        for (key in this) {
          code = key.charCodeAt(0)

          if (code < 65 || code > 90) continue

          if (this[key] == global[key]) continue

          if (key in global) values[key] = global[key]

          global[key] = this[key]
        }
      }

      else {
        delete global.domo

        for (key in this) {
          if (key in values) {
            if (global[key] == this[key]) global[key] = values[key]
          }

          else delete global[key]
        }
      }

      return this
    }

    // A place to store previous global properties
    this.global.values = {}
  }
}()
