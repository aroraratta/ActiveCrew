$(function() {
  $('.menu-trigger').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').toggleClass('open');
    event.preventDefault();
  });
});