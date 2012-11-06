var Domo = require("./domo")
var Document = require("./document")
var document = new Document
var domo = new Domo(document)

domo.DOCUMENT = function(attributes) {
  var document = new Document

  if (typeof attributes == "object" && !attributes.nodeType) {
    document.doctype.name = attributes.type
    Array.prototype.shift.call(arguments)
  }

  document.appendChild(
    this.FRAGMENT.apply(this, arguments)
  )

  return document
}

domo.global(true)

module.exports = domo
