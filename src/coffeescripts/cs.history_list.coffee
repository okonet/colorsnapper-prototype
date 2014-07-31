require "stylesheets/_sample"
CSSamplesList = require "./cs.samples_list"

module.exports = class CSHistoryList extends CSSamplesList

  constructor: ->
    super
    @isVisible = yes # History is always visible
    @container.addClass("active") # Add an active class name

  toggleFavorite: ($sample) ->
    super
    if $sample.hasClass("#{ @itemClassName }_fav")
      @addToFavorites $sample
    else
      @removeFromFavorites $sample

  addToFavorites: ($el) ->
    @menu.favoritesList.addColorSample($el.css('background-color'))

  removeFromFavorites: ($el) ->
    @menu.favoritesList.removeColorSample($el.css('background-color'))
