<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            {{ Breadcrumbs::render('providers') }}
                            @can('provider add')
                                <a href="{{ route('providers.create') }}" class="float-right mr-1 btn btn-sm btn-primary"><i
                                        class="fa fa-plus-circle"></i>
                                    {{ __('messages.add_form_title', ['form' => __('messages.provider')]) }}</a>
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
    @endsection
</x-master-layout>
