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

// ユーザー、投稿編集フォーム用jquery
$(document).on('turbolinks:load', function() {
  $('.edit-btn').on('click', function() {
    var contentDiv = $('#content');
    var formDiv = $('#edit-form');

    contentDiv.addClass('d-none');
    formDiv.removeClass('d-none');
  });

  $('.cancel-edit').on('click', function() {
    var contentDiv = $('#content');
    var formDiv = $('#edit-form');

    formDiv.addClass('d-none');
    contentDiv.removeClass('d-none');
  });
});

// コメント編集フォーム用jquery
$(document).on('turbolinks:load', function() {
  $('.edit-comment-btn').on('click', function() {
    var commentId = $(this).data('comment-id');
    var edit_contentDiv = $('#comment-content-' + commentId);
    var edit_formDiv = $('#edit-form-' + commentId);

    edit_contentDiv.addClass('d-none');
    edit_formDiv.removeClass('d-none');
  });

  $('.cancel-edit-comment').on('click', function() {
    var commentId = $(this).data('comment-id');
    var edit_contentDiv = $('#comment-content-' + commentId);
    var edit_formDiv = $('#edit-form-' + commentId);

    edit_formDiv.addClass('d-none');
    edit_contentDiv.removeClass('d-none');
  });
});

// 活動場所選択フォーム
$(document).on('change', '#circle_prefecture_id', function() {
  var prefectureId = $(this).val();
  var citySelect = $('#circle_city_id');

  if (prefectureId) {
    $.ajax({
      url: '/cities',  // citiesのindexアクションを呼び出す
      data: { prefecture_id: prefectureId },
      dataType: 'json',
      success: function(data) {
        citySelect.empty();  // 既存のcityをクリア
        citySelect.append('<option value="">市を選択</option>');
        $.each(data, function(index, city) {
          citySelect.append('<option value="' + city.id + '">' + city.city_name + '</option>');
        });
      }
    });
  } else {
    citySelect.empty();
    citySelect.append('<option value="">市を選択</option>');
  }
});