class CS.Menu

  previousState: "recent"
  state: "recent"

  constructor: ->
    @el = $(".menu")
    @historyList = new CS.HistoryList(".menu__history", this)
    @recentFormatsList = new CS.FormatsList(".menu__items_recent", this)
    @formatsList = new CS.FormatsList(".menu__items_all", this)

    jwerty.key 'enter', @confirmSelection
    jwerty.key 'esc', @onEscPressed

  addColor: (color) ->
    @historyList.addColorSample(color)

  showRecentFormats: ->
    @previousState = @state
    @state = "recent"
    $(".menu__formats").scrollTop(0)
    @el.removeClass "menu_all menu_color"
    @el.addClass "menu_recent"
    @recentFormatsList.show()
    @formatsList.hide()

  showAllFormats: ->
    @previousState = @state
    @state = "all"
    @el.removeClass "menu_recent menu_color"
    @el.addClass "menu_all"
    @recentFormatsList.hide()
    @formatsList.show()

  showFormats: ->
    if @previousState is "recent" then @showRecentFormats() else @showAllFormats()

  showColorPanel: ->
    @previousState = @state
    @state = "color"
    $(".menu__formats").scrollTop(0)
    @el.removeClass "menu_all menu_recent"
    @el.addClass "menu_color"

  confirmSelection: (evt) =>
    evt.preventDefault()
    @previousState = @state

    if @recentFormatsList.isVisible and $("#showAllFormats").hasClass("active")
      @showAllFormats()
    else
      @hide() # Pretend we've selected a color format to copy into clipboard

    $(".menu__item.active").removeClass("active")

  onEscPressed: (evt) =>
    evt.preventDefault()
    if @state is "color"
      # If color panel is visible, return to previous state
      @showFormats()
    else
      @hide() # otherwise hide the overlay

  show: ->
    @showRecentFormats()
    @isVisible = yes
    @el.removeClass 'hidden'
    $(document).trigger 'menu:shown'

  hide: ->
    @isVisible = no
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
