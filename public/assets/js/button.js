var form = $("#reddit-front-page");
var form_alert = $("#formAlert");
var form_url = $(form).attr("action");

$(form).submit(function( event ) {
    event.preventDefault();
    var form_data = $(form).serialize();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
    .done(function () {
        $(form_alert).text("Notification saved!");
        $(form_alert).addClass("alert-success");
        $(form_alert).addClass("in");
    })
    .fail(function (request, status, error) {
        $(form_alert).text("Error saving notification!");
        $(form_alert).addClass("alert-danger");
        $(form_alert).addClass("in");
    });
});

$("#reddit-front-page-alert").click(function () {
    $(form_alert).text("You need to sign in first!");
    $(form_alert).addClass("alert-danger");
    $(form_alert).addClass("in");
});