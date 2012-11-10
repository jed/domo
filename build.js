var fs     = require("fs")
var path   = require("path")
var zlib   = require("zlib")
var uglify = require("uglify-js")
var coffee = require("coffee-script")
var domo   = require("./").global()
var info   = require("./package")

compileJS()
compileHTML()

function compileJS() {
  var csPath = path.resolve(__dirname, "docs", "index.coffee")
  var jsPath = path.resolve(__dirname, "docs", "index.js")
  var cs = fs.readFileSync(csPath, "utf8")
  var js = coffee.compile(cs, {bare: true})

  fs.writeFileSync(jsPath, uglify(js))
}

function compileHTML() {
  var htmlPath = path.resolve(__dirname, "index.html")
  var domoPath = path.resolve(__dirname, "lib", "domo.js")

  var domo = fs.readFileSync(domoPath, "utf8")
  var minifiedDomo = uglify(domo)

  zlib.gzip(minifiedDomo, function(err, minizippedDomo) {
    if (err) throw err

    var stats = {
      size: minizippedDomo.length,
      version: info.version
    }

    var dom =

    DOCUMENT(
      SCRIPT({src: "lib/domo.js"}),
      SCRIPT("domo.stats=", JSON.stringify(stats)),
      SCRIPT({src: "docs/index.js", charset: "utf-8"}),

      NOSCRIPT(
        H1("JavaScript required."),
        P("This page is a client-side demonstration of dōmo. Please enable JavaScript to view it."),

        META({
          httpEquiv: "refresh",
          content: "5;url=https://github.com/jed/domo"
        })
      )
    )

    fs.writeFileSync(htmlPath, dom.outerHTML)
  })
}
