class CS.Canvas

  constructor: (selector) ->
    @el = $(selector)
    @ctx = @el.get(0).getContext('2d')
    @ctx.webkitImageSmoothingEnabled = no

  drawImage: (src) ->
    img = new Image()
    img.onload = => @ctx.drawImage(img, 0, 0)
    img.src = src;

  getPixelAt: (x, y) ->
    pixel = @ctx.getImageData(x, y, 1, 1).data
    [pixel[0], pixel[1], pixel[2]]

  getRegion: (x, y, width, height) ->
    @ctx.getImageData(x, y, width, height).data

  getBrightness: (r, g, b) ->
    Math.sqrt(
      r * r * .241 +
      g * g * .691 +
      b * b * .068
    )
