$('.lng').click(function(event) {
    var language = $(this).attr("data-ln");

    sessionStorage['language'] = language;

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
    "USER_NOT_FOUND": "There is no user found with this email.",
    "INVALID_DATA": "Please fill the inputs with correct data",
    "INVALID_EMAIL_USERNAME": "Invalid email or username. Please check if you have provided the right email address. Username should be between 3 and 25 symbols long.",
    "CHANGES_APPLIED": "Changes were successfully applied."
};

var bg_texts = {
    "COMMENTS": "коментара",
    "PASSWORD_SUCCESS_CHANGE": "Паролата е сменена успешно!",
    "PASSWORD_NO_SUCCESS_CHANGE": "Текущата парола не е коректна!",
    "AUTH_CHANGE_SUCCESS": "Вашата парола е сменена успешно!",
    "AUTH_CHECK_MAIL": "Моля проверете имейл адреса си за повече информация.",
    "USER_NOT_FOUND": "Не е намерен потребител с този имейл адрес.",
    "INVALID_DATA": "Моля попълнете полетата с валидни данни",
    "INVALID_EMAIL_USERNAME": "Невалиден имейл или потребителско име. Моля проверете дали въведения адрес е валиден. Потребилтеското име трябва да е с дължина между 3 и 25 символа",
    "CHANGES_APPLIED": "Промените бяха запазени успешно"
};
