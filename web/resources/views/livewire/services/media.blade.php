<div class="row service_attachment_div">
    <div class="col-md-12">
        @if (getMediaFileExit($service, 'service_attachment'))
            @php
                $attchments = $service->getMedia('service_attachment');
                $file_extention = config('constant.IMAGE_EXTENTIONS');
            @endphp
            <div class="border-left-2">
                <p class="ml-2"><b>{{ __('messages.attached_files') }}</b></p>
                <div class="ml-2 mt-3">
                    <div class="row">
                        @foreach ($attchments as $attchment)
                            <?php
                            $extention = in_array(strtolower(imageExtention($attchment->getFullUrl())), $file_extention);
                            ?>

                            <div class="col-md-2 pr-10 text-center galary file-gallary-{{ $service->id }}"
                                data-gallery=".file-gallary-{{ $service->id }}"
                                id="service_attachment_preview_{{ $attchment->id }}">
                                @if ($extention)
                                    <a id="attachment_files" href="{{ $attchment->getFullUrl() }}"
                                        class="list-group-item-action attachment-list" target="_blank">
                                        <img src="{{ $attchment->getFullUrl() }}" class="attachment-image"
                                            alt="">
                                    </a>
                                @else
                                    <a id="attachment_files" class="video list-group-item-action attachment-list"
                                        href="{{ $attchment->getFullUrl() }}">
                                        <img src="{{ asset('images/file.png') }}" class="attachment-file">
                                    </a>
                                @endif
                                <a class="text-danger remove-file"
                                    href="{{ route('remove.file', ['id' => $attchment->id, 'type' => 'service_attachment']) }}"
                                    data--submit="confirm_form" data--confirmation='true' data--ajax="true"
                                    data-toggle="tooltip"
                                    title='{{ __('messages.remove_file_title', ['name' => __('messages.attachments')]) }}'
                                    data-title='{{ __('messages.remove_file_title', ['name' => __('messages.attachments')]) }}'
                                    data-message='{{ __('messages.remove_file_msg') }}'>
                                    <i class="ri-close-circle-line"></i>
                                </a>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        @endif
    </div>
</div>
