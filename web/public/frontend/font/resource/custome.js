/*!===================================================================================
Theme Name: Socialated
Author: Bull-Theme
Version: 1.0.0
Created: October 2021
Main Font : Nunito
===================================================================================*/

/*====================================
[ JS TABLE CONTENT ]
------------------------------------
1.0 PROGRESS ICON
2.0 STICKEY HEADER
3.0 MOBILE MENU COLLAPSE
4.0 COUNTER
5.0 BRAND OWLCAROUSEL
6.0 TEAM OWLCAROUSEL
7.0 FORM VALIDATOR
8.0 MASONARY FILTER
-------------------------------------
[ END Js TABLE CONTENT ]
=====================================*/
(function($) {
    "use strict";
/* =============================================
1.0 PROGRESS ICON
============================================= */
// var progressPath = document.querySelector('.progress-wrap path');
// var pathLength = progressPath.getTotalLength();
// progressPath.style.transition = progressPath.style.WebkitTransition = 'none';
// progressPath.style.strokeDasharray = pathLength + ' ' + pathLength;
// progressPath.style.strokeDashoffset = pathLength;
progressPath.getBoundingClientRect();
progressPath.style.transition = progressPath.style.WebkitTransition = 'stroke-dashoffset 10ms linear';
var updateProgress = function() {
    var scroll = $(window).scrollTop();
    var height = $(document).height() - $(window).height();
    var progress = pathLength - (scroll * pathLength / height);
    progressPath.style.strokeDashoffset = progress;
}
updateProgress();
$(window).scroll(updateProgress);
var offset = 150;
var duration = 550;
jQuery(window).on('scroll', function() {
    if (jQuery(this).scrollTop() > offset) {
        jQuery('.progress-wrap').addClass('active-progress');
    } else {
        jQuery('.progress-wrap').removeClass('active-progress');
    }
});
jQuery('.progress-wrap').on('click', function(event) {
    event.preventDefault();
    jQuery('html, body').animate({
        scrollTop: 0
    }, duration);
    return false;
})

/* =============================================
2.0 STICKEY HEADER 
============================================= */
$(window).scroll(function() {
    if($(this).scrollTop() > 100) {
        $('header').addClass("sticky");
    } else {
        $('header').removeClass("sticky");
    }
});
/* =============================================
3.0 MOBILE MENU COLLAPSE
============================================= */
$(".navbar-nav .nav-link").on('click', function(){
    $(".navbar-collapse").removeClass("show");
});

/* =============================================
4.0 COUNTER
============================================= */
$('.counter').counterUp();

/* =============================================
5.0 BRAND OWLCAROUSEL
============================================= */
$('#brand-slider').owlCarousel({
    loop: true,
    dots: false,
    nav: false,
    autoplay: true,
    autoplayHoverPause: true,
    autoHeight: true,
    responsiveClass: true,
    responsive: {
        0: {
            items: 1
        },
        540: {
            items: 2,
        },
        992: {
            items: 3,
        },
        1140: {
            items: 4,
        },
    }
});

/* =============================================
6.0 TEAM OWLCAROUSEL
============================================= */

$('#team2-slider').owlCarousel({
    loop: true,
    dots: true,
    nav: false,
    autoplay: false,
    autoplayHoverPause: true,
    autoHeight: true,
    responsiveClass: true,
    responsive: {
        0: {
            items: 1
        },
        540: {
            items: 2,
        },
        720: {
            items: 3,
        },
        992: {
            items: 2,
        },
        1200: {
            items: 2,
        },
    }
});

/* =============================================
7.0 FORM VALIDATOR
============================================= */
// Example starter JavaScript for disabling form submissions if there are invalid fields
(function() {
    'use strict';
    window.addEventListener('load', function() {
        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        var forms = document.getElementsByClassName('needs-validation');
        // Loop over them and prevent submission
        var validation = Array.prototype.filter.call(forms, function(form) {
            form.addEventListener('submit', function(event) {
                event.preventDefault();
                event.stopPropagation();
                if (form.checkValidity() !== false) {
                    var url = "php/contact.php";
                    $.ajax({
                        type: "POST",
                        url: url,
                        data: $(this).serialize(),
                        success: function(data) {
                            var messageAlert = 'alert-' + data.type;
                            var messageText = data.message;
                            var alertBox = '<div class="alert mb-40 ' + messageAlert + ' alert-dismissible fade show" role="alert">' + messageText + '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>';
                            if (messageAlert && messageText) {
                                $('.needs-validation').find('.messages').hide().html(alertBox).fadeIn('slow');
                                $('.needs-validation')[0].reset();
                            }
                        }
                    });
                }
                form.classList.add('was-validated');
            }, false);
        });
    }, false);
})();
/* =============================================
8.0 MASONARY FILTER
============================================= */
$('.grid').masonry();

}(jQuery));




























