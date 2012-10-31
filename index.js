var Domo     = require("./domo")
var Document = require("./document")
var domo = new Domo(new Document)

domo.DOCUMENT = function() {
  var document = new Document

  document.childNodes = Array.prototype.slice.call(arguments)

  return document
}

module.exports = domo.globalize()
