class CS.HistoryList extends CS.ListView

  itemSelector: ".menu__sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"

  constructor: ->
    @isVisible = yes # History is always visible
    super

  addColorSample: (color) ->
    $sample = $("<li class='menu__sample menu__sample_1 active'></li>").css('background-color', color)
    @el.find('.active').removeClass 'active'
    @el.prepend $sample
    console.log color
