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
        '    <img class="short-post-image" src="http://cdn.playbuzz.com/cdn/925704be-9b8e-4dfc-852e-f24d720cb9c5/bcf39e88-5731-43bb-9d4b-e5b3b2b1fdf2.jpg" alt="Blogpost image">' +
        '  </div>' +
        '  <div class="short-post-body">' +
        '    <div>' +
        '      <h2 class="short-post-title">A piece of the Nature</h2>' +
        '      <h2 class="short-post-author"><%= texts["HOME_FROM"] %> Martin R. Hristov</h2>' +
        '      <h2 class="short-post-date">25.12.2016</h2>' +
        '    </div>' +
        '    <p class="short-post-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod' +
        '    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,' +
        '    quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo' +
        '    consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse</p>' +
        '    <span class="short-post-comments">420 <%= texts["HOME_COMMENTS"] %></span>' +
        '  </div>' +
        '</div>' +
        '<hr class="post-separator">';

    return post;
}
