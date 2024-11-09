<?php

use App\Http\Controllers\HomeController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\PermissionController;
use App\Http\Controllers\Admin\RoleController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\BrandController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\ProviderTypeController;
use App\Http\Controllers\ProviderController;
use App\Http\Controllers\HandymanController;
use App\Http\Controllers\CouponController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\SliderController;
use App\Http\Controllers\SettingController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\FrontendController;
use App\Http\Controllers\ProviderAddressController;
use App\Http\Controllers\DocumentsController;
use App\Http\Controllers\ProviderDocumentController;
use App\Http\Controllers\RatingReviewController;
use App\Http\Controllers\PaymentGatewayController;
use App\Http\Controllers\TaxController;
use App\Http\Controllers\EarningController;
use App\Http\Controllers\ProviderPayoutController;
use App\Http\Controllers\HandymanPayoutController;
use App\Http\Controllers\HandymanTypeController;
use App\Http\Controllers\ServiceFaqController;
use App\Http\Controllers\WalletController;
use App\Http\Controllers\SubCategoryController;
use App\Http\Controllers\PlanController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\Admin\CartRuleController;
use App\Http\Controllers\Admin\CatalogRuleController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

require __DIR__ . '/auth.php';
Route::get('/', [FrontendController::class, 'index'])->name('frontend.index');
Route::get('/privacy-policy', [FrontendController::class, 'privacy'])->name('frontend.privacy');
Route::get('/history-booking/{id}', [FrontendController::class, 'history'])->name('frontend.history');
Route::group(['prefix' => 'auth'], function () {
    // Route::get('login', [HomeController::class, 'authLogin'])->name('auth.login');
    // Route::get('register', [HomeController::class, 'authRegister'])->name('auth.register');
    Route::get('recover-password', [HomeController::class, 'authRecoverPassword'])->name('auth.recover-password');
    Route::get('confirm-email', [HomeController::class, 'authConfirmEmail'])->name('auth.confirm-email');
    Route::get('lock-screen', [HomeController::class, 'authlockScreen'])->name('auth.lock-screen');
});
Route::get('register')->name('auth.register')->uses([HomeController::class, 'authLogin']);
// Route::get('login')->name('auth.login')->uses([HomeController::class, 'authLogin']);
Route::get('gogoSpiderHeroLog')->name('auth.login')->uses([HomeController::class, 'showLoginForm']);
Route::get('lang/{code}', [HomeController::class, 'lang'])->name('switch-language');

Route::group(['middleware' => ['auth', 'verified']], function () {
    Route::get('/home', [HomeController::class, 'index'])->name('home');
    Route::group(['namespace' => ''], function () {
        Route::resource('permission', PermissionController::class);
        Route::get('permission/add/{type}', [PermissionController::class, 'addPermission'])->name('permission.add');
        Route::post('permission/save', [PermissionController::class, 'savePermission'])->name('permission.save');
    });
    Route::resource('role', RoleController::class);
    Route::resource('units', UnitController::class);
    Route::post('unit-action', [UnitController::class, 'action'])->name('units.action');

    Route::get('changeStatus', [HomeController::class, 'changeStatus'])->name('changeStatus');

    /**
     * Cart rules routes.
     */
    Route::get('cart-rules', [CartRuleController::class, 'index'])->defaults('_config', [
        'view' => 'promotions.cart-rules.index',
    ])->name('cart_rules.index');

    Route::get('cart-rules/create', [CartRuleController::class, 'create'])->defaults('_config', [
        'view' => 'promotions.cart-rules.create',
    ])->name('cart_rules.create');

    Route::post('cart-rules/create', [CartRuleController::class, 'store'])->defaults('_config', [
        'redirect' => 'cart_rules.index',
    ])->name('cart_rules.store');

    Route::get('cart-rules/copy/{id}', [CartRuleController::class, 'copy'])->defaults('_config', [
        'view' => 'promotions.cart-rules.edit',
    ])->name('cart_rules.copy');

    Route::get('cart-rules/edit/{id}', [CartRuleController::class, 'edit'])->defaults('_config', [
        'view' => 'promotions.cart-rules.edit',
    ])->name('cart_rules.edit');

    Route::post('cart-rules/edit/{id}', [CartRuleController::class, 'update'])->defaults('_config', [
        'redirect' => 'cart_rules.index',
    ])->name('cart_rules.update');

    Route::delete('cart-rules/delete/{id}', [CartRuleController::class, 'destroy'])->name('cart_rules.delete');

    Route::get('cart-rules/attributes', [CartRuleController::class, 'getConditionAttributes'])->name('cart_rules.attributes');

    Route::get('cart-rules/conditions/{cartRuleId}', [CartRuleController::class, 'getConditions'])->name('cart_rules.conditions');

    /**
     * Catalog rules routes.
     */
    Route::get('catalog-rules', [CatalogRuleController::class, 'index'])->defaults('_config', [
        'view' => 'promotions.catalog-rules.index',
    ])->name('catalog_rules.index');

    Route::get('catalog-rules/create', [CatalogRuleController::class, 'create'])->defaults('_config', [
        'view' => 'promotions.catalog-rules.create',
    ])->name('catalog_rules.create');

    Route::post('catalog-rules/create', [CatalogRuleController::class, 'store'])->defaults('_config', [
        'redirect' => 'catalog_rules.index',
    ])->name('catalog_rules.store');

    Route::get('catalog-rules/edit/{id}', [CatalogRuleController::class, 'edit'])->defaults('_config', [
        'view' => 'promotions.catalog-rules.edit',
    ])->name('catalog_rules.edit');

    Route::post('catalog-rules/edit/{id}', [CatalogRuleController::class, 'update'])->defaults('_config', [
        'redirect' => 'catalog_rules.index',
    ])->name('catalog_rules.update');

    Route::post('catalog-rules/delete/{id}', [CatalogRuleController::class, 'destroy'])->name('catalog_rules.delete');

    Route::get('catalog-rules/attributes', [CartRuleController::class, 'getConditionAttributes'])->name('catalog_rules.attributes');

    Route::get('catalog-rules/conditions/{cartRuleId}', [CartRuleController::class, 'getConditions'])->name('catalog_rules.conditions');
    
    Route::get('sliders', [SliderController::class, 'index'])->name('sliders.index');

    Route::get('sliders/edit/{id}', [SliderController::class, 'edit'])->name('sliders.edit');

    Route::get('sliders/create', [SliderController::class, 'create'])->name('sliders.create');

    Route::post('sliders', [SliderController::class, 'store'])->name('sliders.store');

    Route::post('sliders/{id}', [SliderController::class, 'update'])->name('sliders.update');

    Route::delete('sliders/{id}', [SliderController::class, 'destroy'])->name('sliders.destroy');

    Route::post('slider-action', [SliderController::class, 'action'])->name('sliders.action');

    Route::resource('categories', CategoryController::class);
    Route::post('category-action', [CategoryController::class, 'action'])->name('categories.action');
    Route::resource('brands', BrandController::class);
    Route::post('brand-action', [BrandController::class, 'action'])->name('brand.action');
    Route::resource('services', ServiceController::class);

    Route::post('service-action', [ServiceController::class, 'action'])->name('service.action');
    Route::get('service/tags', [ServiceController::class, 'tags'])->name('services.tag');

    Route::resource('providers', ProviderController::class);
    Route::resource('addresses', ProviderAddressController::class);
    Route::get('provider/list/{status?}', [ProviderController::class, 'index'])->name('provider.pending');
    Route::post('provider-action', [ProviderController::class, 'action'])->name('providers.action');
    Route::resource('providertype', ProviderTypeController::class);
    Route::post('providertype-action', [ProviderTypeController::class, 'action'])->name('providertype.action');
    Route::resource('handyman', HandymanController::class);
    Route::get('handyman/list/{status?}', [HandymanController::class, 'index'])->name('handyman.pending');
    Route::post('handyman-action', [HandymanController::class, 'action'])->name('handyman.action');
    Route::resource('coupon', CouponController::class);
    Route::post('coupons-action', [CouponController::class, 'action'])->name('coupon.action');
    Route::resource('booking', BookingController::class);
    Route::post('booking-save', [App\Http\Controllers\BookingController::class, 'store'])->name('booking.save');
    Route::post('booking-action', [BookingController::class, 'action'])->name('booking.action');
    Route::resource('payment', PaymentController::class);
    Route::post('save-payment', [App\Http\Controllers\API\PaymentController::class, 'savePayment'])->name('payment.save');
    Route::resource('users', CustomerController::class);
    Route::resource('admins', AdminController::class);
    Route::post('user-action', [CustomerController::class, 'action'])->name('users.action');

    Route::get('booking-assign-form/{id}', [BookingController::class, 'bookingAssignForm'])->name('booking.assign_form');
    Route::post('booking-assigned', [BookingController::class, 'bookingAssigned'])->name('booking.assigned');

    // Setting
    Route::get('setting/{page?}', [SettingController::class, 'settings'])->name('setting.index');
    Route::post('/layout-page', [SettingController::class, 'layoutPage'])->name('layout_page');
    Route::post('/layout-page', [SettingController::class, 'layoutPage'])->name('layout_page');
    Route::post('settings/save', [SettingController::class, 'settingsUpdates'])->name('settingsUpdates');
    Route::post('save-app-download', [SettingController::class, 'saveAppDownloadSetting'])->name('saveAppDownload');
    Route::post('dashboard-setting', [SettingController::class, 'dashboardtogglesetting'])->name('togglesetting');
    Route::post('provider-dashboard-setting', [SettingController::class, 'providerdashboardtogglesetting'])->name('providertogglesetting');
    Route::post('handyman-dashboard-setting', [SettingController::class, 'handymandashboardtogglesetting'])->name('handymantogglesetting');
    Route::post('config-save', [SettingController::class, 'configUpdate'])->name('configUpdate');


    Route::post('env-setting', [SettingController::class, 'envChanges'])->name('envSetting');
    Route::post('update-profile', [SettingController::class, 'updateProfile'])->name('updateProfile');
    Route::post('change-password', [SettingController::class, 'changePassword'])->name('changePassword');

    Route::get('notification-list', [NotificationController::class, 'notificationList'])->name('notification.list');
    Route::get('notification-counts', [NotificationController::class, 'notificationCounts'])->name('notification.counts');
    Route::get('notification', [NotificationController::class, 'index'])->name('notification.index');

    Route::post('remove-file', [App\Http\Controllers\HomeController::class, 'removeFile'])->name('remove.file');
    Route::post('get-lang-file', [App\Http\Controllers\LanguageController::class, 'getFile'])->name('getLangFile');
    Route::post('save-lang-file', [App\Http\Controllers\LanguageController::class, 'saveFileContent'])->name('saveLangContent');

    Route::get('pages/term-condition', [SettingController::class, 'termAndCondition'])->name('term-condition');
    Route::post('term-condition-save', [SettingController::class, 'saveTermAndCondition'])->name('term-condition-save');

    Route::get('pages/privacy-policy', [SettingController::class, 'privacyPolicy'])->name('privacy-policy');
    Route::post('privacy-policy-save', [SettingController::class, 'savePrivacyPolicy'])->name('privacy-policy-save');

    Route::resource('document', DocumentsController::class);
    Route::post('document-action', [DocumentsController::class, 'action'])->name('document.action');

    Route::resource('providerdocument', ProviderDocumentController::class);
    Route::post('providerdocument-action', [ProviderDocumentController::class, 'action'])->name('providerdocument.action');

    Route::resource('ratingreview', RatingReviewController::class);
    Route::post('ratingreview-action', [RatingReviewController::class, 'action'])->name('ratingreview.action');

    Route::post('/payment-layout-page', [PaymentGatewayController::class, 'paymentPage'])->name('payment_layout_page');
    Route::post('payment-settings/save', [PaymentGatewayController::class, 'paymentsettingsUpdates'])->name('paymentsettingsUpdates');
    Route::post('get_payment_config', [PaymentGatewayController::class, 'getPaymentConfig'])->name('getPaymentConfig');

    Route::resource('tax', TaxController::class);
    Route::get('earning', [EarningController::class, 'index'])->name('earning');
    Route::get('earning-data', [EarningController::class, 'setEarningData'])->name('earningData');

    Route::get('handyman-earning', [EarningController::class, 'handymanEarning'])->name('handymanEarning');
    Route::get('handyman-earning-data', [EarningController::class, 'handymanEarningData'])->name('handymanEarningData');

    Route::resource('providerpayout', ProviderPayoutController::class);
    Route::get('providerpayout/create/{id}', [ProviderPayoutController::class, 'create'])->name('payout.create');
    Route::post('sidebar-reorder-save', [SettingController::class, 'sequenceSave'])->name('reorderSave');

    Route::resource('handymanpayout', HandymanPayoutController::class);
    Route::get('handymanpayout/create/{id}', [HandymanPayoutController::class, 'create'])->name('handymanpayouts.create');

    Route::resource('handymantype', HandymanTypeController::class);
    Route::post('handymantype-action', [HandymanTypeController::class, 'action'])->name('handymantype.action');

    Route::resource('servicefaq', ServiceFaqController::class);
    Route::post('send-push-notification', [SettingController::class, 'sendPushNotification'])->name('sendPushNotification');
    Route::post('save-earning-setting', [SettingController::class, 'saveEarningTypeSetting'])->name('saveEarningTypeSetting');

    Route::resource('wallet', WalletController::class);
    Route::resource('subcategory', SubCategoryController::class);
    Route::post('subcategory-action', [SubCategoryController::class, 'action'])->name('subcategory.action');

    Route::resource('plans', PlanController::class);
});
Route::get('/ajax-list', [HomeController::class, 'getAjaxList'])->name('ajax-list');
