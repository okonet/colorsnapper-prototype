CS = require "./cs"
CSSamplesList = require "./cs.samples_list"

module.exports = class CSHistoryList extends CSSamplesList

  constructor: ->
    super
    @isVisible = yes # History should be visible initially
    @container.addClass("active") # Add an active class name

    $(document).on "favorite:removed", (evt, color) =>
      @removeColorSample(color)

  removeColorSample: (color) ->
    super
    $(@itemSelector, @el).each (idx, el) =>
      $(el).removeClass("#{ @itemClassName }_fav") if CS.getColorFromEl(el) is color

  getEmptyStateHTML: ->
    "<span class='#{@className}__empty_msg'>Start by <i class='icon'><svg class='icon__content'><use xlink:href='#icon-history'></use></svg></i>picking or <i class='icon'><svg class='icon__content'><use xlink:href='#icon-colorpanel'></use></svg></i>choosing a color...<span>"
