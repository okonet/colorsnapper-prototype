require "stylesheets/_menu"
require "stylesheets/_toolbar"
CSHistoryList = require "./cs.history_list"
CSFormatsList = require "./cs.formats_list"

module.exports = class CSMenu

  previousState: "recent"
  state: "recent"

  constructor: ->
    @el = $(".menu")
    @historyList = new CSHistoryList(".menu__history", this)
    @recentFormatsList = new CSFormatsList(".menu__items_recent", this)
    @formatsList = new CSFormatsList(".menu__items_all", this)

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
    $('.toolbar_search').removeClass('active')
    $('.menu__formats').removeClass('withSearch')

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