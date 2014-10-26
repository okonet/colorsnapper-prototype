require "stylesheets/_menu"
require "stylesheets/_toolbar"
CS = require "./cs.coffee"
CSHistoryList = require "./cs.history_list"
CSFavoritesList = require "./cs.favorites_list"
CSFormatsList = require "./cs.formats_list"

module.exports = class CSMenu

  previousState: "recent"
  state: "recent"
  recentlyPicked: []
  favorites: []

  constructor: ->
    @el = $(".menu")
    @historyList = new CSHistoryList(".menu__history", this, @recentlyPicked)
    @favoritesList = new CSFavoritesList(".menu__favorites", this, @favorites)
    @formatsList = new CSFormatsList(".menu__items_all", this)
    @el.on "click", ".toolbar__item_new", @onCreateColorClicked
    @el.on "click", ".menu__samples-icon", @toggleFavorites

    jwerty.key 'alt+ctrl+⌘+C', @show
    jwerty.key 'enter', @confirmSelection
    jwerty.key 'esc', @onEscPressed
    jwerty.key 'alt+f', @toggleFavorites

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

  showFormats: ->
    @previousState = @state
    @state = "all"
    @el.removeClass "menu_recent menu_color"
    @el.addClass "menu_all"
    @formatsList.show()

  showColorPanel: ->
    @previousState = @state
    @state = "color"
    $(".menu__formats").scrollTop(0)
    @el.removeClass "menu_all menu_recent"
    @el.addClass "menu_color"
    $('.toolbar_search').removeClass('active')
    $('.menu__formats').removeClass('withSearch')

  showHistory: ->
    @favoritesList.hide()
    @historyList.show()

  showFavorites: ->
    @historyList.hide()
    @favoritesList.show()

  confirmSelection: (evt) =>
    evt.preventDefault()
    @previousState = @state

    if @state is "color"
      @showFormats() # Return to formats if in color mode
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

  onCreateColorClicked: (evt) =>
    evt.preventDefault()
    evt.stopPropagation()
    if evt.altKey
      activeList = if @historyList.isVisible then @historyList else @favoritesList
      selectedItem = activeList.getSelectedItem()
      colorToDuplicate = CS.getColorFromEl(selectedItem)
      isFavorite = activeList.isFavorite(selectedItem)
      @historyList.addColorSample(colorToDuplicate or "rgb(0,0,255)", no, isFavorite)
      @showColorPanel()
      @showHistory()
    else
      @hide()
      window.loupe.show()

  toggleFavorites: (evt) =>
    evt.preventDefault()
    @historyList.toggleVisible()
    @favoritesList.toggleVisible()

  show: =>
    @showFormats()
    @isVisible = yes
    @el.removeClass 'hidden'
    $(document).trigger 'menu:shown'

  hide: ->
    @isVisible = no
    @el.addClass 'hidden'
    $(document).trigger 'menu:hidden'
