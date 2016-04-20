$(document).ready ->
# Group listings take you to the group page when clicked
  $(".group-listing").click ->
    groupID = $(this).data("id")
    window.location.href = "groups/" + groupID

$("#invite-modal").ready ->
  $modal = $("#invite-modal")
  $data = $modal.find(".modal-data").first()
  $alert = $modal.find(".alert").first()
  $textarea = $modal.find("textarea").first()

  $modal.find(".modal-action").click ->
    url = $data.data("post-url")
    emails = $textarea.val()

    $.ajax(
      url: url,
      method: "POST",
      data: { emails: emails }
    )
      .done (data, status, request) ->
        $modal.on "hidden.bs.modal": ->
          Turbolinks.visit(request.getResponseHeader("Location"))

        $modal.modal("hide")
      .fail (data) ->
        msg = "Something went wrong. (Status code: #{data.status})"
        Util.show_alert $alert, msg
