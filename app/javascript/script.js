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
  function setupFilePreview(inputSelector, previewSelector) {
    $(document).on('change', inputSelector, function(e) {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function(event) {
          $(previewSelector).attr('src', event.target.result);
        };
        reader.readAsDataURL(file);
      }
    });
  }

  setupFilePreview('#image_input', '#img_prev');
  setupFilePreview('#circle_image_input', '#circle_img_prev');
  setupFilePreview('#post_image_input', '#post_img_prev');

  // Circleモーダルを開く際の設定
  $(document).on('click', '#openCircleModalButton', function() {
    $.ajax({
      url: '/circles/new',
      type: 'GET',
      dataType: 'script',
      success: function() {
        setupFilePreview('#circle_image_input', '#circle_img_prev');
      }
    });
  });

  // Postモーダルを開く際の設定
  $(document).on('click', '#openPostModalButton', function() {
    $.ajax({
      url: '/posts/new',
      type: 'GET',
      dataType: 'script',
      success: function() {
        setupFilePreview('#post_image_input', '#post_img_prev');
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
  $(document).on('click', '.cancel-edit', function() {
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

  $(document).on('click', '.cancel-edit-comment', function() {
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
      url: '/cities',
      data: { prefecture_id: prefectureId },
      dataType: 'json',
      success: function(data) {
        citySelect.empty();
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

// マイページのタブ用
$(document).on('turbolinks:load', function() {
  $('#tab-contents .tab').not('#tab1').hide();
  $('#tab-menu a').on('click', function(event) {
    event.preventDefault();
    const targetTab = $(this).attr('href');
    $('#tab-contents .tab').hide();
    $(targetTab).show();
    $('#tab-menu .active a').removeClass('text-blue').addClass('text-white');
    $('#tab-menu .active').removeClass('active').addClass('inactive');
    $(this).parent().removeClass('inactive').addClass('active');
    $(this).removeClass('text-white').addClass('text-blue');
  });
});

// aboutページのスライドショー用
document.addEventListener('turbolinks:load', function() {
  const swiper = new Swiper('.swiper', {
    loop: true,
    pagination: { 
      el: '.swiper-pagination',
    },
    navigation: { 
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    }
  });
});

// aboutページのフェードイン用
$(document).ready(function () {
  function animateOnScroll() {
    $(".hidden").each(function () {
      const elementTop = $(this).offset().top;
      const viewportBottom = $(window).scrollTop() + $(window).height();
      if (elementTop < viewportBottom - 50) {
        $(this).addClass("visible");
      }
    });
  }
  animateOnScroll();
  $(window).on("scroll", function () {
    animateOnScroll();
  });
});

// カレンダー用
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  var circleId = calendarEl.getAttribute('data-circle-id');
  var isAdmin = calendarEl.hasAttribute('data-is-admin');
  var calendar = new Calendar(calendarEl, {
    plugins: [dayGridPlugin],
    initialView: 'dayGridMonth',
    locale: 'jp',
    events: '/circles/' + circleId + '/events',
    timeZone: 'Asia/Tokyo',
    eventDisplay: 'block',
    eventClick: function(info) {
      var eventId = info.event.id;
      var eventDetailUrl;
      if (isAdmin) {
        eventDetailUrl = '/admin/circles/' + circleId + '/events/' + eventId;
      }
      else {
        eventDetailUrl = '/circles/' + circleId + '/events/' + eventId;
      }
      window.location.href = eventDetailUrl;
    },
    dayCellContent: function(arg) {
      return arg.date.getDate();
    }
  });
  calendar.render();
});

// 検索時にサークル以外が選択されるときに活動場所フォームを非表示にする用
$(document).on('turbolinks:load', function () {
  toggleLocationForm();
  $("input[name='[range]']").on('change', function () {
    toggleLocationForm();
  });

  function toggleLocationForm() {
    const selectedRange = $("input[name='[range]']:checked").val();
    if (selectedRange === 'circle') {
      $('#location-form').show();
    } else {
      $('#location-form').hide();
    }
  }
});
