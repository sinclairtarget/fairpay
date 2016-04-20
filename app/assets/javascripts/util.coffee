# ------------------------------------------------------------------------
#                               Utils
# ------------------------------------------------------------------------

window.Util or= {}

Util.show_alert = ($alert, msg) ->
  $alert.removeClass("hidden")
  $alert.children("p").text(msg)

Util.hide_alert = ($alert) ->
  $alert.addClass("hidden")
