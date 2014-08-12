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
    $(@itemSelector, @el).each (idx, el) =>
      $(el).removeClass("#{ @itemClassName }_fav") if CS.getColorFromEl(el) is color
