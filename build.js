var fs       = require("fs")
var path     = require("path")
var zlib     = require("zlib")
var uglify   = require("uglify-js")
var coffee   = require("coffee-script")
var template = require("./docs/html")

var domoPath = path.resolve(__dirname, "lib", "domo.js")

fs.readFile(domoPath, "utf8", function(err, data) {
  if (err) throw err

  zlib.gzip(uglify(data), function(err, data) {
    if (err) throw err

    var byteCount = data.length
    var size = Math.round(byteCount / 100) / 10

    var html = template({
      byteCount: byteCount,
      size: size + "kb"
    })

    var htmlPath = path.resolve(__dirname, "index.html")

    fs.writeFile(htmlPath, html, function(err) {
      if (err) throw err
    })
  })
})
