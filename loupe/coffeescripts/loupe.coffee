class window.Loupe

  zoom        : 2
  aperture    : 25
  apertureMin : 25
  apertureMax : 25 * 4
  diameterMax : 25 * 15

  borderMin   : 2
  borderMax   : 6

  thersold    : 8

  constructor: ->
    @el = $(".loupe")

    $(document).on "mousemove", (e) =>
      @el.css
        top  : e.clientY
        left : e.clientX

    $(document).on "mousewheel", (e, delta, deltaX, deltaY) =>
      @aperture -= (deltaY * @thersold)
      @aperture = Math.max @aperture, @apertureMin
      @aperture = Math.min @aperture, @apertureMax
      @render()

    key 'alt + =', =>
      ++@zoom if 2 <= @zoom < 10
      @render()
      off

    key 'alt + -', =>
      @zoom-- if 2 < @zoom <= 10
      @render()
      off

    @render()

  render: ->
    diameter = (@zoom - 1) * @aperture
    diameter = Math.min diameter, @diameterMax

    border = @zoom / 1.5
    border = Math.max border, @borderMin
    border = Math.min border, @borderMax

    @el.css
      width        : diameter
      height       : diameter
      borderRadius : diameter
      borderWidth  : border
