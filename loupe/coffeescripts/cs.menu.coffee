class CS.Menu

  activeColor: 0
  activeFormat: 0

  constructor: ->
    @el = $(".menu")
    key 'left, right', @switchColor
    key 'up, down, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0', @switchItem
    key 'enter', @selectColorFormat
    key 'esc', @hide

  switchColor: (evt, handler) =>
    switch handler.key
      when "right"
        @selectHistoryItem 1
      when "left"
        @selectHistoryItem -1

  switchItem: (evt, handler) =>
    switch handler.key
      when "up"
        @selectMenuItem -1
      when "down"
        @selectMenuItem 1
      else
        keyIndex = if handler.key > 0 then (handler.key - 1) else 9
        @selectMenuItem(keyIndex - @activeFormat)
        _.delay @hide, 250

  selectHistoryItem: (dir) ->
    $items = $('.menu__sample', @el)
    @$activeItem ?= $items.closest('.active')
    @$activeItem.removeClass 'active'
    @activeColor += dir
    if @activeColor >= $items.length and dir > 0
      @activeColor = 0
    else if @activeColor < 0 and dir < 0
      @activeColor = $items.length - 1
    @$activeItem = $($items.get(@activeColor))
    @$activeItem.addClass('active')

  selectMenuItem: (dir) ->
    $items = $('.menu__item', @el)
    $activeItem = $('.menu__item.active', @el)
    $activeItem.removeClass 'active'
    @activeFormat += dir
    if @activeFormat >= $items.length and dir > 0
      @activeFormat = 0
    else if @activeFormat < 0 and dir < 0
      @activeFormat = $items.length - 1
    $($items.get(@activeFormat)).addClass('active')

  selectColorFormat: (evt) =>
    evt.preventDefault()
    @hide()

  show: ->
    @el.removeClass 'hidden'
    $(document).trigger 'menu:shown'

  hide: =>
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
