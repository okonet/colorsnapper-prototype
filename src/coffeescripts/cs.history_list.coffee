require "stylesheets/_sample"
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
    "<span class='#{@className}__empty_msg'>Start by <i class='icon icon_pick'></i>picking or <i class='icon icon_color'></i>choosing a color...<span>"
