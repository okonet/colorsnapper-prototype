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
          6, 150
        , 100
      , 50
