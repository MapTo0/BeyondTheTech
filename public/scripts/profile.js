$(".change-password-btn").click(function() {
    var oldPassword = $(".old-password").val(),
        newPassword = $(".new-password").val();

    $.ajax({
        url: "/user/password",
        method: "PUT",
        data: { oldPassword: oldPassword, newPassword: newPassword },
        dataType: "json",
        statusCode: {
            200: function(response) {
                alert(eval(response.responseText + "_texts" + "['PASSWORD_SUCCESS_CHANGE']"));
            },
            403: function(response) {
                alert(eval(response.responseText + "_texts" + "['PASSWORD_NO_SUCCESS_CHANGE']"));
            }
        }
    });
});
