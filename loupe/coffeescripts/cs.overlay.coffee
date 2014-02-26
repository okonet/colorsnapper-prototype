class CS.Overlay

  types: ["none", "simple", "full"]
  pixel: [0,0,0]
  altFormat: no
  overlayType: parseInt localStorage.getItem('CS:overlayType') or 2

  constructor: (@loupe) ->
    @el = $(".loupe__overlay")
    $(document).on "keydown", (e) => @toggleFormat() if e.altKey
    $(document).on "keyup", => @toggleFormat() if @altFormat
    jwerty.key [['/']], @toggle
    @changeType @overlayType

  toggleFormat: ->
    @altFormat = !@altFormat
    $(".loupe__format").text if @altFormat then "Show formats..." else "CSS Hex"
    @render @pixel

  toggle: =>
    if ++@overlayType > 2 then @overlayType = 0
    @changeType @overlayType

  changeType: (type) ->
    localStorage.setItem('CS:overlayType', type)
    @el.attr("class", "loupe__overlay loupe__overlay_#{@types[type]}")

  render: (pixel) ->
    format = []
    if not @altFormat
      for c in [0..2]
        hex = pixel[c].toString(16)
        hex = if hex.length < 2 then "0#{ hex }" else hex
        format[c] = hex.toUpperCase()
    else
      format[0] = "#{ pixel[0] }"
      format[1] = "#{ pixel[1] }"
      format[2] = "#{ pixel[2] }"

    @el.css "background-color", "rgb(#{pixel.join(',')})"
    $(".loupe__color").html "#{format.join(' ')}"

    @loupe.el[if CS.getBrightness(pixel[0], pixel[1], pixel[2]) > 155 then "addClass" else "removeClass"]("loupe_invert")
    @pixel = pixel

