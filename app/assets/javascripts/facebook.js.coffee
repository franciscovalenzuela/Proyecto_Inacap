jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/es_LA/all.js"
    dataType: 'script'
    cache: true


window.fbAsyncInit = ->
  FB.init(appId: '1471231306435901', cookie: true)

  $('#facelog').click (e) ->
    e.preventDefault()
    FB.login (response) ->
      window.location = '/users/auth/facebook/callback' if response.authResponse

  $('#sign_out').click (e) ->
    FB.getLoginStatus (response) ->
      FB.logout() if response.authResponse
    true
