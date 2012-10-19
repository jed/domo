// WebReflection for Jed's dom-o
var document;
document || (document = function () {
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

    // generics
    Attribute = {
      toString: function toString() {
        return this.nodeName + '="' + sanitizeText(this.nodeValue) + '"';
      }
    },
    Element = {
      appendChild: function appendChild(child) {
        this.childNodes.push(child);
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
        var attributes = this.attributes.join(' ');
        return  '<' + this.nodeName + (
                  attributes.length ? ' ' + attributes : attributes
                ) + '>' +
                  this.childNodes.join('') +
                '</' + this.nodeName + '>';
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
  return document;
}());