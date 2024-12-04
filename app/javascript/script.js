// ハンバーガーバー用jquery
document.addEventListener('turbolinks:load', function() {
  $('.menu-trigger').off('click').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').toggleClass('open');
    event.preventDefault();
  });
});

// ファイルプレビュー用jquery
$(document).ready(function () {
  $('#image_input').on('change', function (e) {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function (event) {
        $('#img_prev').attr('src', event.target.result);
      };
      reader.readAsDataURL(file);
    }
  });
});