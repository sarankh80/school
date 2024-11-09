<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('show_booking', $booking->id) }}
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card card-block card-stretch">
                                    <div class="card-body p-0">
                                        <div class="d-flex justify-content-between align-items-center p-3">
                                            <h5 class="font-weight-bold">{{ __('messages.book_id') }}
                                                {{ '#' . $booking->id }} </h5>
                                            @if ($booking->handymanAdded->count() == 0)
                                                @hasanyrole('admin|demo_admin|provider')
                                                    <a href="{{ route('booking.assign_form', ['id' => $booking->id]) }}"
                                                        class="float-right btn btn-sm btn-primary loadRemoteModel"><i
                                                            class="lab la-telegram-plane"></i>
                                                        {{ __('messages.assign') }}</a>
                                                @endhasanyrole
                                            @endif
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="card card-block card-stretch">
                                    <div class="card-body">
                                        <div class="table-responsive-sm">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th scope="col">@lang('messages.name')</th>
                                                        <th scope="col">@lang('messages.price')</th>
                                                        <th scope="col">@lang('messages.quantity')</th>
                                                        <th class="text-right" scope="col">@lang('messages.sub_total')</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    @if (count($booking->items) > 0)
                                                        @foreach ($booking->items as $item)
                                                            <tr>
                                                                <td>{{ $item->name }}</td>
                                                                <td>{{ '$' . number_format($item->price, 2, '.', '') }}
                                                                </td>
                                                                <td>{{ $item->quantity }}</td>
                                                                <td class="text-right">
                                                                    {{ '$' . number_format($item->total, 2, '.', '') }}
                                                                </td>
                                                            </tr>
                                                        @endforeach
                                                    @endif
                                                    <tr>
                                                        <td class="text-right" colspan="2">
                                                            {{ __('messages.sub_total') }}</td>
                                                        <td colspan="2" class="text-danger text-right">
                                                            {{ getPriceFormat($booking->amount) }}
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-right" colspan="2">
                                                            {{ __('messages.coupon') }} (-)</td>
                                                        @php
                                                            $discount = '';
                                                            if ($booking->couponAdded != null) {
                                                                $discount = optional($booking->couponAdded)->discount ?? '-';
                                                                $discount_type = optional($booking->couponAdded)->discount_type ?? 'fixed';
                                                                $discount = getPriceFormat($discount);
                                                                if ($discount_type == 'percentage') {
                                                                    $discount = $discount . '%';
                                                                }
                                                            }
                                                        @endphp
                                                        <td colspan="2" class="text-danger text-right">(
                                                            {{ optional($booking->couponAdded)->code ?? '-' }})
                                                            {{ $discount }} </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-right" colspan="2">
                                                            {{ __('messages.discount') }} (-)</td>
                                                        <td colspan="2" class="text-danger text-right">
                                                            {{ !empty($booking->discount) ? $booking->discount : 0 }}%
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-right" colspan="2">
                                                            {{ __('messages.total_amount') }}</td>
                                                        <td colspan="2" class="text-danger text-right">
                                                            {{ !empty($booking->total_amount) ? getPriceFormat($booking->total_amount) : 0 }}
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="row">
                            <div class="col-sm-3 col-lg-12">
                                <div class="card card-block card-stretch card-height">
                                    <div class="card-body">
                                        <div class="profile-card rounded mb-3">
                                            <img src="{{ getSingleMedia($booking->customer, 'profile_image') }}"
                                                alt="profile-bg"
                                                class="avatar-100 d-block mx-auto img-fluid mb-3  avatar-rounded">
                                            <h3 class="text-white text-center">
                                                {{ optional($booking->customer)->display_name ?? '-' }}</h3>
                                        </div>
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="p-icon mr-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="text-primary"
                                                    width="20" fill="none" viewBox="0 0 24 24"
                                                    stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M3 19v-8.93a2 2 0 01.89-1.664l7-4.666a2 2 0 012.22 0l7 4.666A2 2 0 0121 10.07V19M3 19a2 2 0 002 2h14a2 2 0 002-2M3 19l6.75-4.5M21 19l-6.75-4.5M3 10l6.75 4.5M21 10l-6.75 4.5m0 0l-1.14.76a2 2 0 01-2.22 0l-1.14-.76">
                                                    </path>
                                                </svg>
                                            </div>
                                            <p class="mb-0">{{ optional($booking->customer)->email ?? '-' }}</p>
                                        </div>
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="p-icon mr-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="text-primary"
                                                    width="20" fill="none" viewBox="0 0 24 24"
                                                    stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M16 8l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2M5 3a2 2 0 00-2 2v1c0 8.284 6.716 15 15 15h1a2 2 0 002-2v-3.28a1 1 0 00-.684-.948l-4.493-1.498a1 1 0 00-1.21.502l-1.13 2.257a11.042 11.042 0 01-5.516-5.517l2.257-1.128a1 1 0 00.502-1.21L9.228 3.683A1 1 0 008.279 3H5z">
                                                    </path>
                                                </svg>
                                            </div>
                                            <p class="mb-0">
                                                {{ optional($booking->customer)->phone_number ?? '-' }}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-3 col-lg-12">
                                <div class="card card-block card-stretch card-height">
                                    <div class="card-body">
                                        <ul class="list-group list-group-flush">
                                            <li
                                                class="list-group-item d-flex flex-xl-row flex-column justify-content-between align-items-center align-items-xl-start px-0">
                                                <b>{{ __('messages.payment_method') }}</b>
                                                <small>
                                                    {{ optional($booking->payment)->payment_method ?? '-' }}</small>
                                            </li>
                                            <li
                                                class="list-group-item d-flex flex-xl-row flex-column justify-content-between align-items-center align-items-xl-start px-0">
                                                <b>{{ __('messages.payment_status') }}</b>
                                                <small>
                                                    {{ optional($booking->payment)->payment_status ?? '-' }}</small>
                                            </li>
                                            <li
                                                class="list-group-item d-flex flex-xl-row flex-column justify-content-between align-items-center align-items-xl-start px-0">
                                                <b>{{ __('messages.book_at') }}</b>
                                                <small>{{ !empty($booking->date) ? $booking->date : '-' }}</small>
                                            </li>
                                            <li
                                                class="list-group-item d-flex flex-xl-row flex-column justify-content-between align-items-center align-items-xl-start px-0">
                                                <b>{{ __('messages.start_at') }}</b>
                                                <small>{{ !empty($booking->start_at) ? $booking->start_at : '-' }}</small>
                                            </li>
                                            <li
                                                class="list-group-item d-flex flex-xl-row flex-column justify-content-between align-items-center align-items-xl-start px-0">
                                                <b>{{ __('messages.end_at') }}</b>
                                                <small>{{ !empty($booking->end_at) ? $booking->end_at : '-' }}</small>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            @if (count($booking->bookingActivity) > 0)
                                <div class="col-sm-6 col-lg-12">
                                    <div class="card">
                                        <div class="card-body activity-height">
                                            <ul class="iq-timeline">
                                                @foreach ($booking->bookingActivity as $activity)
                                                    <li>
                                                        <div class="timeline-dots"></div>
                                                        <h6 class="float-left mb-1">
                                                            {{ str_replace('_', ' ', ucfirst($activity->activity_type)) }}
                                                        </h6>
                                                        <small
                                                            class="float-right mt-1">{{ $activity->datetime }}</small>
                                                        <div class="d-inline-block w-100">
                                                            <p>{{ $activity->activity_message }}</p>
                                                        </div>
                                                    </li>
                                                @endforeach
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    @section('bottom_script')
        <script type="text/javascript">
            $(document).ready(function() {
                $('.galary').each(function(index, value) {
                    let galleryClass = $(value).attr('data-gallery');
                    $(galleryClass).magnificPopup({
                        delegate: 'a#attachment_files',
                        type: 'image',
                        callbacks: {
                            elementParse: function(item) {
                                if (item.el[0].className.includes('video')) {
                                    item.type = 'iframe',
                                        item.iframe = {
                                            markup: '<div class="mfp-iframe-scaler">' +
                                                '<div class="mfp-close"></div>' +
                                                '<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>' +
                                                '<div class="mfp-title">Some caption</div>' +
                                                '</div>'
                                        }
                                } else {
                                    item.type = 'image',
                                        item.tLoading = 'Loading image #%curr%...',
                                        item.mainClass = 'mfp-img-mobile',
                                        item.image = {
                                            tError: '<a href="%url%">The image #%curr%</a> could not be loaded.'
                                        }
                                }
                            }
                        }
                    })
                })
            })
        </script>
    @endsection
</x-master-layout>
