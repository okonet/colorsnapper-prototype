class CS.ListView

  activeItemIdx: 0

  constructor: (selector, @menu) ->
    @el = $(selector)
    jwerty.key "#{ @previousItemShortcut }/#{ @nextItemShortcut }", @switchItem

  switchItem: (evt, key) =>
    @selectItem(if key is @previousItemShortcut then -1 else 1) if @isVisible

  selectItem: (dir) ->
    if @isVisible
      $items = $(@itemSelector, @el)
      $activeItem = $("#{ @itemSelector }.active", @el)
      $activeItem.removeClass "active"
      @activeItemIdx += dir
      if @activeItemIdx >= $items.length and dir > 0
        @activeItemIdx = 0
      else if @activeItemIdx < 0 and dir < 0
        @activeItemIdx = $items.length - 1
      $($items.get(@activeItemIdx)).addClass("active")

  show: ->
    @isVisible = yes
    @el.show()

  hide: =>
    @isVisible = no
    @el.hide()
