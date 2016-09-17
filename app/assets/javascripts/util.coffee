# ------------------------------------------------------------------------
#                               Utils
# ------------------------------------------------------------------------

window.Util or= {}

Util.show_alert = ($alert, msg) ->
  $alert.removeClass("hidden")
  $alert.children("p").text(msg)

Util.hide_alert = ($alert) ->
  $alert.addClass("hidden")

Util.parse_titles_data_string = (data_string) ->
  titles_array = data_string.split(";").filter (string) -> string.length > 0
  final_array = []
  for item in titles_array
    parts = item.split(",")
    final_array.push { label: "#{parts[0]} (#{parts[1]})", value: parts[0] }

  final_array

Util.toggle_class = ($obj, class_a, class_b) ->
  if $obj.hasClass(class_a)
    $obj.removeClass(class_a)
    $obj.addClass(class_b)
  else if $obj.hasClass(class_b)
    $obj.removeClass(class_b)
    $obj.addClass(class_a)
