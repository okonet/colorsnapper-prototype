require "stylesheets/_sample"
CSListView = require "./cs.list_view"

module.exports = class CSSamplesList extends CSListView

  FIRST_ITEM_IDX: 0

  itemClassName: "sample"
  previousItemShortcut: "←"
  nextItemShortcut: "→"
  activeItemIdx: @FIRST_ITEM_IDX
  isVisible: no

  constructor: (selector, @menu, colors) ->
    @itemSelector = '.' + @itemClassName
    super
    @isVisible = yes # History is always visible
    @container = @el
    @container.on "dblclick", @itemSelector, @onDblClick
    @container.on "click", ".#{ @itemClassName }__fav-btn", @toggleFavorite
    @container.on "click", ".menu__samples-icon", @toggleVisible

    @el = $(".samples", @el)
    @addColorSample(color, yes) for color in colors
    @selectItemWithIndex @FIRST_ITEM_IDX

  addColorSample: (color, silent = no) ->
    $sample = $("<li class='#{ @itemClassName }'><i class='sample__fav-btn'></i></li>")
    $sample.css('background-color', color)
    $sample.addClass("#{ @itemClassName }_fav") if @menu.favorites.indexOf(color) isnt -1
    @el.prepend($sample)
    unless silent
      $sample.addClass("#{ @itemClassName }_hidden")
      @selectItemWithIndex @FIRST_ITEM_IDX
      _.defer =>
        $sample.removeClass "#{ @itemClassName }_hidden"

  selectItemWithIndex: (idx) ->
    super
    @el.scrollLeft((52 * idx)/2) # Try to scroll item in the center

  updateVisible: ->
    if @isVisible
      @container.addClass("active")
    else
      @container.removeClass("active")

  onDblClick: (evt) =>
    evt.preventDefault()
    @menu.showColorPanel()

  toggleFavorite: (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    $sample = $(this).parent()
    $sample.toggleClass("sample_fav")

  toggleVisible: (evt) =>
    evt.preventDefault()
    @menu.historyList.isVisible = not @menu.historyList.isVisible
    @isVisible = not @isVisible
    @updateVisible()
    # console.log evt
    # $(this).parent().toggleClass("sample_fav")
