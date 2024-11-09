<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('edit_service', $service->id) }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::model($service, ['method' => 'PUT', 'route' => ['services.update', $service->id], 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'service']) }}
                        {{ Form::hidden('id') }}
                        @livewire('services.service-form', ['service' => $service])

                        <div class="row">
                            <div class="form-group col-md-6">
                                {{ Form::label('category_id', trans('messages.category') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                <tree-view behavior="normal" value-field="id" name-field="category_id" input-type="radio"
                                    items='@json($categories)' value='{{ $service->category_id }}'
                                    fallback-locale="{{ config('app.fallback_locale') }}"></tree-view>
                            </div>

                            <div class="form-group col-md-6">
                                {{ Form::label('parent_id', __('messages.parent_service'), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('parent_id[]', $services, $service->parents->pluck('id'), [
                                    'class' => 'select2js form-group parent_id',
                                    'multiple' => 'multiple',
                                    'id' => 'parent_id',
                                    'data-placeholder' => __('messages.parent_service', ['select' => __('messages.parent_service')]),
                                ]) }}
                            </div>
                            <div class="form-group col-md-6">
                                <label for="tags" class="control-label"><i class="fa fa-tag"
                                        aria-hidden="true"></i>{{ __('messages.tags') }}</label>
                                <input type="text" class="tagsinput" id="tags" name="tags" value=""
                                    data-role="tagsinput">
                            </div>
                        </div>

                        {{ Form::submit(__('messages.save'), ['class' => 'btn btn-md btn-primary float-right']) }}
                        {{ Form::close() }}
                    </div>
                </div>
            </div>
        </div>
    </div>
    @push('scripts')
        <script type="text/javascript">
            var tags = new Bloodhound({
                datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
                queryTokenizer: Bloodhound.tokenizers.whitespace,
                prefetch: {
                    url: "{{ route('services.tag') }}",
                    filter: function(list) {
                        return $.map(list, function(cityname) {
                            return {
                                name: cityname
                            };
                        });
                    }
                }
            });
            tags.initialize();

            $('#tags').tagsinput({
                typeaheadjs: {
                    name: 'tags',
                    displayKey: 'name',
                    valueKey: 'name',
                    source: tags.ttAdapter()
                }
            });
        </script>
    @endpush
</x-master-layout>
