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

  $('.hamburger').click(function () {
    $(this).addClass('is-active');
  })
  $('.mm-page__blocker.mm-slideout').click(function () {
    if ($('.hamburger').hasClass('is-active')) {
      $('.hamburger').removeClass('is-active');
    }
  })
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