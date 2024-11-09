<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">
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
                <h1 style="text-align:center;color:#000;padding:20px;">{{__('messages.booking')}} ID : {{$booking->id}}</h1>
                <p> Customer Name (ឈ្មោះ​អតិថិជន): <b calss="red"> {{$booking->customer()->first()->name??"";}}</b> </p>
                <p> Number Phone (លេខទូរស័ព្ទ): <b calss="red"> {{$booking->customer()->first()->phone_number??"";}}</b> </p>
                <p> Date and Time (កាលបរិច្ឆេទ​និង​ពេលវេលា): <b calss="red"> {{ date("Y-m-d h:i:sa", strtotime($booking->date))??"";}}</b> </p>
                <p> Link Maps (ភ្ជាប់ផែនទី): <a href="https://www.google.com/maps/place/{{$address->latitude}},{{$address->longitude}}"> Click Here ( ចុច​ទីនេះ ) </a> </p>
                <p> Address (អាស័យដ្ឋាន) :  {{$address->address}} </p>
                <table class="table table-spacing mb-0">
                    <tr>
                        <th> Item (ផលិតផល) </th>
                        <th> Qty (ចំនួន) </th>
                        <th> Price (តម្លៃ) </th>
                        <!-- <th> Discount </th> -->
                    </tr>
                    <?php $discount = 0; ?>
                    @foreach($booking->items()->get() as $rows)
                        <tr>
                            <td> {{$rows->name}}</td>
                            <td> {{$rows->quantity}}</td>
                            <td>$ {{$rows->price}}</td>
                            <!-- <td>$ {{$rows->discount_amount+$rows->discount_coupon}}</td> -->
                        </tr>
                        <?php  $discount = $discount +($rows->discount_coupon) ; ?>
                    @endforeach
                    <tr style="background-color:red;height:5px;">
                        <td style="padding:0; height: 5px;"></td>
                        <td style="padding:0; height: 5px;"></td>
                        <td style="padding:0; height: 5px;"></td>
                    </tr>
                    <tr>
                        <td>Total (សរុប) :</td>
                        <td></td>
                        <td>$ {{$booking->amount}}</td>
                    </tr>
                    <tr>
                        <td>Discount (បញ្ចុះតម្លៃ) :</td>
                        <td></td>
                        <td>$ {{$discount??0}}</td>
                    </tr>
                    <tr>
                        <td>Gran Total (តំលៃ​បូក​សរុប) :</td>
                        <td></td>
                        <td> <b>$ {{$booking->total_amount-$discount}}<b></td>
                    </tr>
                </table>
            </div>
        </div>
    </section>
  </body>
</html>