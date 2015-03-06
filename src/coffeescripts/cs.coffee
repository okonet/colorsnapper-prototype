module.exports = class CS

  @getBrightness: (r, g, b) ->
    r = parseInt(r, 10)
    g = parseInt(g, 10)
    b = parseInt(b, 10)

    Math.sqrt(
      r * r * .241 +
      g * g * .691 +
      b * b * .068
    )

  @getColorFromEl: (el) ->
    $(el).css("background-color")
