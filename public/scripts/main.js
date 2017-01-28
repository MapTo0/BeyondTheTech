$('.lng').click(function(event) {
  var language = $(this).attr("data-ln");

  $.ajax({
    url: "/",
    method: "PUT",
    data: { 'language': language },
    dataType: "json",
    statusCode: {
      200: function() {
        window.location.reload();
      }
    }
  });
});
