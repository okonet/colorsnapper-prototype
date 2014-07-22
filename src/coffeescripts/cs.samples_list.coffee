require "stylesheets/_sample"
CSListView = require "./cs.list_view"

module.exports = class CSSamplesList extends CSListView

  @TOGGLE_FAV_SHORTCUT: "⌃+f"
  @ITEM_SIZE: 42
  FIRST_ITEM_IDX: 0

  itemClassName: "sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"
  activeItemIdx: @FIRST_ITEM_IDX
  isVisible: no

  constructor: (selector, @menu, colors) ->
    @itemSelector = '.' + @itemClassName
    @isVisible = yes # History is always visible
    @container = $(selector)
    @container.on "dblclick", @itemSelector, @onDblClick
    @container.on "click", ".#{ @itemClassName }__fav-btn", @onFavBtnClick
    @container.on "click", ".menu__samples-icon", @toggleVisible
    jwerty.key CSSamplesList.TOGGLE_FAV_SHORTCUT, @onFavShortcutPressed

    super

    @el = $(".samples", @el)
    @addColorSample(color, yes) for color in colors
    @selectItemWithIndex @FIRST_ITEM_IDX

  addColorSample: (color, silent = no, isFavorite) ->
    $sample = $("<li class='#{ @itemClassName }'><i class='sample__fav-btn'></i></li>")
    $sample.css('background-color', color)
    isFavorite ?= @menu.favorites.indexOf(color) isnt -1
    $sample.addClass("#{ @itemClassName }_fav") if isFavorite
    @el.prepend($sample)
    unless silent
      $sample.addClass("#{ @itemClassName }_hidden")
      @selectItemWithIndex @FIRST_ITEM_IDX
      _.defer =>
        $sample.removeClass "#{ @itemClassName }_hidden"

  selectItemWithIndex: (idx) ->
    super
    @el.scrollLeft((CSSamplesList.ITEM_SIZE * idx) - @container.width() / 2 + CSSamplesList.ITEM_SIZE / 2) # Try to scroll item in the center

  updateVisible: ->
    if @isVisible
      @container.addClass("active")
    else
      @container.removeClass("active")

  onDblClick: (evt) =>
    evt.preventDefault()
    @menu.showColorPanel()

  onFavBtnClick: (evt) =>
    evt.preventDefault()
    @toggleFavorite $(evt.target).parent()

  onFavShortcutPressed: (evt) =>
    evt.preventDefault()
    @toggleFavorite(@getSelectedItem()) if @isVisible

  toggleFavorite: ($sample) ->
    $sample.toggleClass("#{ @itemClassName }_fav")

  toggleVisible: (evt) =>
    evt.preventDefault()
    @menu.historyList.isVisible = not @menu.historyList.isVisible
    @isVisible = not @isVisible
    @updateVisible()

