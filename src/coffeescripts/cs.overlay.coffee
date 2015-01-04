CS = require "./cs"

module.exports = class CSOverlay

  @types: ["none", "simple", "full"]
  @formats: ["rgb", "hex", "nscolor"]

  pixel: [0,0,0]
  altFormat: no
  selectedFormat: CSOverlay.formats[0]
  overlayType: parseInt localStorage.getItem('CS:overlayType') or 2

  constructor: (@loupe) ->
    @el = $(".loupe__overlay")

    $(document).on "keydown", (e) =>
      @toggleFormat() if e.altKey

    $(document).on "keyup", =>
      @toggleFormat() if @altFormat

    jwerty.key '[', (e) =>
      @switchFormat(-1)

    jwerty.key ']', (e) =>
      @switchFormat(1)

    jwerty.key [['/']], @toggle
    @changeType @overlayType
    @renderLabel()

  toggleFormat: ->
    @altFormat = not @altFormat
    @renderLabel()
    @render @pixel

  switchFormat: (direction) =>
    newFormatIdx = CSOverlay.formats.indexOf(@selectedFormat) + direction
    newFormatIdx = 0 if newFormatIdx > CSOverlay.formats.length - 1
    newFormatIdx = CSOverlay.formats.length - 1 if newFormatIdx < 0
    @selectedFormat = CSOverlay.formats[newFormatIdx]
    @renderLabel()
    @render @pixel

  getLabelText: (formatID, isAlternative) ->
    label = ""
    switch formatID
      when 'rgb'
        label = "Generic RGB"
      when 'nscolor'
        label = "NSColor Calibrated RGB"
      when 'hex'
        label = "CSS HEX"

    label += "..." unless isAlternative
    label

  getFormatText: (pixel, formatID) ->
    format = []
    for part, idx in pixel
      switch formatID
        when 'rgb' # RGB decimal
          format[idx] = part

        when 'nscolor' # Decimal with precision
          decimal = part / 255
          format[idx] = "#{(part / 255).toPrecision(4).replace('0.', '.')}f"

        when 'hex' # HEX
          hex = part.toString(16)
          hex = if hex.length < 2 then "0#{ hex }" else hex
          format[idx] = hex.toUpperCase()

    "#{format.join(' ')}"

  renderLabel: ->
    $(".loupe__format").text @getLabelText(@selectedFormat, @altFormat)

  toggle: =>
    if ++@overlayType > 2 then @overlayType = 0
    @changeType @overlayType

  changeType: (type) ->
    localStorage.setItem('CS:overlayType', type)
    @el.attr("class", "loupe__overlay loupe__overlay_#{ CSOverlay.types[type] }")

  render: (pixel) ->
    @el.css "background-color", "rgb(#{pixel.join(',')})"
    $(".loupe__color").html @getFormatText(pixel, @selectedFormat)

    @loupe.el[if CS.getBrightness(pixel[0], pixel[1], pixel[2]) > 155 then "addClass" else "removeClass"]("loupe_invert")
    @pixel = pixel

