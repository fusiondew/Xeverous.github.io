$(document).ready(function () {
  $("#mmenu").mmenu({
    "extensions": [
      "pagedim-black"
    ],
    "navbars": [{
        "position": "top",
        "content": [
          "searchfield"
        ]
      },
      {
        "position": "top"
      },
    ]
  });

  setTimeout(() => {
    $('#loader-wrapper').hide();
  }, 1000);


  $('.hamburger').click(function () {
    $(this).addClass('is-active');
  })
  $('.mm-page__blocker.mm-slideout').click(function () {
    if ($('.hamburger').hasClass('is-active')) {
      $('.hamburger').removeClass('is-active');
    }
  })
});


$(document).ready(function () {
  $("#back-top").hide();
  $(function () {
    $(window).scroll(function () {
      if ($(this).scrollTop() > 100) {
        $('#back-top').fadeIn();
      } else {
        $('#back-top').fadeOut();
      }
    });
    $('#back-top a').click(function () {
      $('body,html').animate({
        scrollTop: 0
      }, 'slow');
      return false;
    });
  });
});


$(window).bind("load", function () {

  var footerHeight = 0,
    footerTop = 0,
    $footer = $(".footer");

  positionFooter();

  function positionFooter() {
    footerHeight = $footer.height();
    // 20 is as padding height
    footerTop = ($(window).scrollTop() + $(window).height() - footerHeight - 64) + "px";

    if (($(document.body).height() + footerHeight) < $(window).height()) {
      $footer.css({
        position: "absolute",
        width: "100%"
      }).animate({
        top: footerTop
      })
    } 
    else {
      $footer.css({
        position: "static"
      })
    }

  }

  $(window)
    .scroll(positionFooter)
    .resize(positionFooter)
});