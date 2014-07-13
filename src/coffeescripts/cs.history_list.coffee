require "stylesheets/_sample"
CSListView = require "./cs.list_view"

module.exports = class CSHistoryList extends CSListView

  @INITIAL_COLORS: [
    "#f55e00"
    "#279189"
    "#ffb700"
    "#00b7c7"
    "#00b400"
    "#ff2600"
    "#279189"
    "#3377ba"
    "#f55e00"
    "#00b400"
    "#ff2600"
    "#f55e00"
  ]

  FIRST_ITEM_IDX: 0

  itemClassName: "sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"
  activeItemIdx: 1

  constructor: ->
    @itemSelector = '.' + @itemClassName
    super
    @addColorSample(color, yes) for color in CSHistoryList.INITIAL_COLORS
    @isVisible = yes # History is always visible
    @el.on "dblclick", @itemSelector, @onDblClick
    @el.on "click", ".#{ @itemClassName }__fav-btn", @toggleFavorite
    @selectItemWithIndex @FIRST_ITEM_IDX

  addColorSample: (color, silent = no) ->
    $sample = $("<li class='#{ @itemClassName }' draggable='true'><i class='sample__fav-btn'></i></li>").css('background-color', color)
    @el.prepend($sample)
    unless silent
      $sample.addClass("#{ @itemClassName }_hidden")
      @selectItemWithIndex @FIRST_ITEM_IDX
      _.defer =>
        $sample.removeClass "#{ @itemClassName }_hidden"

  selectItemWithIndex: (idx) ->
    super
    @el.scrollLeft((52 * idx)/2) # Try to scroll item in the center

  onDblClick: (evt) =>
    evt.preventDefault()
    @menu.showColorPanel()

  toggleFavorite: (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    $(this).parent().toggleClass("sample_fav")

