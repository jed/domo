// WebReflection for Jed's dom-o
// node: var document = require('./document').$document;
// DOM: $document.createElement(); ...
this.$document = function () {
  var
    // utils
    re_sanitizeText = /[<>"']/g,
    ob_sanitizeText = {
      '"': '&quot;',
      "'": '&apos;',
      '<': '&lt;',
      '>': '&gt;'
    },
    cb_sanitizeText = function (c) {
      return ob_sanitizeText[c];
    },
    sanitizeText = function sanitizeText(text) {
      return text.replace(
        re_sanitizeText, cb_sanitizeText
      );
    },
    cannotAvoidClosingTag = /script|SCRIPT|iframe|IFRAME/,

    /* probably YAGNI
    prettyPrint = function prettyPrint(node, level) {
      for(var
        toString = node.toString,
        sep =  Array(++level).join("  "),
        childNodes = node.childNodes, i = 0;
        i < childNodes.length; i++
      ) {
        prettyPrint(childNodes[i++], level);
      }
      node.toString = function () {
        sep = "\n" + sep + toString.call(node) + "\n" + Array(--level).join("  ");
        node.toString = toString;
        return sep;
      };
    },
    */

    // generics
    Attribute = {
      toString: function toString() {
        return this.nodeName + '="' + sanitizeText(this.nodeValue) + '"';
      }
    },
    Element = {
      appendChild: function appendChild(node) {
        node.parentNode = this;
        this.childNodes.push(node);
        return node;
      },
      setAttribute: function setAttribute(name, value) {
        var attribute = document.createAttribute(name);
        attribute.nodeValue = value;
        this.setAttributeNode(attribute);
      },
      setAttributeNode: function setAttributeNode(attribute) {
        this.attributes.push(attribute);
      },
      toString: function toString() {
        var
          attributes = this.attributes.join(' '),
          childNodes = this.childNodes,
          nodeName = this.nodeName
        ;
        return  '<' + nodeName + (
                  attributes.length ? ' ' + attributes : attributes
                ) + (
                  childNodes.length || cannotAvoidClosingTag.test(nodeName) ?
                    '>' + childNodes.join('') + '</' + nodeName + '>' :
                    '/>'
                );
      }
    },
    Node = {
      toString: function toString() {
        return sanitizeText(this.nodeValue);
      }
    },

    // DOM fakes
    document = {
      createAttribute: function (nodeName) {
        return {
          nodeName: nodeName,
          nodeValue: '',
          toString: Attribute.toString
        };
      },
      createElement: function (nodeName) {
        return {
          appendChild: Element.appendChild,
          attributes: [],
          childNodes: [],
          nodeName: nodeName,
          nodeType: 1,
          setAttribute: Element.setAttribute,
          setAttributeNode: Element.setAttributeNode,
          toString: Element.toString
        };
      },
      createTextNode: function (nodeValue) {
        return {
          nodeValue: nodeValue,
          nodeName: '#text',
          nodeType: 3,
          toString: Node.toString
        };
      }
    }
  ;

  /* probably YAGNI
  document.prettyPrint = function (node) {
    prettyPrint(node, 0);
    return ("" + node)
      .replace(/^\s+/, "")
      .replace(/>\n+(\s*)</, ">\n$1<")
      .replace(/\s+$/, "")
    ;
  };
  */

  return document;
}();

// var html = $document.createElement("html").appendChild($document.createElement("head")).appendChild($document.createElement("script")).parentNode.parentNode.appendChild($document.createElement("body")).parentNode;
// alert(html);