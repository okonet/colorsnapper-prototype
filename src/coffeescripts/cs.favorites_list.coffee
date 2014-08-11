CSSamplesList = require "./cs.samples_list"

module.exports = class CSFavoritesList extends CSSamplesList

  constructor: ->
    super
    @isVisible = no # Favorites should be hidden initially

  addColorSample: (color, silent = no) ->
    super(color, silent, yes)

  removeColorSample: (color) ->
    $(@itemSelector, @el).each (idx, el) =>
      @removeFromFavorites $(el) if $(el).css('background-color') is color

  toggleFavorite: ($sample) ->
    super
    @removeFromFavorites $sample unless $sample.hasClass("#{ @itemClassName }_fav")

  removeFromFavorites: ($el) ->
    removedItemIdx = @getItems().index($el)
    $el.addClass("transition_from-favorites")
    _.delay =>
      $el.css('display', 'none')
      $el.remove()
      # If we remove selected item, another item with same index should be selected after removal
      if removedItemIdx is @activeItemIdx and @getItems().length
        @selectItemWithIndex(@activeItemIdx)
    , 500
