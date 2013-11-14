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

$("#modal-search-city").click(function () {
    var weatherAPI = "/api/weather/search/city";
    $(".modal-city-search-result").empty();
    $.ajax({
        type: "POST",
        url: weatherAPI,
        data:
        { city: $("#modal-city").val() }
    })
    .done(function ( data ) {
        $.each( data.list, function( i, item ) {
            $(".modal-city-search-result").append(item.name + " (" + item.sys.country + ") : " + "<strong>" + item.id + "<br />");
        });
    })
    .fail(function (request, status, error) {
        $(".modal-city-search-result").append("Failure!");
    });
});
