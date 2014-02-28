class CS.FormatsList extends CS.ListView

  itemSelector: ".menu__item"
  previousItemShortcut: "↑"
  nextItemShortcut: "↓"

  constructor: ->
    super
    jwerty.key '0/1/2/3/4/5/6/7/8/9', @switchAndSelectItem

  onItemClicked: (evt) =>
    super
    _.delay =>
      @menu.confirmSelection(evt)
    , 150

  switchAndSelectItem: (evt, key) =>
    if @isVisible
      keyIndex = if parseInt(key, 10) is 0 then 9 else (parseInt(key, 10) - 1)
      @selectItemWithIndex(keyIndex)

      # Blink selection before closing
      $activeItem = $("#{ @itemSelector }.active", @el)
      _.delay =>
        $activeItem.removeClass "active"
        _.delay =>
          $activeItem.addClass "active"
          _.delay =>
            @menu.confirmSelection(evt)
          , 150
        , 100
      , 50

  selectItemWithIndex: (idx) ->
    super
    $container = $(".menu__formats")
    center = $container.height() / 2
    itemHeight = $(@itemSelector, @el).height()
    itemOffset = itemHeight * (idx + 1)
    if itemOffset > center
      $container.scrollTop(Math.abs(center - itemOffset - itemHeight)) # Try to scroll item in the center
    else
      $container.scrollTop(0)
