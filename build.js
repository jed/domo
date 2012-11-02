var fs     = require("fs")
var path   = require("path")
var zlib   = require("zlib")
var uglify = require("uglify-js")
var coffee = require("coffee-script")
var domo   = require("./")

build()

function build() {
  compileJS(throwError)
  compileHTML(throwError)
}

function compileJS(cb) {
  var csPath = path.resolve(__dirname, "docs", "index.coffee")
  var jsPath = path.resolve(__dirname, "docs", "index.js")

  fs.readFile(csPath, "utf8", function(err, data) {
    if (err) return cb(err)

    try { var js = coffee.compile(data, {bare: true}) }
    catch (err) { return cb(err) }

    fs.writeFile(jsPath, uglify(js), cb)
  })
}

function compileHTML(cb) {
  var htmlPath = path.resolve(__dirname, "index.html")

  getSize(function(err, size) {
    if (err) return cb(err)

    var dom =

    DOCUMENT(
      SCRIPT({src: "lib/domo.js"}),
      SCRIPT("domo.size", "=", size),
      SCRIPT({src: "docs/index.js", charset: "utf-8"}),

      NOSCRIPT(
        META({
          httpEquiv: "refresh",
          content: "0;url=https://github.com/jed/domo"
        })
      )
    )

    fs.writeFile(htmlPath, dom.outerHTML, cb)
  })
}

function getSize(cb) {
  var domoPath = path.resolve(__dirname, "lib", "domo.js")

  fs.readFile(domoPath, "utf8", function(err, data) {
    if (err) return cb(err)

    zlib.gzip(uglify(data), function(err, data) {
      if (err) return cb(err)

      cb(null, data.length)
    })
  })
}

function throwError(err) {
  if (err) throw err
}
