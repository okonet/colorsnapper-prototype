require "stylesheets/screen"
require "stylesheets/howto.scss"

require.ensure [], () ->
  $("body").removeClass("loading")
  require "script!jwerty"
  CSLoupe = require "./coffeescripts/cs.loupe"
  CSMenu = require "./coffeescripts/cs.menu"

  $("body").addClass("theme_dark")

  # $(document).ready ->
  #   $('.howto__btn').on "click", ->
  $(".howto").addClass('howto_hidden')
  window.loupe = new CSLoupe
  loupe.menu = new CSMenu
  loupe.menu.show()
