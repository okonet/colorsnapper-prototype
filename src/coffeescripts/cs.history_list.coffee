require "stylesheets/_sample"
CSSamplesList = require "./cs.samples_list"

module.exports = class CSHistoryList extends CSSamplesList

  toggleFavorite: ($sample) ->
    super
    @addToFavorites $sample if $sample.hasClass("#{ @itemClassName }_fav")

  addToFavorites: ($el) ->
    scrollLeftOffset = @el.scrollLeft() # Scroll left offset
    origPosition = $el.position()
    origLeft = origPosition.left
    $clone = $el.clone()
    $clone.appendTo(@el)
    $clone.removeClass("active #{ @itemClassName}_fav")
    $clone.css("left", origLeft + scrollLeftOffset)
    distance = 410 - origLeft
    _.defer =>
      $clone.addClass("transition_to-favorites")
      $clone.css
        "transition-duration": Math.log(distance) * 100 + 'ms'
        "transform": "translateX(#{ distance - 24 }px)"
      _.delay =>
        $clone.remove()
        @menu.favoritesList.addColorSample($el.css('background-color'))
      , 1000
