(function() {
    var createPostBtn = $("#create-post");
    var addLangbtn = $("#add-language-btn");
    var postId = null;

    createPostBtn.bind('click', createPostHandler);

    addLangbtn.click(function() {
        createBlogPost(function(id) {
            postId = id;
        });

        $("#blog-title").val("");
        $("#blog-body").val("");
        $("#post-tags").fadeOut();
        $("#blog-image").fadeOut();
        $("#add-language-btn").fadeOut();
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
            "language": $("#language-select").val()
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

    function createPostHandler() {
        createBlogPost(function() {
            window.location.href = "/";
        });
    }

    function updatePostHandler() {
        updateBlogPost(postId, function() {
            window.location.href = "/";
        });
    }
}());
