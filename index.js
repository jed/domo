var Domo     = require("./domo")
var Document = require("./document")
var domo = new Domo(new Document)

domo.DOCUMENT = function() {
  var document = new Document
  var childNodes = Array.prototype.concat.apply([], arguments)
  var attributes = childNodes[0]

  if (typeof attributes == "object" && !attributes.nodeType) {
    document.doctype.name = attributes.type
    childNodes.shift()
  }

  document.childNodes = childNodes

  return document
}

module.exports = domo.globalize()
