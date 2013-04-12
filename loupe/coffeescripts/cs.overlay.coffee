class CS.Overlay

  types: ["none", "simple", "full"]
  pixel: [0,0,0]
  altFormat: no
  overlayType: 1

  constructor: (@loupe) ->
    @el = $(".loupe__overlay")
    $(document).on "keydown", => @toggleFormat() if key.alt
    $(document).on "keyup", => @toggleFormat() if @altFormat
    key '/', @toggle
    @changeType @overlayType

  toggleFormat: ->
    @altFormat = !@altFormat
    $(".loupe__format").text if @altFormat then "NSColor RGBA" else "CSS Hex"
    @render @pixel

  toggle: =>
    if ++@overlayType > 2 then @overlayType = 0
    @changeType @overlayType

  changeType: (type) ->
    @el.attr("class", "loupe__overlay loupe__overlay_#{@types[type]}")

  render: (pixel) ->
    format = []
    if not @altFormat
      format[0] = pixel[0].toString(16).toUpperCase()
      format[1] = pixel[1].toString(16).toUpperCase()
      format[2] = pixel[2].toString(16).toUpperCase()
    else
      format[0] = "#{(pixel[0] / 255).toPrecision(4).replace('0.', '.')}"
      format[1] = "#{(pixel[1] / 255).toPrecision(4).replace('0.', '.')}"
      format[2] = "#{(pixel[2] / 255).toPrecision(4).replace('0.', '.')}"

    @el.css "background-color", "rgb(#{pixel.join(',')})"
    $(".loupe__color").html "#{format.join(' ')}"

    @loupe.el[if CS.getBrightness(pixel[0], pixel[1], pixel[2]) > 155 then "addClass" else "removeClass"]("loupe_invert")
    @pixel = pixel

