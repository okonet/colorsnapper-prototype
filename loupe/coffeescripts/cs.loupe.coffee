class CS.Loupe

  zoom        : 2
  aperture    : 24 * 5
  apertureMin : 24
  apertureMax : 24 * 5

  diameter    : 24
  diameterMax : 24 * 15

  borderMin   : 2
  borderMax   : 6

  thersold    : 8

  constructor: ->
    @el = $(".loupe")
    @magnifier = new CS.Canvas("<canvas id='magnifier'>")
    @el.append @magnifier.el

    @screen = new CS.Canvas("#canvas")
    @screen.drawImage "images/bg1.png", (imageData) =>
      @screenImageData = imageData
      # @magnifier.el.attr('width', imageData.width).attr('height', imageData.height)
      # @magnifier.getContext().putImageData(imageData, 0, 0)
      # @screen.scaleRegion 0, 0, 50, 50, 2

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

    key 'alt + =, ctrl+=, =', =>
      ++@zoom if 2 <= @zoom < 10
      @render()
      off

    key 'alt+-, ctrl+-, -', =>
      @zoom-- if 2 < @zoom <= 10
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
    width = @diameter
    height = @diameter
    @magnifier.setDimensions width, height
    @magnifier.drawScaledRegion @screen, @posX-width / @zoom, @posY-height / @zoom, width, height, @zoom

  render: (diameter) =>
    unless diameter?
      diameter = @getDiameter @zoom, @aperture
      diameter = Math.min diameter, @diameterMax
      @diameter = diameter

    border = @zoom / 1.5
    border = Math.max border, @borderMin
    border = Math.min border, @borderMax

    @magnifier.el.css
      borderRadius : diameter
    @magnify()

    @el.css
      top          : @posY
      left         : @posX
      width        : diameter
      height       : diameter
      borderRadius : diameter
      borderWidth  : border
