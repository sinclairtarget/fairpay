# Handle expanding table categories
$(document).on("click", ".salary-table tbody > tr:first-child", ->
  $row = $(this)
  $icon_span = $row.find(".fa").first()
  Util.toggle_class $icon_span, "fa-angle-down", "fa-angle-right"

  $tbody = $row.parent()
  $tbody.children("tr:not(:first-child)").toggle()
)


# Handle closing alerts
$(document).on("click", ".alert .fa-close", ->
  $button = $(this)
  $alert = $button.closest(".alert")
  $alert.remove()
)


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


$("#leave-modal").ready ->
  $modal = $("#leave-modal")
  $data = $modal.find(".modal-data").first()
  $alert = $modal.find(".alert").first()

  $modal.find(".modal-action").click ->
    url = $data.data("delete-url")

    $.ajax(
      url: url,
      method: "DELETE"
    )
      .done (data, status, request) ->
        $modal.on "hidden.bs.modal": ->
          Turbolinks.visit(request.getResponseHeader("Location"))

        $modal.modal("hide")
      .fail (data) ->
        msg = "Something went wrong. (Status code: #{data.status})"
        Util.show_alert $alert, msg


$("#edit-modal").ready ->
  $modal = $("#edit-modal")
  $data = $modal.find(".modal-data").first()
  $alert = $modal.find(".alert").first()

  $modal.find(".modal-action").click ->
    url = $data.data("put-url")
    title = $modal.find("#title-field").val()
    annual_pay = $modal.find("#salary-field").val()

    $.ajax(
      url: url,
      method: "PUT",
      data: { title: title, annual_pay: annual_pay }
    )
      .done (data, status, request) ->
        $modal.on "hidden.bs.modal": ->
          Turbolinks.visit(request.getResponseHeader("Location"))

        $modal.modal("hide")
      .fail (data) ->
        msg = "Something went wrong. (Status code: #{data.status})"
        Util.show_alert $alert, msg

$("#title").ready ->
  $input = $("#title")
  unless $input.length > 0
    return

  data_string = $input.data("titles")
  autocomplete_titles = Util.parse_titles_data_string(data_string)
  console.log autocomplete_titles
  $input.autocomplete({
    source: autocomplete_titles,
    delay: 0
  })
