class CS.ListView

  activeItemIdx: 0

  constructor: (selector, @menu) ->
    @el = $(selector)
    @$items = $(@itemSelector, @el)

    @el.on "click", @itemSelector, @onItemClicked

    jwerty.key "#{ @previousItemShortcut }/#{ @nextItemShortcut }", @switchItem

  switchItem: (evt, key) =>
    if @isVisible
      @$items = $(@itemSelector, @el)
      dir = if key is @previousItemShortcut then -1 else 1
      @activeItemIdx += dir
      if @activeItemIdx >= @$items.length and dir > 0
        @activeItemIdx = 0
      else if @activeItemIdx < 0 and dir < 0
        @activeItemIdx = @$items.length - 1
      @selectItemWithIndex(@activeItemIdx)

  selectItemWithIndex: (idx) ->
    if @isVisible
      $activeItem = $("#{ @itemSelector }.active", @el)
      $activeItem.removeClass "active"
      $(@$items.get(idx)).addClass("active")
      @activeItemIdx = idx

  onItemClicked: (evt) =>
    evt.preventDefault()
    $clickedItem = $(evt.target).closest(@itemSelector)
    idx = @$items.index($clickedItem)
    @selectItemWithIndex(idx)

  show: ->
    @isVisible = yes

  hide: =>
    @isVisible = no
