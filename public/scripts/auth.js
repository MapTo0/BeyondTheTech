(function() {
    let registerButton = $("#register"),
        loginButton = $("#login"),
        forgottenPass = $(".forgotten-pass-span"),
        sendEmail = $("#send-password");

    registerButton.click(function() {
        if (!checkRegisterValidation()) {
            var lanuage = sessionStorage['language'] || 'en';
            message = eval(lanuage + "_texts" + "['INVALID_EMAIL_USERNAME']");

            alert(message);
            return;
        }

        let user = {
            "username": $("#username").val(),
            "email": $("#email").val(),
            "password": $("#password").val()
        }

        $.ajax({
            url: "/register",
            method: "POST",
            data: user,
            dataType: "json",
            statusCode: {
                200: function() {
                    window.location.href = "/";
                },
                403: function(response) {
                    alert(response.responseText);
                }
            }
        });
    });

    loginButton.click(function() {
        let user = {
            "username": $("#username").val(),
            "password": $("#password").val()
        }

        $.ajax({
            url: "/login",
            method: "POST",
            data: user,
            dataType: "json",
            statusCode: {
                200: function() {
                    window.location.href = "/";
                },
                401: function() {
                    alert("Invalid credentials");
                }
            }
        });
    });

    forgottenPass.click(function() {
        $(".login-form").hide(300, function() {
            $(".forgotten-pass-form").fadeIn(function() {
                $(this).css("display", "flex");
            });
        });
    });

    sendEmail.click(function() {
        $.ajax({
            url: "/users/password",
            method: "POST",
            data: { email: $('.user-email').val() },
            dataType: "json",
            statusCode: {
                200: function(response) {
                    alert(eval(response.responseText + "_texts" + "['AUTH_CHANGE_SUCCESS']") + '\n' + eval(response.responseText + "_texts" + "['AUTH_CHECK_MAIL']"));
                },
                401: function(response) {
                    alert(eval(response.responseText + "_texts" + "['USER_NOT_FOUND']"));
                }
            }
        });
    });

    function checkRegisterValidation() {
        var username = $("#username").val(),
            email = $("#email"),
            emailPattern = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
            isUsernameValid = username.length > 4 && username.length < 25,
            isEmailValid = emailPattern.test(email.val());

        return (isUsernameValid && isEmailValid);
    };
}());
