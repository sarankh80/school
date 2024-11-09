<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\Service;
use App\DataTables\CategoryDataTable;
use App\Http\Requests\CategoryRequest;
use App\Repositories\CategoryRepository;
use App\Criteria\CategoryExceptCriteria;

class CategoryController extends Controller
{
    /**
     * @var CategoryRepository
     */
    protected $categoryRepo;

    public function __construct(CategoryRepository $categoryRepository)
    {
       
        $this->categoryRepo = $categoryRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(CategoryDataTable $dataTable)
    {        
        app()->setLocale(app()->getLocale());
        return $dataTable->render('category.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $categories = $this->categoryRepo->getCategoryTree(null, ['id']);
       
        $category_relations = Category::where('status', '=', 1)->get()->pluck('name', 'id');

        return view('category.create', compact('categories', 'category_relations'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(CategoryRequest $request)
    {
        $this->categoryRepo->create($request);

        return redirect(route('categories.index'))->withSuccess(trans('messages.save_form', ['form' => trans('messages.category')]));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $category = $this->categoryRepo->findOrFail($id);
        $category->km = Category::find($category->id)->translate()->first()?Category::find($category->id)->translate()->first()->getTranslation('name', 'km'):$category->name;
        $category->zh = Category::find($category->id)->translate()->first()?Category::find($category->id)->translate()->first()->getTranslation('name', 'zh'):$category->name;
        $categories = $this->categoryRepo->getCategoryTreeWithoutDescendant($id);

        $category_relations = Category::where('id', '!=', $category->id)->get()->pluck('name', 'id');

        return view('category.edit', compact('category', 'categories', 'category_relations'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $this->categoryRepo->update($request, $id);

        return redirect(route('categories.index'))->withSuccess(trans('messages.update_form_title', ['form' => trans('messages.category')]));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        if (demoUserPermission()) {
            return  redirect()->back()->withErrors(trans('messages.demo_permission_denied'));
        }
        $category = Category::find($id);
        $msg = __('messages.msg_fail_to_delete', ['name' => __('messages.category')]);

        if ($category != '') {

            $service = Service::where('category_id', $id)->first();

            $category->delete();
            $msg = __('messages.msg_deleted', ['name' => __('messages.category')]);
        }

        return redirect()->back()->withSuccess($msg);
    }
    public function action(Request $request)
    {
        $id = $request->id;

        $category  = Category::withTrashed()->where('id', $id)->first();
        $msg = __('messages.not_found_entry', ['name' => __('messages.category')]);
        if ($request->type == 'restore') {
            $category->restore();
            $msg = __('messages.msg_restored', ['name' => __('messages.category')]);
        }
        if ($request->type === 'forcedelete') {
            $category->forceDelete();
            $msg = __('messages.msg_forcedelete', ['name' => __('messages.category')]);
        }
        return comman_custom_response(['message' => $msg, 'status' => true]);
    }
}
