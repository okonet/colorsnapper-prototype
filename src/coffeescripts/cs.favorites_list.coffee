CSSamplesList = require "./cs.samples_list"

module.exports = class CSFavoritesList extends CSSamplesList

  constructor: ->
    super
    @isVisible = no
