CSListView = require "./cs.list_view"

module.exports = class CSSamplesList extends CSListView

  @TOGGLE_FAV_SHORTCUT: "⌃+f"
  @ITEM_SIZE: 42
  FIRST_ITEM_IDX: 0

  className: "samples"
  itemClassName: "sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"
  activeItemIdx: @FIRST_ITEM_IDX
  isVisible: no

  constructor: (selector, @menu, colors) ->
    @items = []
    @itemSelector = '.' + @itemClassName
    @container = $(selector)
    @container.on "dblclick", @itemSelector, @onDblClick
    @container.on "click", ".#{ @itemClassName }__fav-btn", @onFavBtnClick
    jwerty.key CSSamplesList.TOGGLE_FAV_SHORTCUT, @onFavShortcutPressed

    super

    @el = $(".samples", @el)
    @addColorSample(color, yes) for color in colors
    @selectItemWithIndex @FIRST_ITEM_IDX
    @checkIsEmpty()

  addColorSample: (color, silent = no, isFavorite = no) ->
    @items.push(color)
    @checkIsEmpty() unless silent
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

  removeColorSample: (color) ->
    @items = (item for item in @items when item isnt color)
    @checkIsEmpty()

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
    evt.stopPropagation() # Do not select the item when toggling favorite
    @toggleFavorite $(evt.target).parent()

  onFavShortcutPressed: (evt) =>
    evt.preventDefault()
    @toggleFavorite(@getSelectedItem()) if @isVisible

  toggleFavorite: ($sample) ->
    $sample.toggleClass("#{ @itemClassName }_fav")
    eventType = if @isFavorite($sample) then "added" else "removed"
    $(document).trigger("favorite:#{eventType}", $sample.css('background-color'))

  isFavorite: (el) ->
    $(el).hasClass("#{ @itemClassName }_fav")

  checkIsEmpty: =>
    if @items.length
      @el.removeClass("#{@className}_empty")
      $(".#{@className}__empty_msg", @el).remove()
    else
      @el.addClass("#{@className}_empty")
      @el.append(@getEmptyStateHTML())

  getEmptyStateHTML: ->
    "<span class='#{@className}__empty_msg'>List is empty...<span>"
