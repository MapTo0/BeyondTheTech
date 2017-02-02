$("#comment-btn").click(function() {
    var blogPostId = $(".blog-post").attr("data-post-id"),
        commentText = $(".comment-area").val();
    comment = {
        "text": commentText
    }
    $.ajax({
        url: "/posts/" + blogPostId + "/comment",
        method: "POST",
        data: comment,
        dataType: "json",
        statusCode: {
            200: function() {
                window.location.reload();
            },
            403: function() {}
        }
    });
});

$(".edit-post-btn").click(function() {
    var blogPostId = $(".blog-post").attr("data-post-id");
    $(".post-body").fadeOut();
    $(".post-title").fadeOut();
    $(".edit-post-btn").fadeOut();
    $(".edit-post-area").fadeIn();
    $(".edit-title").fadeIn();
    $(".save-post-btn").fadeIn();

    $.ajax({
        url: "/posts/" + blogPostId + "/edit",
        method: "GET",
        statusCode: {
            200: function(data) {
                data = JSON.parse(data);
                $(".edit-post-area").val(data.body)
                $(".edit-title").val(data.title)
            },
            403: function() {}
        }
    });
});

$(".save-post-btn").click(function() {
    var blogPostId = $(".blog-post").attr("data-post-id");
    var body = $(".edit-post-area").val();
    var title = $(".edit-title").val();
    $.ajax({
        url: "/posts/" + blogPostId + "/edit",
        method: "PUT",
        data: { body: body, title: title },
        dataType: "json",
        statusCode: {
            200: function() {
                alert("success");
                window.location.reload();
            },
            403: function() {}
        }
    });
});

$(".edit-icon").click(function(event) {
    var save = $(event.target).parent().find(".save-icon");
    var edit = $(event.target);
    var comment = $(event.target).parent().parent().find('.comment-text');
    var textarea = $(event.target).parent().parent().find('.edit-comment');
    var commentId = $(event.target).parent().parent().attr('data-comment-id');
    $(save).fadeIn();
    $(comment).fadeOut();
    $(textarea).fadeIn();

    $.ajax({
        url: "/comments/" + commentId + "/edit",
        method: "GET",
        statusCode: {
            200: function(data) {
                data = JSON.parse(data);
                textarea.val(data.text);
            },
            403: function() {}
        }
    });
});

$(".save-icon").click(function() {
    var save = $(event.target);
    var textarea = $(event.target).parent().parent().find('.edit-comment');
    var commentId = $(event.target).parent().parent().attr('data-comment-id');

    $.ajax({
        url: "/comments/" + commentId + "/edit",
        method: "PUT",
        data: { text: textarea.val() },
        dataType: "json",
        statusCode: {
            200: function() {
                window.location.reload();
            },
            403: function() {}
        }
    });
});
