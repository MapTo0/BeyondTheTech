$('.lng').click(function(event) {
    var language = $(this).attr("data-ln");

    $.ajax({
        url: "/",
        method: "PUT",
        data: { 'language': language },
        dataType: "json",
        statusCode: {
            200: function() {
                window.location.reload();
            }
        }
    });
});

var en_texts = {
    "COMMENTS": "comments",
    "PASSWORD_SUCCESS_CHANGE": "Password successfully changed!",
    "PASSWORD_NO_SUCCESS_CHANGE": "Old password is not correct!",
    "AUTH_CHANGE_SUCCESS": "Your password was successfully changed!",
    "AUTH_CHECK_MAIL": "Please check your email for more details.",
    "USER_NOT_FOUND": "There is no user found with this email."
};

var bg_texts = {
    "COMMENTS": "коментара",
    "PASSWORD_SUCCESS_CHANGE": "Паролата е сменена успешно!",
    "PASSWORD_NO_SUCCESS_CHANGE": "Текущата парола не е коректна!",
    "AUTH_CHANGE_SUCCESS": "Вашата парола е сменена успешно!",
    "AUTH_CHECK_MAIL": "Моля проверете имейл адреса си за повече информация.",
    "USER_NOT_FOUND": "Не е намерен потребител с този имейл адрес."
};
