class CS.FormatsList extends CS.ListView

  itemSelector: ".menu__item"
  previousItemShortcut: "↑"
  nextItemShortcut: "↓"

  constructor: ->
    super
    @$filterEl = $("#formatFilter")
    @$filterEl.on "keyup click", @onFilterChange

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

  onFilterChange: (evt) =>
    value = @$filterEl.val()
