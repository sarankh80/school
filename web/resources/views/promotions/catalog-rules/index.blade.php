<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            {{ Breadcrumbs::render('catalog_rule') }}
                            @can('catalog rule add')
                                <a href="{{ route('catalog_rules.create') }}"
                                    class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i>
                                    {{ __('messages.add_form_title', ['form' => __('messages.catalog-rules')]) }}</a>
                            @endcan
                        </div>
                        {{ $dataTable->table(['class' => 'table  w-100'], false) }}
                    </div>
                </div>
            </div>
        </div>
    </div>
    @section('bottom_script')
        {{ $dataTable->scripts() }}
        @push('scripts')
            <script>
                function reloadPage(getVar, getVal) {
                    let url = new URL(window.location.href);

                    url.searchParams.set(getVar, getVal);

                    window.location.href = url.href;
                }
            </script>
        @endpush
    @endsection
</x-master-layout>
