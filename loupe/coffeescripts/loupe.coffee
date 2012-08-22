class CS.Loupe

  zoom        : 10
  aperture    : 24 * 3
  apertureMin : 24
  apertureMax : 24 * 16

  diameter    : 24
  diameterMax : 24 * 15

  borderMin   : 2
  borderMax   : 6

  thersold    : 8

  constructor: ->
    @el = $(".loupe")
    @ctx = document.getElementById('canvas').getContext('2d')
    @overlay = new CS.Overlay @

    $("canvas").drawImage({
      source: "images/bg1.png"
    })

    $(document).on "mousemove", (e) =>
      @el.css
        top  : e.clientY
        left : e.clientX

      @overlay.render @getPixelAt e.clientX, e.clientY

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

  getPixelAt: (x, y) ->
    pixel = @ctx.getImageData(x, y, 1, 1).data
    [pixel[0], pixel[1], pixel[2]]

  revertToMaxDiameter: =>
    @diameter = Math.min @diameter, Math.min @diameterMax, @apertureMax * (@zoom-1)
    @render()

  render: (diameter) =>
    unless diameter?
      diameter = @getDiameter @zoom, @aperture
      diameter = Math.min diameter, @diameterMax
      @diameter = diameter

    border = @zoom / 1.5
    border = Math.max border, @borderMin
    border = Math.min border, @borderMax

    @el.css
      width        : diameter
      height       : diameter
      borderRadius : diameter
      borderWidth  : border
