{readFileSync} = require "fs"
{resolve}      = require "path"
domo           = require "../"

module.exports = (data) ->

  DOCUMENT type: "html",
    HTML lang: "en",
      HEAD {},
        META charset: "utf-8"

        SCRIPT type: "text/coffeescript",
          String readFileSync resolve __dirname, "dom.coffee"

        SCRIPT {src} for src in [
          "lib/domo.js"
          "docs/vendor/prettify.js"
          "docs/vendor/coffee.js"
        ]

        SCRIPT "domo.stats = " + JSON.stringify data, null, 2

  .outerHTML
