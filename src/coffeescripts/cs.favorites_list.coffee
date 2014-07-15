CSSamplesList = require "./cs.samples_list"

module.exports = class CSFavoritesList extends CSSamplesList

  constructor: ->
    super
    @isVisible = no

  toggleFavorite: (evt) =>
    super
    $sample = $(evt.target).parent()
    @removeFromFavorites($sample) unless $sample.hasClass("#{ @itemClassName }_fav")

  removeFromFavorites: ($el) ->
    $el.addClass("transition_from-favorites")
    _.delay ->
      $el.css('display', 'none')
      $el.remove()
    , 500


