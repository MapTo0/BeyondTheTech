(function() {
    var en_texts = {
        "COMMENTS": "comments"
    };

    var bg_texts = {
        "COMMENTS": "коментара"
    }


    $(".post-btn").click(function() {
        var authorId = $($(".criteria-select")[0]).val();
        var tag = $($(".criteria-select")[1]).val();
        var byDate = $($(".criteria-select")[2]).val();
        var byCommentCount = $($(".criteria-select")[3]).val();
        var query = "/posts?authorId=" + authorId + "&tag=";
        query += tag + "&byDate=" + byDate + "&byCommentCount=" + byCommentCount;

        $.ajax({
            url: query,
            method: "GET",
            statusCode: {
                200: function(data) {
                    $("#test").empty();
                    console.log(JSON.parse(data));
                    JSON.parse(data).forEach(function(post) {
                        $("#test").append(renderPost(post));
                    });
                },
                403: function() {}
            }
        });
    });

    function renderPost(post) {
        var post = '<div class="short-post" data-post-id="' + post.id + '">' +
            '  <div class="short-post-image-container">' +
            '    <img class="short-post-image" src="' + post.image + '" alt="Blogpost image">' +
            '  </div>' +
            '  <div class="short-post-body">' +
            '    <div>' +
            '      <h2 class="short-post-title">' + post.title + '</h2>' +
            '      <h2 class="short-post-author">' + post.author.username + '</h2>' +
            '      <h2 class="short-post-date">' + post.date + '</h2>' +
            '    </div>' +
            '    <span class="short-post-comments">' + post.commentCount + " " + eval(post.language + "_texts" + "['COMMENTS']")  + '</span>' +
            '  </div>' +
            '</div>' +
            '<hr class="post-separator">';

        return post;
    }
})();