!function() {
  var root  = this
  var slice = Array.prototype.slice
  var has   = Object.prototype.hasOwnProperty
  var tags  = [
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

  var i = tags.length

  while (i--) !function(nodeName) {
    root[nodeName] = function(attributes) {
      var childNodes = slice.call(arguments, 1)

      if (typeof attributes != "object" || attributes.nodeType || attributes instanceof Array) {
        childNodes.unshift(attributes)
        attributes = null
      }

      return Element(document, nodeName, attributes, childNodes)
    }
  }(tags[i])

  function hyphenify(text) {
    return text.replace(/[A-Z]/g, "-$&").toLowerCase()
  }

  function appendChildren(el, childNodes) {
    var child;
    for (i = 0; i < childNodes.length; i++) {
      child = childNodes[i]
      if (child instanceof Array) {
        appendChildren(el, child)
      }
      else {
        if (!child || !child.nodeType) child = document.createTextNode(child)
        el.appendChild(child)
      }
    }
  }

  function Element(document, nodeName, attributes, childNodes) {
    var child, i, el = document.createElement(nodeName)

    for (i in attributes) if (has.call(attributes, i)) {
      child = document.createAttribute(hyphenify(i))
      child.nodeValue = attributes[i]
      el.setAttributeNode(child)
    }
    appendChildren(el, childNodes);
    return el
  }

  root.CSS = function(selector) {
    var css = selector + "{"
    var i = 1
    var l = arguments.length
    var key
    var block

    while (i < l) {
      block = arguments[i++]

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
}()
