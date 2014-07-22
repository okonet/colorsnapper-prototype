CSSamplesList = require "./cs.samples_list"
CSListView = require "./cs.list_view"

module.exports = class CSFormatsList extends CSListView

  itemSelector: ".menu__item"
  previousItemShortcut: "↑"
  nextItemShortcut: "↓"
  isFilterFocused: no

  constructor: ->
    super
    @$filterEl = $("#formatFilter")
    $(document).on "keydown", @focusFilterField
    @$filterEl.on "keyup click", @onFilterChange

  show: ->
    super
    @selectItemWithIndex(0) unless @getSelectedItem().length

  onItemClicked: (evt) =>
    super
    _.delay =>
      @menu.confirmSelection(evt)
    , 150

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

  focusFilterField: (evt) =>
    evt.preventDefault
    charCode = String.fromCharCode(evt.keyCode)
    if charCode.match(/[A-Za-z]/) and not jwerty.is(CSSamplesList.TOGGLE_FAV_SHORTCUT, evt)
      @$filterEl.focus() if @isVisible

  onFilterChange: (evt) =>
    value = @$filterEl.val()
    @isFilterFocused = !!value.length
    @$filterEl.blur() if value.length is 0
