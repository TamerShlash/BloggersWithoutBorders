$('.zoom-image').click(function() {
    var image_url = $(this).closest('.thumbnail').children('img').first().attr('src');
    $('#zoomed-image').attr('src', image_url);
    $('#modal-download-button').attr('href', image_url);
    var src = image_url.split('/');
    $('#myModalLabel').html(src[src.length - 1]);
    $('#myModal').modal();
});