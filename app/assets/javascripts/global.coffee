$(document).ready ->
# Group listings take you to the group page when clicked
  $(".group-listing").click ->
    groupID = $(this).data("id")
    window.location.href = "groups/" + groupID
