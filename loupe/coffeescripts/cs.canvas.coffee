class CS.Canvas

  constructor: (selector) ->
    @el = $(selector)
    @ctx = @getContext()

  setDimensions: (width, height) ->
    @el.attr("width", width).attr("height", height)

  drawImage: (src, callback) ->
    img = new Image()
    img.onload = =>
      @ctx.drawImage img, 0, 0
      imageData = @ctx.getImageData(0, 0, img.width, img.height)
      callback imageData
    img.src = src;

  getContext: ->
    @el[0].getContext('2d')

  getPixelAt: (x, y) ->
    pixel = @ctx.getImageData(x, y, 1, 1).data
    [pixel[0], pixel[1], pixel[2]]

  getBrightness: (r, g, b) ->
    Math.sqrt(
      r * r * .241 +
      g * g * .691 +
      b * b * .068
    )

  drawScaledRegion: (canvas, x, y, width, height, scale) ->
    newWidth  = width * scale
    newHeight = height * scale
    @ctx.webkitImageSmoothingEnabled = no
    @ctx.save()
    @ctx.translate -(x * scale + width / 2), -(y * scale + width / 2)
    @ctx.scale scale, scale
    @ctx.clearRect 0, 0, newWidth, newHeight
    @ctx.drawImage canvas.el[0], 0, 0
    @ctx.restore()
