module.exports = class CSListView

  FIRST_ITEM_IDX: 0

  isVisible: no
  activeItemIdx: -1

  constructor: (selector, @menu) ->
    @el = $(selector)
    @$items = $(@itemSelector, @el)

    @el.on "click", @itemSelector, @onItemClicked
    jwerty.key "#{ @previousItemShortcut }/#{ @nextItemShortcut }", @switchItem

  getItems: ->
    $(@itemSelector, @el)

  getSelectedItem: ->
    $(".active", @el)

  switchItem: (evt, key) =>
    evt.preventDefault()
    if @isVisible
      $items = @getItems()
      dir = if key is @previousItemShortcut then -1 else 1
      @activeItemIdx += dir
      if @activeItemIdx >= $items.length and dir > 0
        @activeItemIdx = @FIRST_ITEM_IDX
      else if @activeItemIdx < @FIRST_ITEM_IDX and dir < 0
        @activeItemIdx = $items.length - 1
      @selectItemWithIndex(@activeItemIdx)

  selectItemWithIndex: (idx) ->
    if @isVisible
      $activeItem = $("#{ @itemSelector }.active", @el)
      $activeItem.removeClass "active"
      $(@getItems().get(idx)).addClass("active")
      @activeItemIdx = idx

  onItemClicked: (evt) =>
    evt.preventDefault()
    $clickedItem = $(evt.target).closest(@itemSelector)
    idx = @getItems().index($clickedItem)
    @selectItemWithIndex(idx)

  show: ->
    @isVisible = yes

  hide: =>
    $activeItem = $("#{ @itemSelector }.active", @el)
    $activeItem.removeClass "active"
    @activeItemIdx = -1
    @isVisible = no
