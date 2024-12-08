// turboによってページ遷移時にjavascriptがうまく動作しない可能性がある。だからturbolinks:loadの記述は消さないように。

$(function () {
	$(window).scroll(function () {
		var scroll = $(window).scrollTop();
		if (scroll > 200) {
			$('#hidden-header').addClass('is-show');
		}
		else {
			$('#hidden-header').removeClass('is-show');
		}
	});
});

// ハンバーガーバー用jquery
document.addEventListener('turbolinks:load', function() {
  $('.menu-trigger').off('click').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').toggleClass('open');
    $('body').toggleClass('menu-open');
    event.preventDefault();
  });
});

// ファイルプレビュー用jquery
document.addEventListener('turbolinks:load', function() {
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
});