(function() {
    let registerButton = $("#register"),
        loginButton = $("#login"),
        forgottenPass = $(".forgotten-pass-span"),
        sendEmail = $("#send-password");

    registerButton.click(function() {
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
                403: function() {
                    alert("Provided data is invalid");
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
}());
