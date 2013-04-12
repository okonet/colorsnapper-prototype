class CS.Loupe

  MIN_ZOOM    : 2
  MAX_ZOOM    : 10

  zoom        : 2
  aperture    : 24 * 2
  apertureMin : 24 * 2
  apertureMax : 24 * 15

  diameter    : 24
  diameterMax : 24 * 15

  borderMin   : 2
  borderMax   : 10

  thersold    : 8

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

    $(document).on "mousewheel", (e, delta, deltaX, deltaY) =>
      @aperture -= (deltaY * @thersold)
      @aperture = Math.max @aperture, @apertureMin
      @aperture = Math.min @aperture, @apertureMax

      dMax = @getDiameter @zoom, @aperture
      if @diameter >= dMax or @diameter >= @diameterMax
        e.preventDefault()
        e.stopPropagation()
        @diameter -= deltaY
        @diameter = Math.min @diameter, dMax * 1.2
        _renderDebounced @diameter
        _revertToMaxDiameter()
        off
      else
        @render()

    $(document).on 'click', (e) =>
      e.preventDefault()
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
      off

    key 'alt+-, ctrl+-, -', =>
      @zoom-- if @MIN_ZOOM < @zoom <= @MAX_ZOOM
      @render()
      off

    _renderDebounced = _.debounce @render, 10
    _revertToMaxDiameter = _.debounce @revertToMaxDiameter, 150
    @render()

  getDiameter: (zoom, aperture) ->
    (zoom-1) * aperture

  revertToMaxDiameter: =>
    @diameter = Math.min @diameter, Math.min @diameterMax, @apertureMax * (@zoom-1)
    @render()

  magnify: ->
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
