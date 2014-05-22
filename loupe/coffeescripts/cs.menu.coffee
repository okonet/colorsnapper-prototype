class CS.Menu

  state: "all"
  previousState: "all"
  isFavoritesVisible: no

  constructor: ->
    @el = $(".menu")
    @historyList = new CS.HistoryList(".menu__history", this)
    @formatsList = new CS.FormatsList(".menu__items_all", this)

    jwerty.key 'enter', @confirmSelection
    jwerty.key 'esc', @onEscPressed

    $(document).on "keydown keyup", @toggleAltPressed

  toggleAltPressed: (evt) =>
    if evt.altKey
      @el[0].classList.add("menu_alt")
    else
      @el[0].classList.remove("menu_alt")

  addColor: (color) ->
    _.delay =>
      @historyList.addColorSample(color)
    , 350

  showAllFormats: ->
    @previousState = @state
    @state = "all"
    @el.removeClass "menu_recent menu_color"
    @el.addClass "menu_all"
    @formatsList.show()

  showFormats: ->
    @showAllFormats()

  showColorPanel: ->
    @previousState = @state
    @state = "color"
    $(".menu__formats").scrollTop(0)
    @el.removeClass "menu_all menu_recent"
    @el.addClass "menu_color"
    $('.toolbar_search').removeClass('active')
    $('.menu__formats').removeClass('withSearch')

  toggleFavoritesPanel: ->
    @isFavoritesVisible = not @isFavoritesVisible
    if @isFavoritesVisible
      @el.addClass "menu_favorites"
    else
      @el.removeClass "menu_favorites"

  confirmSelection: (evt) =>
    evt.preventDefault()
    @previousState = @state

    if @state is "color"
      @showFormats() # Return to formats if in color mode
    else
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
      if @formatsList.isFilterFocused # Reset filters
        @formatsList.$filterEl.val('').blur()
        @formatsList.$filterEl.trigger('keyup') # to call the callback
      else
        @hide() # otherwise hide the overlay

  show: ->
    @showAllFormats()
    @isVisible = yes
    @el.removeClass 'hidden'
    $(document).trigger 'menu:shown'

  hide: ->
    @isVisible = no
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
