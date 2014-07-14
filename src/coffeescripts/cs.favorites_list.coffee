CSSamplesList = require "./cs.samples_list"

module.exports = class CSFavoritesList extends CSSamplesList

  template: "<li class='sample sample_fav' draggable='true'><i class='sample__fav-btn'></i></li>"

  constructor: ->
    super
    @isVisible = no
