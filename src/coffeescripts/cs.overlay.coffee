CS = require "./cs"

module.exports = class CSOverlay

  @types: ["none", "simple", "full"]
  @formats: ["rgb", "hex", "nscolor"]
  @altFormats: ["hex", "rgb", "hsl"]

  pixel: [0,0,0]
  altFormat: no
  selectedFormat: localStorage.getItem('CS:selectedFormat') or 0
  selectedAltFormat: localStorage.getItem('CS:selectedAltFormat') or 0
  overlayType: parseInt localStorage.getItem('CS:overlayType') or 2

  constructor: (@loupe) ->
    @el = $(".loupe__overlay")

    $(document).on "keydown", (e) =>
      @toggleFormat() if e.keyCode is 18

    $(document).on "keyup", (e) =>
      @toggleFormat() if not e.altKey and @altFormat

    jwerty.key '[ / alt+[', =>
      @switchFormat(-1)

    jwerty.key '] / alt+]', =>
      @switchFormat(1)

    jwerty.key [['/']], @toggle
    @changeType @overlayType
    @renderLabel()

  toggleFormat: ->
    @altFormat = not @altFormat
    @renderLabel()
    @render @pixel

  switchFormat: (direction) =>
    formats = if @altFormat then CSOverlay.formats else CSOverlay.altFormats
    selectedFormat = if @altFormat then @selectedFormat else @selectedAltFormat
    selectedFormat = parseInt(selectedFormat, 10)
    newFormatIdx = selectedFormat + direction
    newFormatIdx = 0 if newFormatIdx > formats.length - 1
    newFormatIdx = formats.length - 1 if newFormatIdx < 0
    if @altFormat
      @selectedFormat = newFormatIdx
    else
      @selectedAltFormat = newFormatIdx
    localStorage.setItem('CS:selectedFormat', @selectedFormat)
    localStorage.setItem('CS:selectedAltFormat', @selectedAltFormat)
    @renderLabel()
    @render @pixel

  getLabelText: (formatIdx, isAlternative) ->
    label = ""
    formatID = @getFormatIdForIdx(formatIdx, isAlternative)
    if isAlternative
      switch formatID
        when 'rgb'
          label = "Generic RGB"
        when 'nscolor'
          label = "NSColor sRGB"
        when 'hex'
          label = "CSS HEX"
    else
      label = "Display "
      switch formatID
        when 'rgb'
          label += "RGB"
        when 'hsl'
          label += "HSL"
        when 'hex'
          label += "HEX"

#      label += " <span class='loupe__colorProfile'>(Color LCD)</span>" # Color Profile info

    label

  getFormatText: (pixel, formatIdx, isAlternative) ->
    format = []
    formatID = @getFormatIdForIdx(formatIdx, isAlternative)
    for part, idx in pixel
      switch formatID
        when 'rgb' # RGB decimal
          format[idx] = part

        when 'nscolor' # Decimal with precision
          decimal = part / 255
          # format[idx] = "#{(part / 255).toPrecision(4).replace('0.', '.')}f" No leading zeroes/suffix f
          format[idx] = "#{(part / 255).toPrecision(4).replace(/(0+)$/, '')}f"

        when 'hex' # HEX
          hex = part.toString(16)
          hex = if hex.length < 2 then "0#{ hex }" else hex
          format[idx] = hex.toUpperCase()

        when 'hsl' # For displaying raw values
          format[idx] = part

    "≈ #{format.join(' ')}"

  getFormatIdForIdx: (idx, isAlternative) ->
    idx = parseInt(idx, 10)
    formats = if isAlternative then CSOverlay.formats else CSOverlay.altFormats
    formats[idx]

  renderLabel: ->
    selectedFormat = if @altFormat then @selectedFormat else @selectedAltFormat
    $(".loupe__format").html @getLabelText(selectedFormat, @altFormat)

  toggle: =>
    if ++@overlayType > 2 then @overlayType = 0
    @changeType @overlayType

  changeType: (type) ->
    localStorage.setItem('CS:overlayType', type)
    @el.attr("class", "loupe__overlay loupe__overlay_#{ CSOverlay.types[type] }")

  render: (pixel) ->
    selectedFormat = if @altFormat then @selectedFormat else @selectedAltFormat
    @el.css "background-color", "rgb(#{pixel.join(',')})"
    $(".loupe__color").html @getFormatText(pixel, selectedFormat, @altFormat)

    @loupe.el[if CS.getBrightness(pixel[0], pixel[1], pixel[2]) > 155 then "addClass" else "removeClass"]("loupe_invert")
    @pixel = pixel

