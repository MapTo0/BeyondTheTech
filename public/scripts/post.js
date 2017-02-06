(function() {
    var createPostBtn = $("#create-post");
    var addLangbtn = $("#add-language-btn");
    var postId = null;

    createPostBtn.bind('click', createPostHandler);

    addLangbtn.click(function() {
        if (checkInvalidation()) {
            alert(eval($("#language-select").val() + "_texts" + "['INVALID_DATA']"));
            return
        };

        createBlogPost(function(id) {
            postId = id;
        });

        $("#blog-title").val("");
        $("#blog-body").val("");
        $("#post-tags").fadeOut();
        $("#blog-image").fadeOut();
        $("#add-language-btn").fadeOut();
        $("#active").fadeOut();
        $("#language-select option[value='" + $("#language-select").val() + "']").remove();

        createPostBtn.unbind('click', createPostHandler);
        createPostBtn.bind('click', updatePostHandler);
    });

    function createBlogPost(callback) {
        let post = {
            "title": $("#blog-title").val(),
            "body": $("#blog-body").val(),
            "imageUrl": $("#blog-image-url").val(),
            "tags": $("#blog-tags").val(),
            "language": $("#language-select").val(),
            "active": ($("#active:checked").length > 0)
        }

        $.ajax({
            url: "/posts",
            method: "POST",
            data: post,
            dataType: "json",
            statusCode: {
                200: function(id) {
                    callback(id);
                },
                403: function() {}
            }
        });
    }

    function updateBlogPost(postId, callback) {
        if (checkInvalidation()) {
            alert(eval($("#language-select").val() + "_texts" + "['INVALID_DATA']"));
            return
        };

        let update = {
            "title": $("#blog-title").val(),
            "body": $("#blog-body").val(),
            "language": $("#language-select").val(),
            "postId": postId
        }

        $.ajax({
            url: "/posts/" + postId,
            method: "PUT",
            data: update,
            dataType: "json",
            statusCode: {
                200: function() {
                    callback();
                },
                403: function() {}
            }
        });
    }

    function checkInvalidation() {
        return validateTitle($('#blog-title')) ||
            validateImage($("#blog-image-url")) ||
            validateBody($("#blog-body")) ||
            validateTags($("#blog-tags"));
    }

    function createPostHandler() {
        if (checkInvalidation()) {
            alert(eval($("#language-select").val() + "_texts" + "['INVALID_DATA']"));
            return
        };

        createBlogPost(function() {
            window.location.href = "/";
        });
    }

    function updatePostHandler() {
        updateBlogPost(postId, function() {
            window.location.href = "/";
        });
    }

    function validateInputLength(domRef, length) {
        return ($(domRef).val().length > length);
    }

    function validateEmptyInput(domRef) {
        return ($(domRef).val().length === 0);
    }

    function isUrl(value) {
        var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
        return regexp.test(value);
    }

    $('#blog-title').focusout(function() {
        $(this).toggleClass('error-state', validateTitle(this));
    });

    $("#blog-image-url").focusout(function() {
        $(this).toggleClass('error-state', validateImage(this));
    });

    $("#blog-body").focusout(function() {
        $(this).toggleClass('error-state', validateBody(this));
    });

    $("#blog-tags").focusout(function() {
        $(this).toggleClass('error-state', validateTags(this));
    });

    function validateTitle(titleRef) {
        return validateInputLength(titleRef, 50) || validateEmptyInput(titleRef);
    }

    function validateImage(imageRef) {
        return !isUrl($(imageRef).val())
    }

    function validateBody(bodyRef) {
        return validateInputLength(bodyRef, 10000) || validateEmptyInput(bodyRef);
    }

    function validateTags(tagsRef) {
        splitted = $(tagsRef).val().split(" ");
        hasInvalidValues = !!splitted.filter(function(tag) {
            return tag.length > 20;
        }).length;

        return hasInvalidValues;
    }
}());
