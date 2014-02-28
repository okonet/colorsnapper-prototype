class CS.HistoryList extends CS.ListView

  itemSelector: ".menu__sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"
  activeItemIdx: 0

  constructor: ->
    super
    @isVisible = yes # History is always visible
    @newItemBtn = $(".toolbar__item_new")
    @newItemBtn.on "click", @onCreateColorClicked
    @el.on "dblclick", @itemSelector, @onDblClick
    @el.on "dragstart", @itemSelector, @onDragStart
    @el.on "dragend", @itemSelector, @onDragEnd

  addColorSample: (color) ->
    $sample = $("<li class='menu__sample menu__sample_hidden' draggable='true'></li>").css('background-color', color)
    @el.prepend($sample)
    _.defer =>
      $sample.removeClass "menu__sample_hidden"
      @selectItemWithIndex 0

  onCreateColorClicked: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    if evt.altKey
      colorToDuplicate = @getSelectedItem().css("background-color")
      @addColorSample(colorToDuplicate or "rgb(0,0,255)")
      @menu.showColorPanel()
    else
      @menu.hide()
      window.loupe.show()

  selectItemWithIndex: (idx) ->
    super
    @el.scrollLeft((52 * idx)/2) # Try to scroll item in the center

  onDblClick: (evt) =>
    evt.preventDefault()
    @menu.showColorPanel()

  onDragStart: (evt) =>
    @draggedItem = evt.target
    @el.addClass "dragging"
    @newItemBtn.addClass "drop-waiting"
    @newItemBtn.on "dragenter", @onDragEnter
    @newItemBtn.on "dragleave", @onDragLeave
    @newItemBtn.on "dragover", @onDragOver
    @newItemBtn.on "drop", @onDrop

  onDragEnd: (evt) =>
    @draggedItem = null
    @el.removeClass "dragging"
    @newItemBtn.removeClass('drop-over')
    @newItemBtn.removeClass('drop-waiting')
    @newItemBtn.off "dragenter"
    @newItemBtn.off "dragleave"
    @newItemBtn.off "dragover"
    @newItemBtn.off "drop"

  onDragEnter: (evt) =>
    evt.target.classList.add('drop-over')

  onDragLeave: (evt) =>
    evt.target.classList.remove('drop-over')

  onDragOver: (evt) =>
    evt.preventDefault?()
    false

  onDrop: (evt) =>
    evt.preventDefault?()
    colorToDuplicate = $(@draggedItem).css("background-color")
    @addColorSample(colorToDuplicate)
    @menu.showColorPanel()

