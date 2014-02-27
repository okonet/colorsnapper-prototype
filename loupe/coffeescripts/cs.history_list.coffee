class CS.HistoryList extends CS.ListView

  itemSelector: ".menu__sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"
  activeItemIdx: 0

  constructor: ->
    super
    @isVisible = yes # History is always visible
    @el.on "click", ".menu__btn-new", @onCreateColorClicked

  addColorSample: (color) ->
    $sample = $("<li class='menu__sample menu__sample_hidden'></li>").css('background-color', color)
    @el.find('.menu__btn-new').after($sample)
    _.defer =>
      $sample.removeClass "menu__sample_hidden"
      @selectItemWithIndex 0

  onCreateColorClicked: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    colorToDuplicate = @getSelectedItem().css("background-color")
    @addColorSample(colorToDuplicate or "rgb(0,0,255)")
    @menu.showColorPanel()
