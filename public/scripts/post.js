(function() {
    var createPostBtn = $("#create-post");

    createPostBtn.click(function() {
        let post = {
            "title": $("#blog-title").val(),
            "body": $("#blog-body").val(),
            "imageUrl": $("#blog-image-url").val(),
            "tags": $("#blog-tags").val()
        }

        $.ajax({
            url: "/posts",
            method: "POST",
            data: post,
            dataType: "json",
            statusCode: {
                200: function () {
                },
                403: function () {
                }
            }
        });
    });
}());
