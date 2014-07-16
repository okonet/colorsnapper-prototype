require "stylesheets/_sample"
CSSamplesList = require "./cs.samples_list"

module.exports = class CSHistoryList extends CSSamplesList

  toggleFavorite: (evt) =>
    super
    $sample = $(evt.target).parent()
    @addToFavorites($sample) if $sample.hasClass("#{ @itemClassName }_fav")

  addToFavorites: ($el) ->
    origPosition = $el.position()
    origLeft = origPosition.left
    $clone = $el.clone()
    $clone.appendTo(@el)
    $clone.removeClass("active #{ @itemClassName}_fav")
    $clone.css("left", origLeft)
    distance = 410 - origLeft
    _.defer ->
      $clone.addClass("transition_to-favorites")
      $clone.css
        "transition-duration": Math.log(distance) * 100 + 'ms'
        "transform": "translateX(#{ distance - 24 }px)"
      _.delay ->
        $clone.remove()
      , 1000
