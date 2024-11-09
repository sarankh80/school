<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="GoGoSpider is a mobile application that allows users to find and hire local handymen (repairmen) for a variety of home services and vehicle maintenance services. The app typically books available handymen in the user's area, along with their ratings, reviews, and pricing information. Users can book and pay for services through the app, as well as track the progress of their jobs.">
    <meta name="keywords" content="GoGoSpider,Services Aircon,Clean Aircon, mobile application,Products,Services,Aircon,Refrigerator,TV,Security and Camera,Lighting,Aircon Service  ,Plumbing Service  ,Electrical Service  ,Smart Home Service  ,Painting Service  ,Material Work  ,Wall Mounted  ,Floor Stand  ,Cassette  ,Install  ,Clean  ,Repair  ,Material  ,Copper Pipe  ,Wire  ,Trunk  ,Pipe  ,Breaker  ,Washing Machine  ,Remove  ,Remove and Install  ,Washing Machine  ,Refrigerator  ,Bracket">
    <meta name="author" content="GoGoSpider">
    <!-- Vendor CSS Files -->

    <link
      href="{{ asset('frontend/assets/vendor/bootstrap/css/bootstrap.min.css')}}"
      rel="stylesheet"
    />
    <link rel="shortcut icon" href="{{ asset('frontend/resource/favicon.ico')}}" />
    <link href="{{ asset('frontend/assets/vendor/fontawesome/css/all.min.css')}}" rel="stylesheet" />
    <link
      href="{{ asset('frontend/assets/vendor/owl.carousel/assets/owl.carousel.min.css')}}"
      rel="stylesheet"
    />

    <link href="{{ asset('frontend/assets/vendor/icofont/icofont.min.css')}}" rel="stylesheet" />

    <link rel="stylesheet" type="text/css" href="{{ asset('frontend/assets/css/style.css')}}" />
    <script src="{{ asset('frontend/assets/vendor/jquery/jquery.min.js')}}"></script>
    <script src="{{ asset('frontend/assets/vendor/bootstrap/js/bootstrap.bundle.min.js')}}"></script>
    <script src="{{ asset('frontend/assets/vendor/owl.carousel/owl.carousel.min.js')}}"></script>

    <script src="{{ asset('frontend/assets/js/carausol_slider.js')}}"></script>
    <title>GoGoSpider</title>
  </head>
  <body>
  <section class="carousel_se_03">
        <div class="container-fluid px-0 py-0">
            <div class="container">
                <h1 style="text-align:center;color:#000;padding:20px;">{{__('messages.privacy_policy')}}</h1>
                {!!$privacy_policy->value!!}
            </div>
        </div>
    </section>
  </body>
</html>