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

  drawScaledRegion: (canvas, x, y, radius, scale) ->
    diameter = radius * 2

    theX = (x * scale) - (radius - scale / 2)
    theY = (y * scale) - (radius - scale / 2)

    cX = cY = radius

    @ctx.webkitImageSmoothingEnabled = no
    @ctx.save()

    @ctx.beginPath()
    @ctx.arc cX, cY, radius, 0, Math.PI * 2, no
    @ctx.clip()

    @ctx.translate -theX, -theY
    @ctx.scale scale, scale
    @ctx.drawImage canvas.el[0], 0, 0
    @ctx.restore()

    @ctx.lineWidth = 1;
    @ctx.strokeStyle = 'rgba(255,255,255,.5)'
    @ctx.stroke()

    scale += if scale % 2 then 2 else 1
    @ctx.lineWidth = 1;
    @ctx.strokeStyle = 'rgb(255,255,255)'
    @ctx.strokeRect cX-scale/2, cY-scale/2, scale, scale
