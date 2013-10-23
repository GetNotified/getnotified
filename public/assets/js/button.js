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
        $(form_alert).append("Notification saved!");
        $(form_alert).addClass("alert-success");
        $(form_alert).addClass("in");
    })
    .fail(function () {
        $(form_alert).append("Error saving notification!");
        $(form_alert).addClass("alert-danger");
        $(form_alert).addClass("in");
    });
});