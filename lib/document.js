function Document() {
  this.doctype = new DocType
  this.childNodes = []
}

Document.prototype = {
  nodeType: 9,

  replaceChild: function(){},
  getElementsByTagName: function(){ return [] },

  appendChild: function(child) {
    this.childNodes.push(child)
  },

  createElement: function(nodeName) {
    var element = new Element

    element.nodeName = nodeName.toUpperCase()

    return element
  },

  createTextNode: function(nodeValue) {
    var textNode = new TextNode

    textNode.nodeValue = nodeValue

    return textNode
  },

  createComment: function(nodeValue) {
    var comment = new Comment

    comment.nodeValue = nodeValue

    return comment
  },

  toString: function() {
    return this.doctype + "\n" + this.childNodes.join("")
  },

  get outerHTML() {
    return String(this)
  }
}

function DocType(){}

DocType.prototype = {
  nodeType: 10,

  name: "html",

  toString: function() {
    return "<!DOCTYPE " + this.name + ">"
  }
}

function Attribute(){}

Attribute.prototype = {
  nodeType: 2,

  toString: function() {
    return " " + this.name + "=\"" + escapeHTML(this.value) + "\""
  }
}

function Element() {
  this.attributes = []
  this.childNodes = []
}

Element.voids = {
  area   : true ,
  br     : true ,
  col    : true ,
  embed  : true ,
  frame  : true ,
  hr     : true ,
  img    : true ,
  input  : true ,
  link   : true ,
  meta   : true ,
  param  : true ,
  source : true ,
  wbr    : true
}

Element.prototype = {
  nodeType: 1,

  appendChild: function(child) {
    this.childNodes.push(child)
    child.parentNode = this
  },

  setAttribute: function(name, value) {
    var attribute = new Attribute

    attribute.name = name
    attribute.value = value

    this.attributes.push(attribute)
  },

  toString: function() {
    var nodeName = this.nodeName.toLowerCase()
    var attributes = this.attributes.join("")
    var childNodes = this.childNodes.join("")

    var html = "<" + nodeName + attributes + ">"

    if (!Element.voids[nodeName]) {
      html += childNodes + "</" + nodeName + ">"
    }

    return html
  },

  get outerHTML() {
    return String(this)
  }
}

function TextNode(){}

TextNode.prototype = {
  nodeType: 3,

  toString: function() {
    var nodeValue = this.nodeValue
    var parentNode = this.parentNode

    if (parentNode && parentNode.nodeName != "SCRIPT") {
      nodeValue = escapeHTML(nodeValue)
    }

    return nodeValue
  }
}

function Comment() {}

Comment.prototype = {
  nodeType: 8,

  toString: function() {
    return "<!--" + this.nodeValue + "-->"
  }
}

function escapeHTML(text) {
  return text.replace(escapeHTML.pattern, function(character) {
    return escapeHTML.entities[character]
  })
}

escapeHTML.entities = {
  "&": "&amp;",
  "<": "&lt;",
  ">": "&gt;",
  '"': "&quot;",
  "'": "&#x27;"
}

escapeHTML.pattern = new RegExp(
  Object.keys(escapeHTML.entities).join("|"), "g"
)

module.exports = Document
