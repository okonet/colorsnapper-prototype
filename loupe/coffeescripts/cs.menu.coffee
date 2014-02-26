class CS.Menu

  activeColor: 0
  activeFormat: 0

  constructor: ->
    @el = $(".menu")
    @historyList = new CS.HistoryList(".menu__history", this)
    @recentFormatsList = new CS.FormatsList(".menu__items_recent", this)
    @formatsList = new CS.FormatsList(".menu__items_all", this)

    jwerty.key 'enter', @confirmSelection
    jwerty.key 'esc', @hide

  addColor: (color) ->
    @historyList.addColorSample(color)

  showRecentFormats: ->
    @el.removeClass "menu_all"
    @el.addClass "menu_recent"
    @recentFormatsList.show()
    @formatsList.hide()

  showAllFormats: ->
    $("#showAllFormats").removeClass("active")
    @el.removeClass "menu_recent"
    @el.addClass "menu_all"
    @recentFormatsList.hide()
    @formatsList.show()

  confirmSelection: (evt) =>
    evt.preventDefault()
    if @recentFormatsList.isVisible and $("#showAllFormats").hasClass("active")
      @showAllFormats()
    else
      @hide() # Pretend we've selected a color format to copy into clipboard

  show: ->
    @showRecentFormats()
    @isVisible = yes
    @el.removeClass 'hidden'
    $(document).trigger 'menu:shown'

  hide: =>
    @isVisible = no
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
