require "stylesheets/tour.scss"

require.ensure [], () ->
  activeSelection = null
  html = require "./tour.html"

  $(document).ready ->
    console.log "Starting product tour"
    $('body menu').prepend(html)
    $tour = $('.tour')

    $('.tour li').on "click", (evt) ->
      $('.tour__list-item').removeClass('active')
      $tour.removeClass(activeSelection)
      href = $(this).attr('href').replace("#", "")
      $(this).addClass('active')
      $tour.addClass(href)
      activeSelection = href

    # $('.tour li').on "mouseleave", (evt) ->
    #   href = $(this).attr('href').replace("#", "")
    #   $tour.removeClass(href)

    $('.tour__btn').on "click", (evt) ->
      $('.tour').addClass('hidden')

    $($('.tour__list-item').get(0)).trigger('click')
