require "stylesheets/screen"
require "stylesheets/howto.scss"


require.ensure [], () ->
  toggleDarkMode = ->
    $("body").toggleClass("theme_dark")

  initialize = =>
    unless @isInitialized
      @isInitialized = yes
      $(".howto").addClass('howto_hidden')
      window.loupe ?= new CSLoupe
      loupe.menu ?= new CSMenu
      loupe.menu.show()

  $("body").removeClass("loading")
  require "script!jwerty"
  CSLoupe = require "./coffeescripts/cs.loupe"
  CSMenu = require "./coffeescripts/cs.menu"

  jwerty.key "esc", -> initialize()
  jwerty.key "ctrl+d", -> toggleDarkMode()

  # $(document).ready ->
  #   $('.howto__btn').on "click", ->
  #     initialize()

  initialize()
