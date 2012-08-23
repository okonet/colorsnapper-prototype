class CS.Canvas

  constructor: (selector) ->
    @el = $(selector)
    @ctx = @el.get(0).getContext('2d')
    @ctx.webkitImageSmoothingEnabled = no

  drawImage: (src, callback) ->
    img = new Image()
    img.onload = =>
      @ctx.drawImage(img, 0, 0)
      imageData = @ctx.getImageData(0, 0, img.width, img.height)
      @clone = $("<canvas>").attr("width", img.width).attr("height", img.height)[0]
      @clone.getContext('2d').putImageData(imageData, 0, 0)
      callback()
    img.src = src;

  getPixelAt: (x, y) ->
    pixel = @ctx.getImageData(x, y, 1, 1).data
    [pixel[0], pixel[1], pixel[2]]

  getRegion: (x, y, width, height) ->
    @ctx.getImageData(x, y, width, height)

  getBrightness: (r, g, b) ->
    Math.sqrt(
      r * r * .241 +
      g * g * .691 +
      b * b * .068
    )

  scaleRegion: (x, y, width, height, scale) =>
    newWidth  = width * scale
    newHeight = height * scale
    @ctx.save()
    @ctx.translate -((newWidth-width)/2), -((newHeight-height)/2)
    @ctx.scale scale, scale
    @ctx.clearRect 0, 0, newWidth, newHeight
    @ctx.drawImage @clone, 0, 0
    @ctx.restore()
