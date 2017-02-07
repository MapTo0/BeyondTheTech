$(".remove-admin").click(function() {
    var userId = $(this).attr('data-user-id');
    updateUserRights("remove", userId);
});

$(".add-admin").click(function() {
    var userId = $(this).attr('data-user-id');
    updateUserRights("add", userId);
});

function updateUserRights(action, userId) {
    $.ajax({
        url: "/user",
        method: "PUT",
        data: { action: action, userId: userId },
        dataType: "json",
        statusCode: {
            200: function() {
                location.reload();
            },
            403: function() {}
        }
    });
};
