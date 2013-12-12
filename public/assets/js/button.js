$(".dashboard-device-del").click(function ( event ) {
    event.preventDefault();
    var row = this.parentNode.parentNode.parentNode;
    $.ajax({
        type: "POST",
        url: 'api/device/delete',
        data: {
            uid: this.attributes.uid.value,
            regId: this.attributes.regId.value
        }
    })
    .done(function ( data ) {
        row.remove();
    })
    .fail(function (request, status, error) {
        alert('Error deleting device!');
    });
});

$(".dashboard-device-test").click(function ( event ) {
    event.preventDefault();
    var button = this;
    $.ajax({
        type: "POST",
        url: 'api/test/notification',
        data: {
            regId: this.attributes.regId.value
        }
    })
        .done(function ( data ) {
            button.innerText = "Sent!";
            $(button).attr('disabled','disabled')
        })
        .fail(function (request, status, error) {
            alert('Error sending test notification!');
        });
});

$(".dashboard-notif-del").click(function ( event ) {
    event.preventDefault();
    var notif = this.parentNode.parentNode;
    $.ajax({
        type: "POST",
        url: 'api/notification/delete',
        data: {
            id: this.attributes.id.value
        }
    })
        .done(function ( data ) {
            notif.remove();
        })
        .fail(function (request, status, error) {
            alert('Error deleting device!');
        });
});

$("#reddit-front-page").submit(function( event ) {
    var form = $("#reddit-front-page");
    event.preventDefault();
    var form_data = $(form).serialize();
    var form_url = 'reddit/frontpage/submit';
    var result_div = form.children('.submit-result');
    result_div.empty();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
    .done(function ( data ) {
        handle_saving_notification(data, result_div);
    })
    .fail(function (request, status, error) {
        show_warning_alert(result_div, "Error saving notification: " + data.error);
    });
});

$("#reddit-user-comment").submit(function( event ) {
    var form = $("#reddit-user-comment");
    event.preventDefault();
    var form_data = $(form).serialize();
    var form_url = 'reddit/comment/submit';
    var result_div = form.children('.submit-result');
    result_div.empty();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
        .done(function ( data ) {
            handle_saving_notification(data, result_div);
        })
        .fail(function (request, status, error) {
            show_warning_alert(result_div, "Error saving notification: " + data.error);
        });
});

$("#reddit-user-submission").submit(function( event ) {
    var form = $("#reddit-user-submission");
    event.preventDefault();
    var form_data = $(form).serialize();
    var form_url = 'reddit/submission/submit';
    var result_div = form.children('.submit-result');
    result_div.empty();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
        .done(function ( data ) {
            handle_saving_notification(data, result_div);
        })
        .fail(function (request, status, error) {
            show_warning_alert(result_div, "Error saving notification: " + data.error);
        });
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
        show_warning_alert(result_div, "Unknown Error");
    });
});

$("#weather-temperature").submit(function( event ) {
    event.preventDefault();
    var form = $("#weather-temperature");
    var form_url = 'weather/temperature/submit';
    var form_data = form.serialize();
    var result_div = form.children('.submit-result');
    result_div.empty();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
    .done(function ( data ) {
        handle_saving_notification(data, result_div);
    })
    .fail(function (request, status, error) {
        show_warning_alert(result_div, "Unknown Error");
    });
});

$("#weather-forecast").submit(function( event ) {
    event.preventDefault();
    var form = $("#weather-forecast");
    var form_url = 'weather/forecast/submit';
    var form_data = form.serialize() + "&type=forecast";
    var result_div = form.children('.submit-result');
    result_div.empty();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
        .done(function ( data ) {
            handle_saving_notification(data, result_div);
        })
        .fail(function (request, status, error) {
            show_warning_alert(result_div, "Unknown Error");
        });
});

$("#poly-result").submit(function( event ) {
    event.preventDefault();
    var form = $("#poly-result");
    var form_url = 'poly/result/submit';
    var form_data = form.serialize();
    var result_div = form.children('.submit-result');
    result_div.empty();
    $.ajax({
        type: "POST",
        url: form_url,
        data: form_data
    })
        .done(function ( data ) {
            handle_saving_notification(data, result_div);
        })
        .fail(function (request, status, error) {
            show_warning_alert(result_div, "Unknown Error");
        });
});

function handle_saving_notification(data, div) {
    if(data.success == 'false') {
        show_warning_alert(div, "Error saving notification: " + data.error);
    } else {
        show_success_alert(div, "Notification saved!");
    }
}

function show_success_alert(div, message) {
    div.empty();
    div.append("<div class=\"alert alert-success alert-dismissable fade in\">" +
            "<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>" +
            message + "</div>");
}

function show_warning_alert(div, message) {
    div.empty();
    div.append("<div class=\"alert alert-danger alert-dismissable fade in\">" +
        "<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>" +
        message + "</div>");
}