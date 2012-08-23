class CS.Overlay

  pixel: [0,0,0]
  altFormat: no

  constructor: (@loupe) ->
    @el = $(".loupe__overlay")
    $(document).on "keydown", => @toggleFormat() if key.alt
    $(document).on "keyup", => @toggleFormat() if @altFormat

  toggleFormat: ->
    @altFormat = !@altFormat
    $(".loupe__format").text if @altFormat then "NSColor RGBA" else "CSS Hex"
    @render @pixel

  toggle: ->
    @el.toggleClass("loupe__overlay_simple")

  render: (pixel) ->
    format = []
    if not @altFormat
      format[0] = pixel[0].toString(16).toUpperCase()
      format[1] = pixel[1].toString(16).toUpperCase()
      format[2] = pixel[2].toString(16).toUpperCase()
    else
      format[0] = pixel[0]
      format[1] = pixel[1]
      format[2] = pixel[2]

    @el.css "background-color", "rgb(#{pixel.join(',')})"
    $(".loupe__color").html "#{format.join(' ')}"

    @loupe.el[if @brightness(pixel[0], pixel[1], pixel[2]) > 155 then "addClass" else "removeClass"]("loupe_invert")
    @pixel = pixel

  brightness: (r, g, b) ->
    Math.sqrt(
      r * r * .241 +
      g * g * .691 +
      b * b * .068
    )
