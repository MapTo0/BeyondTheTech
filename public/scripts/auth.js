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
            dataType: "json"
        }).done(function(msg) {
            console.log(msg);
        }).fail(function(msg) {
            console.log(msg);
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
            dataType: "json"
        }).done(function(msg) {
            console.log(msg);
        }).fail(function(msg) {
            console.log(msg);
        });
    });
}());
