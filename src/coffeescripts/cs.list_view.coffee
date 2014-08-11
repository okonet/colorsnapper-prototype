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
    itemsCount = @getItems().length - 1
    idx = itemsCount if idx >= itemsCount # Select the last item if the idx is greater than available items
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
    @updateVisible()

  hide: =>
    $activeItem = $("#{ @itemSelector }.active", @el)
    $activeItem.removeClass "active"
    @activeItemIdx = -1
    @isVisible = no
    @updateVisible()

  toggleVisible: ->
    @isVisible = not @isVisible
    @updateVisible()

  updateVisible: ->
    if @isVisible
      @el.addClass("active")
    else
      @el.removeClass("active")
