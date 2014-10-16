CS = require "./cs"
CSSamplesList = require "./cs.samples_list"

module.exports = class CSFavoritesList extends CSSamplesList

  constructor: ->
    super
    @isVisible = no # Favorites should be hidden initially

    $(document).on "favorite:added", (evt, color) =>
      @addColorSample(color)

    $(document).on "favorite:removed", (evt, color) =>
      @removeColorSample(color)

  addColorSample: (color, silent = no) ->
    super(color, silent, yes)

  removeColorSample: (color) ->
    $(@itemSelector, @el).each (idx, el) =>
      @removeFromFavorites $(el) if CS.getColorFromEl(el) is color

  removeFromFavorites: ($el) ->
    removedItemIdx = @getItems().index($el)
    $el.addClass("transition_from-favorites")
    _.delay =>
      $el.css('display', 'none')
      $el.remove()
      if @getItems().length
        # If we remove selected item, another item with same index should be selected after removal
        @selectItemWithIndex(@activeItemIdx) if removedItemIdx is @activeItemIdx
      else
        # Switch to history when nothing left in Favorites
        @hide()
        @menu.historyList.show()
    , 500
