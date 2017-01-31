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
            200: function() {
                window.location.href = query;
            },
            403: function() {}
        }
    });

});
