class CS.Menu

  activeColor: 0
  activeFormat: 0

  constructor: ->
    @el = $(".menu")
    @$historyEl = $('.menu__history', @el)
    jwerty.key '←/→', @switchColor
    jwerty.key '↑/↓/0/1/2/3/4/5/6/7/8/9', @switchItem
    jwerty.key 'enter', @selectColorFormat
    jwerty.key 'esc', @hide

  addColor: (color) ->
    $sample = $("<li clsas='menu__sample menu__sample_1 active'></li>").css('background-color', color)
    @$historyEl.find('.active').removeClass 'active'
    @$historyEl.prepend $sample
    console.log color

  switchColor: (evt, key) =>
    if @isVisible
      switch key
        when "→"
          @selectHistoryItem 1
        when "←"
          @selectHistoryItem -1

  switchItem: (evt, key) =>
    if @isVisible
      switch key
        when "↑"
          @selectMenuItem -1
        when "↓"
          @selectMenuItem 1
        else
          keyIndex = if parseInt(key, 10) > 0 then (parseInt(key, 10) - 1) else 9
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
    @isVisible = yes
    @el.removeClass 'hidden'
    $(document).trigger 'menu:shown'

  hide: =>
    @isVisible = no
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
