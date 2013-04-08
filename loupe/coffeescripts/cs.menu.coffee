class CS.Menu

  activeColor: 0
  activeFormat: 0

  constructor: ->
    @el = $(".menu")
    key 'left, right', @switchColor
    key 'up, down', @switchItem
    key 'enter', @selectColorFormat

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

  selectHistoryItem: (dir) ->
    $items = $('.menu__sample', @el)
    $activeItem = $('.menu__sample.active', @el)
    $activeItem.removeClass 'active'
    @activeColor += dir
    if @activeColor >= $items.length and dir > 0
      @activeColor = 0
    else if @activeColor < 0 and dir < 0
      @activeColor = $items.length - 1
    $($items.get(@activeColor)).addClass('active')

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

  hide: ->
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
