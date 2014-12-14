require "stylesheets/screen"
require "stylesheets/howto.scss"

require.ensure [], () ->
  require "./tour.coffee"

  $("body").removeClass("loading")
  require "script!jwerty"
  CSLoupe = require "./coffeescripts/cs.loupe"
  CSMenu = require "./coffeescripts/cs.menu"

  start = ->
    $(".howto").addClass('howto_hidden')
    window.loupe = new CSLoupe
    loupe.menu = new CSMenu
    loupe.menu.show()

  # $(document).ready ->
  #   $('.howto__btn').on "click", start
  start()
