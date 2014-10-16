module.exports = class CS

  @getBrightness: (r, g, b) ->
    Math.sqrt(
      r * r * .241 +
      g * g * .691 +
      b * b * .068
    )

  @getColorFromEl: (el) ->
    $(el).css("background-color")
