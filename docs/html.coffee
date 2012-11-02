{readFileSync} = require "fs"
{resolve}      = require "path"
domo           = require "../"

module.exports = (data) ->
  json = JSON.stringify data, null, 2

  DOCUMENT type: "html",

    SCRIPT type: "text/coffeescript",
      String readFileSync resolve __dirname, "dom.coffee"

    SCRIPT {src} for src in [
      "lib/domo.js"
      "docs/vendor/prettify.js"
      "docs/vendor/coffee.js"
    ]

    SCRIPT "domo.stats = #{json}"

  .outerHTML
