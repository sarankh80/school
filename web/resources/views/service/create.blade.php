<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('create_service') }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::open(['method' => 'POST', 'route' => 'services.store', 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'service']) }}
                        @livewire('services.service-form')
                        <div class="row">
                            <div class="form-group col-md-6">
                                {{ Form::label('category_id', trans('messages.category') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                <tree-view behavior="normal" value-field="id" name-field="category_id" input-type="radio"
                                    items='@json($categories)' value=''
                                    fallback-locale="{{ config('app.fallback_locale') }}"></tree-view>
                            </div>
                            <div class="form-group col-md-6">
                                {{ Form::label('parent_id', __('messages.parent_service'), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('parent_id[]', $services, old('parent_id'), [
                                    'class' => 'select2js form-group parent_id',
                                    'multiple' => 'multiple',
                                    'id' => 'parent_id',
                                    'data-placeholder' => __('messages.parent_service', ['select' => __('messages.parent_service')]),
                                ]) }}
                            </div>
                            <div class="form-group col-md-6">
                                <label for="tags" class="control-label"><i class="fa fa-tag"
                                        aria-hidden="true"></i>{{ __('messages.tags') }}</label>
                                <input type="text" class="tagsinput" id="tags" name="tags"
                                    value="{{ old('tags') }}" data-role="tagsinput">
                            </div>
                            <div class="col-md-12">
                                {{ Form::submit(__('messages.save'), ['class' => 'btn btn-md btn-primary float-right']) }}
                            </div>
                        </div>
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