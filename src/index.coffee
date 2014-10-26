require "stylesheets/screen"
require "script!jwerty"
CSLoupe = require "./coffeescripts/cs.loupe"
CSMenu = require "./coffeescripts/cs.menu"

$(document).ready ->
  console.log "Initializing ColorSnapper..."
  window.loupe = new CSLoupe
  loupe.menu = new CSMenu
  # _.delay ->
  #   loupe.menu.show()
  # , 500
