require "stylesheets/tour.scss"
html = require "./tour.html"

$('body menu').prepend(html)


# require.ensure [], () ->
#   $(document).ready ->
#     console.log "Starting product tour"
