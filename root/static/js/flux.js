$(function() {
    // Modals
    $('.modal').modal({
        show     : false,
        backdrop : true,
        keyboard : true
    });

    $('.modal-auto').modal({
        show     : true,
        backdrop : true,
        keyboard : true
    });

    $('.modal-close').click(function() {
        $('.modal').modal('hide');
    });

    $('.close').click(function() {
        $(this).parent().fadeOut(300);
    });

    $('#openMessages').click(function() {
        $('#modal_messages').modal('toggle');
    });

    $('.alert').click(function() {
        $(this).fadeOut(300);
    });

    // roles
    $('#show_new_role').click(function() {
        $('#new_role').slideToggle(300);
    });

    $('#nav-search-text').hover(function() {
        $(this).focus();
    });
});
