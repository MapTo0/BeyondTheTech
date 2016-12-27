(function() {
    let registerButton = $("#register"),
        loginButton = $("#login");

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
            	200: function () {
            		window.location.href = "/posts";
            	},
            	403: function () {
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
            	200: function () {
            		window.location.href = "/posts";
            	},
            	401: function () {
            		alert("Invalid credentials");
            	}
            }
        });
    });
}());
