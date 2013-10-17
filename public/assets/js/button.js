var form = $("#reddit-front-page");
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
        $("#formAlert").addClass("in");
    })
    .fail(function (XMLHttpRequest, textStatus, errorThrown) {

    });
});