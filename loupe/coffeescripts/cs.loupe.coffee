class CS.Loupe

  MIN_ZOOM    : 2
  MAX_ZOOM    : 10
  WHEEL_SPEED : .5

  zoom        : parseInt localStorage.getItem('CS:zoom') or 2 # Get values from localStorage
  aperture    : parseInt localStorage.getItem('CS:aperture') or 48
  apertureMin : 24 * 2
  apertureMax : 24 * 15

  diameter    : 24
  diameterMax : 24 * 15

  borderMin   : 2
  borderMax   : 10


  constructor: ->
    @el = $(".loupe")
    @magnifier = new CS.Canvas("<canvas class='loupe__canvas'>")
    @el.append @magnifier.el
    $('body').addClass('cs-loupe')

    @screen = new CS.Canvas("#canvas")
    @screen.drawImage "images/bg1.png", (imageData) =>
      @screenImageData = imageData

    @overlay = new CS.Overlay @

    $(document).on "mousemove", (e) =>
      @posX = e.clientX
      @posY = e.clientY
      @render()
      @overlay.render @screen.getPixelAt @posX, @posY

    $(document).on 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      if key.alt
        @menu ?= new CS.Menu()
        @menu.show()

    $(document).on 'menu:shown', (e) =>
      $('body').removeClass('cs-loupe')
      @el.hide()

    $(document).on 'menu:hidden', (e) =>
      $('body').addClass('cs-loupe')
      @el.show()

    key 'alt + =, ctrl+=, =', =>
      ++@zoom if @MIN_ZOOM <= @zoom < @MAX_ZOOM
      @render()
      localStorage.setItem('CS:zoom', @zoom)
      off

    key 'alt+-, ctrl+-, -', =>
      @zoom-- if @MIN_ZOOM < @zoom <= @MAX_ZOOM
      @render()
      localStorage.setItem('CS:zoom', @zoom)
      off

    $(document).on "mousewheel", @onMouseWheel
    @revertToMaxDiameterDebounced = _.debounce @revertToMaxDiameter, 150
    @render()

  getDiameter: (zoom, aperture) ->
    aperture -= aperture % 2 # Ensure that aperture is always even to prevent fuzziness
    (zoom-1) * aperture

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
    @aperture -= (deltaY * @WHEEL_SPEED)
    @aperture = Math.max @aperture, @apertureMin
    @aperture = Math.min @aperture, @apertureMax
    localStorage.setItem('CS:aperture', @aperture)
    @render()
