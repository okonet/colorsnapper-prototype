require "stylesheets/_loupe"
require "jquery-mousewheel"
CS = require "./cs"
CSCanvas = require "./cs.canvas"
CSOverlay = require "./cs.overlay"
CSMenu = require "./cs.menu"

module.exports = class CSLoupe

  @MIN_ZOOM    : 2
  @MAX_ZOOM    : 10
  @WHEEL_SPEED : .5

  zoom        : parseInt(localStorage.getItem('CS:zoom'), 10) or 2 # Get values from localStorage
  aperture    : parseInt(localStorage.getItem('CS:aperture'), 10) or 48
  apertureMin : 24 * 2
  apertureMax : 24 * 15

  diameter    : 24
  diameterMax : 24 * 15

  borderMin   : 2
  borderMax   : 10

  backgroundImg: require("file!../images/bgs/bg3.png")

  constructor: ->
    @el = $(".loupe")
    @magnifier = new CSCanvas("<canvas class='loupe__canvas'>")
    @el.append @magnifier.el
    $('body').addClass('cs-loupe')

    @screen = new CSCanvas("#canvas")
    @screen.drawImage @backgroundImg, (imageData) =>
      @screenImageData = imageData

    @overlay = new CSOverlay @

    jwerty.key 'ctrl+⌘+C', @show
    jwerty.key 'esc', @hide

    $(document).on "mousemove", (e) =>
      if @isVisible
        @posX = e.clientX
        @posY = e.clientY
        @render()
        @overlay.render @screen.getPixelAt @posX, @posY

    $(document).on 'click', (e) =>
      if @isVisible
        e.preventDefault()
        e.stopPropagation()
        @simulatePick(e)
        unless jwerty.is('⌥', e)
          @menu ?= new CSMenu()
          @menu.show()
          @menu.addColor @getActualColor()

    $(document).on 'menu:shown', @hide

    jwerty.key ']', =>
      if @isVisible
        ++@zoom if CSLoupe.MIN_ZOOM <= @zoom < CSLoupe.MAX_ZOOM
        @render()
        localStorage.setItem('CS:zoom', @zoom)

    jwerty.key '[', =>
      if @isVisible
        @zoom-- if CSLoupe.MIN_ZOOM < @zoom <= CSLoupe.MAX_ZOOM
        @render()
        localStorage.setItem('CS:zoom', @zoom)

    $(document).on "mousewheel", @onMouseWheel
    @revertToMaxDiameterDebounced = _.debounce @revertToMaxDiameter, 150
    @hide()

  getDiameter: (zoom, aperture) ->
    aperture -= aperture % 2 # Ensure that aperture is always even to prevent fuzziness
    (zoom-1) * aperture

  getActualColor: ->
    "rgb(#{@magnifier.targetPixel.join(",")})"

  revertToMaxDiameter: =>
    @diameter = Math.min @diameter, Math.min @diameterMax, @apertureMax * (@zoom-1)
    @render()

  magnify: =>
    width = height = @diameter
    @magnifier.setDimensions width, height
    @magnifier.drawScaledRegion @screen, @posX, @posY, @diameter/2, @zoom

  render: (diameter) =>
    unless diameter?
      diameter = @getDiameter @zoom, @aperture
      diameter = Math.min diameter, @diameterMax
      @diameter = diameter

    border = @zoom / 1.25
    border = Math.max border, @borderMin
    border = Math.min border, @borderMax

    @magnify()

    @el.css
      top          : @posY
      left         : @posX
      width        : diameter
      height       : diameter
      borderRadius : diameter
      borderWidth  : border

  onMouseWheel: (e, delta, deltaX, deltaY) =>
    if @isVisible
      @aperture -= (deltaY * CSLoupe.WHEEL_SPEED)
      @aperture = Math.max @aperture, @apertureMin
      @aperture = Math.min @aperture, @apertureMax
      localStorage.setItem('CS:aperture', @aperture)
      @render()

  simulatePick: (evt) ->
    @el.addClass('picked')
    _.delay @hide, 250

  show: =>
    @isVisible = yes
    $('body').addClass('cs-loupe')
    @el.show()

  hide: =>
    @isVisible = no
    $('body').removeClass('cs-loupe')
    @el.removeClass('picked')
    @el.hide()
