// domo.js 0.5.0

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

  // Detect whether a key is an immediate property of an object.
  function has(object, key) {
    return Object.prototype.hasOwnProperty.call(object, key)
  }

  // Perform a shallow flattening of a list, so that for example
  // `[[1, 2], [3, 4]]` becomes `[1, 2, 3, 4]`.
  function flatten(list) {
    return Array.prototype.concat.apply([], list)
  }

  // Create a new domo namespace, scoped to the given document.
  function Domo(document) {
    var i = tags.length
    var domo = this

    domo.Domo = Domo
    domo.domo = domo
    domo.document = document

    domo.CSS = domo.createCSSRule
    domo.COMMENT = domo.createComment

    // Create a DOM constructor function for every HTML5 tag
    while (i--) !function(nodeName) {
      domo[nodeName] = function() {
        var childNodes = flatten(arguments)
        var attributes = childNodes[0]

        if (childNodes.length) {
          if (typeof attributes != "object" || attributes.nodeType) {
            attributes = null
          }

          else childNodes.shift()
        }

        return domo.createElement(nodeName, attributes, childNodes)
      }
    }(tags[i])
  }

  // Create a DOM element.
  Domo.prototype.createElement = function(nodeName, attributes, childNodes) {
    var doc = this.document
    var el = doc.createElement(nodeName)

    var i

    for (i in attributes) {
      if (has(attributes, i)) el.setAttribute(hyphenify(i), attributes[i])
    }

    var child

    for (i = 0; i < childNodes.length; i++) {
      child = childNodes[i]

      if (typeof child == "function") child = child()

      if (!child || !child.nodeType) child = doc.createTextNode(child)

      el.appendChild(child)
    }

    var replaced

    switch (nodeName) {
      case "HTML":
      case "HEAD":
      case "BODY":
        if (replaced = doc.getElementsByTagName(nodeName)[0]) {
          replaced.parentNode.replaceChild(el, replaced)
        }
    }

    return el
  }

  // Create a DOM comment.
  Domo.prototype.createComment = function(nodeValue) {
    return this.document.createComment(nodeValue)
  }

  // Create a text CSS rule.
  Domo.prototype.createCSSRule = function() {
    var rules = flatten(arguments)
    var selector = rules[0]

    var css = selector + "{"
    var i = 1
    var l = rules.length
    var key
    var block

    while (i < l) {
      block = rules[i++]

      switch (typeof block) {
        case "object":
          for (key in block) {
            css += hyphenify(key) + ":" + block[key]

            if (typeof block[key] == "number") css += "px"

            css += ";"
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
  Domo.prototype.globalize = function() {
    var domo = this
    var values = {}
    var key

    for (key in domo) {
      if (!has(domo, key)) continue

      if (key in global) values[key] = global[key]

      global[key] = domo[key]
    }

    // Undo global scope pollution
    domo.noConflict = function() {
      if (!values) return

      for (key in domo) {
        if (key in values) {
          if (global[key] == domo[key]) global[key] = values[key]
        }

        else delete global[key]
      }

      values = null

      return domo
    }

    return domo
  }

  // Export the Domo constructor for CommonJS environments
  if (typeof module == "object") module.exports = Domo

  // Create a default Domo namespace for browser environments
  if (global.document) new Domo(document).globalize()
}()
