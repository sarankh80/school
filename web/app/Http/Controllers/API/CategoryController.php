<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Category;
use App\Http\Resources\API\CategoryResource;
use App\Repositories\CategoryRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use Prettus\Repository\Exceptions\RepositoryException;
use App\Criteria\LimitOffsetCriteria;

class CategoryController extends Controller
{
    /**
     * @var CategoryRepository
     */
    protected $categoryRepo;

    /**
     * Create a new controller instance.
     *
     * @param  App\Repositories\CategoryRepository  $categoryRepository
     *
     * @return void
     */
    public function __construct(CategoryRepository $categoryRepository)
    {
        $this->categoryRepo = $categoryRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        app()->setLocale($request->header("X-localization")??"en");
        try {
            $this->categoryRepo->pushCriteria(new RequestCriteria($request));
            $this->categoryRepo->pushCriteria(new LimitOffsetCriteria($request));

            $categories = $this->categoryRepo->get();

        } catch (RepositoryException $e) {
            return $this->sendError($e->getMessage());
        }

        return $this->sendResponse($categories, 'Categories retrieved successfully');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $id)
    {
        app()->setLocale($request->header("X-localization")??"en");
        if (!empty($this->categoryRepo)) {
            try {
                $this->categoryRepo->pushCriteria(new RequestCriteria($request));
                $this->categoryRepo->pushCriteria(new LimitOffsetCriteria($request));
            } catch (RepositoryException $e) {
                return $this->sendError($e->getMessage());
            }
            $category = $this->categoryRepo->find($id);
        }

        if (empty($category)) {
            return $this->sendError('Category not found');
        }        
        return $this->sendResponse($category, 'Category retrieved successfully');
    }
    public function find(Request $request, $id)
    {
        app()->setLocale($request->header("X-localization")??"en");
        if (!empty($this->categoryRepo)) {
            try {
                $this->categoryRepo->pushCriteria(new RequestCriteria($request));
                $this->categoryRepo->pushCriteria(new LimitOffsetCriteria($request));
            } catch (RepositoryException $e) {
                return $this->sendError($e->getMessage());
            }           
            $category = $this->categoryRepo->getVisibleCategoryTree($id);
        }        
        if (empty($category)) {
            return $this->sendError('Category not found');
        }
        return $this->sendResponse($category, 'Category retrieved successfully');
    }

    public function getCategoryList(Request $request)
    {
        $category = Category::where('status', 1);

        if ($request->has('is_featured')) {
            $category->where('is_featured', $request->is_featured);
        }

        $per_page = config('constant.PER_PAGE_LIMIT');
        if ($request->has('per_page') && !empty($request->per_page)) {
            if (is_numeric($request->per_page)) {
                $per_page = $request->per_page;
            }
            if ($request->per_page === 'all') {
                $per_page = $category->count();
            }
        }

        $category = $category->orderBy('name', 'asc')->paginate($per_page);
        $items = CategoryResource::collection($category);

        $response = [
            'pagination' => [
                'total_items' => $items->total(),
                'per_page' => $items->perPage(),
                'currentPage' => $items->currentPage(),
                'totalPages' => $items->lastPage(),
                'from' => $items->firstItem(),
                'to' => $items->lastItem(),
                'next_page' => $items->nextPageUrl(),
                'previous_page' => $items->previousPageUrl(),
            ],
            'data' => $items,
        ];

        return comman_custom_response($response);
    }
}
