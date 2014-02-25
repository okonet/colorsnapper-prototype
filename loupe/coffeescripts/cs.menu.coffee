class CS.Menu

  activeColor: 0
  activeFormat: 0

  constructor: ->
    @el = $(".menu")
    @$historyEl = $('.menu__history', @el)
    jwerty.key '←/→', @switchColor
    jwerty.key '↑/↓', @switchItem
    jwerty.key '0/1/2/3/4/5/6/7/8/9', @switchAndSelectItem
    jwerty.key 'enter', @selectColorFormat
    jwerty.key 'esc', @hide

  addColor: (color) ->
    $sample = $("<li class='menu__sample menu__sample_1 active'></li>").css('background-color', color)
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
    @selectMenuItem(if key is "↑" then -1 else 1) if @isVisible

  switchAndSelectItem: (evt, key) =>
    if @isVisible
      keyIndex = if parseInt(key, 10) is 0 then 9 else (parseInt(key, 10) - 1)
      @selectMenuItem(keyIndex - @activeFormat)

      # Blink selection before closing
      $activeItem = $('.menu__item.active', @el)
      _.delay =>
        $activeItem.removeClass 'active'
        _.delay =>
          $activeItem.addClass 'active'
          _.delay =>
            $activeItem.removeClass 'active'
            _.delay =>
              $activeItem.addClass 'active'
              _.delay @hide, 250
            , 100
          , 100
        , 100
      , 100

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
