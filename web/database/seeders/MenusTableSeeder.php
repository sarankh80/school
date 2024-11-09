<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class MenusTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {


        \DB::table('menus')->delete();

        \DB::table('menus')->insert(array(
            0 =>
            array(
                'id' => 1,
                'title' => 'Dashboard',
                'nickname' => 'dashboard',
                'url' => 'home',
                'url_params' => NULL,
                'icon' => '<i class="ri-dashboard-line"></i>',
                'parent_id' => 0,
                'menu_order' => 1,
                'permission' => NULL,
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            1 =>
            array(
                'id' => 2,
                'title' => 'Category',
                'nickname' => 'category',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-shopping-basket-2-line"></i>',
                'parent_id' => 0,
                'menu_order' => 2,
                'permission' => 'category list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            2 =>
            array(
                'id' => 3,
                'title' => 'Category List',
                'nickname' => 'categorylist',
                'url' => 'categories.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 2,
                'menu_order' => NULL,
                'permission' => 'category list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            3 =>
            array(
                'id' => 4,
                'title' => 'Category Add',
                'nickname' => 'categoryadd',
                'url' => 'categories.create',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 2,
                'menu_order' => NULL,
                'permission' => 'category add',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            4 =>
            array(
                'id' => 5,
                'title' => 'Service',
                'nickname' => 'service',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-service-line"></i>',
                'parent_id' => 0,
                'menu_order' => 4,
                'permission' => 'service list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            5 =>
            array(
                'id' => 6,
                'title' => 'Service List',
                'nickname' => 'servicelist',
                'url' => 'services.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 5,
                'menu_order' => NULL,
                'permission' => 'service list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            6 =>
            array(
                'id' => 7,
                'title' => 'Service Add',
                'nickname' => 'serviceadd',
                'url' => 'services.create',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 5,
                'menu_order' => NULL,
                'permission' => 'service add',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            7 =>
            array(
                'id' => 8,
                'title' => 'Provider',
                'nickname' => 'provider',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="la la-users"></i>',
                'parent_id' => 0,
                'menu_order' => 6,
                'permission' => 'provider list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            8 =>
            array(
                'id' => 9,
                'title' => 'Provider List',
                'nickname' => 'providerlist',
                'url' => 'providers.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'service list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            9 =>
            array(
                'id' => 10,
                'title' => 'Pending Provider',
                'nickname' => 'providerpending',
                'url' => 'provider.pending',
                'url_params' => 'pending',
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'provider pending',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            10 =>
            array(
                'id' => 11,
                'title' => 'Payout History',
                'nickname' => 'providerhistory',
                'url' => 'providerpayout.index',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-exchange-alt"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'admin,provider',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            11 =>
            array(
                'id' => 12,
                'title' => 'Document',
                'nickname' => 'document',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-shopping-basket-2-line"></i>',
                'parent_id' => 0,
                'menu_order' => 11,
                'permission' => 'document list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            12 =>
            array(
                'id' => 13,
                'title' => 'Document List',
                'nickname' => 'documentlist',
                'url' => 'document.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 12,
                'menu_order' => NULL,
                'permission' => 'document list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            13 =>
            array(
                'id' => 14,
                'title' => 'Document Add',
                'nickname' => 'documentadd',
                'url' => 'document.create',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 12,
                'menu_order' => NULL,
                'permission' => 'document add',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            14 =>
            array(
                'id' => 15,
                'title' => 'Booking',
                'nickname' => 'booking',
                'url' => 'booking.index',
                'url_params' => NULL,
                'icon' => '<i class="fa fa-calendar"></i>',
                'parent_id' => 0,
                'menu_order' => 6,
                'permission' => 'booking list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            15 =>
            array(
                'id' => 16,
                'title' => 'Tax',
                'nickname' => 'tax',
                'url' => 'tax.index',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-percent"></i>',
                'parent_id' => 0,
                'menu_order' => 12,
                'permission' => 'admin',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            16 =>
            array(
                'id' => 17,
                'title' => 'Earning',
                'nickname' => 'earning',
                'url' => 'earning',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-money-bill-alt"></i>',
                'parent_id' => 0,
                'menu_order' => 10,
                'permission' => 'admin',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            17 =>
            array(
                'id' => 18,
                'title' => 'Handyman',
                'nickname' => 'handyman',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="las la-user-friends"></i>',
                'parent_id' => 0,
                'menu_order' => 7,
                'permission' => 'handyman list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            18 =>
            array(
                'id' => 19,
                'title' => 'Handyman List',
                'nickname' => 'handymanlist',
                'url' => 'handyman.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 18,
                'menu_order' => NULL,
                'permission' => 'handyman list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            19 =>
            array(
                'id' => 20,
                'title' => 'Handyman Pending List',
                'nickname' => 'handymanpending',
                'url' => 'handyman.pending',
                'url_params' => 'pending',
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 18,
                'menu_order' => NULL,
                'permission' => 'handyman pending',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            20 =>
            array(
                'id' => 21,
                'title' => 'Users',
                'nickname' => 'users',
                'url' => 'users.index',
                'url_params' => NULL,
                'icon' => '<i class="fa fa-users"></i>',
                'parent_id' => 0,
                'menu_order' => 8,
                'permission' => 'user list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            21 =>
            array(
                'id' => 22,
                'title' => 'Coupon',
                'nickname' => 'coupon',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-coupon-fill"></i>',
                'parent_id' => 0,
                'menu_order' => 13,
                'permission' => 'coupon list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            22 =>
            array(
                'id' => 23,
                'title' => 'Coupon List',
                'nickname' => 'couponlist',
                'url' => 'coupon.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 22,
                'menu_order' => NULL,
                'permission' => 'coupon list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            23 =>
            array(
                'id' => 24,
                'title' => 'Coupon Add',
                'nickname' => 'couponadd',
                'url' => 'coupon.create',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 22,
                'menu_order' => NULL,
                'permission' => 'coupon add',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            24 =>
            array(
                'id' => 25,
                'title' => 'Payment',
                'nickname' => 'payment',
                'url' => 'payment.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-secure-payment-line"></i>',
                'parent_id' => 0,
                'menu_order' => 9,
                'permission' => 'payment list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            25 =>
            array(
                'id' => 26,
                'title' => 'Slider',
                'nickname' => 'slider',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-slideshow-line"></i>',
                'parent_id' => 0,
                'menu_order' => 14,
                'permission' => 'slider list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            26 =>
            array(
                'id' => 27,
                'title' => 'Slider List',
                'nickname' => 'sliderlist',
                'url' => 'sliders.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 26,
                'menu_order' => NULL,
                'permission' => 'slider list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            27 =>
            array(
                'id' => 28,
                'title' => 'Slider Add',
                'nickname' => 'slideradd',
                'url' => 'sliders.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 26,
                'menu_order' => NULL,
                'permission' => 'slider add',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            28 =>
            array(
                'id' => 29,
                'title' => 'Account Setting',
                'nickname' => 'account_setting',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-list-settings-line"></i>',
                'parent_id' => 0,
                'menu_order' => 18,
                'permission' => 'role list,permission list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            29 =>
            array(
                'id' => 30,
                'title' => 'Role List',
                'nickname' => 'rolelist',
                'url' => 'role.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 29,
                'menu_order' => NULL,
                'permission' => 'role list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            30 =>
            array(
                'id' => 31,
                'title' => 'Permission List',
                'nickname' => 'permissionlist',
                'url' => 'permission.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 29,
                'menu_order' => NULL,
                'permission' => 'permission list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            31 =>
            array(
                'id' => 32,
                'title' => 'Pages',
                'nickname' => 'pages',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-pages-line"></i>',
                'parent_id' => 0,
                'menu_order' => 15,
                'permission' => 'pages',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            32 =>
            array(
                'id' => 33,
                'title' => 'Terms Condition',
                'nickname' => 'termscondition',
                'url' => 'term-condition',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-file-contract"></i>',
                'parent_id' => 32,
                'menu_order' => NULL,
                'permission' => 'terms condition',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            33 =>
            array(
                'id' => 34,
                'title' => 'Privacy Policy',
                'nickname' => 'privacypolicy',
                'url' => 'privacy-policy',
                'url_params' => NULL,
                'icon' => '<i class="ri-file-shield-2-line"></i>',
                'parent_id' => 32,
                'menu_order' => NULL,
                'permission' => 'privacy policy',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            34 =>
            array(
                'id' => 35,
                'title' => 'Setting',
                'nickname' => 'setting',
                'url' => 'setting.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-settings-2-line"></i>',
                'parent_id' => 0,
                'menu_order' => 16,
                'permission' => 'system setting',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            35 =>
            array(
                'id' => 36,
                'title' => 'Provider Type List',
                'nickname' => 'providertype list',
                'url' => 'providertype.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-file-list-3-line"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'providertype list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            36 =>
            array(
                'id' => 37,
                'title' => 'Address List',
                'nickname' => 'address List',
                'url' => 'addresses.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-file-list-3-line"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'address list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            37 =>
            array(
                'id' => 38,
                'title' => 'Provider Document List',
                'nickname' => 'document List',
                'url' => 'providerdocument.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-file-list-3-line"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'providerdocument list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            38 =>
            array(
                'id' => 39,
                'title' => 'Handyman Earning',
                'nickname' => 'handyman earning',
                'url' => 'handymanEarning',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-money-bill-alt"></i>',
                'parent_id' => 18,
                'menu_order' => NULL,
                'permission' => 'provider',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            39 =>
            array(
                'id' => 40,
                'title' => 'Handyman Type List',
                'nickname' => 'handymantype list',
                'url' => 'handymantype.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-file-list-3-line"></i>',
                'parent_id' => 18,
                'menu_order' => NULL,
                'permission' => 'provider',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            40 =>
            array(
                'id' => 41,
                'title' => 'Handyman Payout List',
                'nickname' => 'handymanpayout list',
                'url' => 'handymanpayout.index',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-exchange-alt"></i>',
                'parent_id' => 18,
                'menu_order' => NULL,
                'permission' => 'handyman,provider',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            41 =>
            array(
                'id' => 42,
                'title' => 'Wallet List',
                'nickname' => 'walletlist',
                'url' => 'wallet.index',
                'url_params' => NULL,
                'icon' => '<i class="fas fa-exchange-alt"></i>',
                'parent_id' => 8,
                'menu_order' => NULL,
                'permission' => 'admin',
                'status' => 1,
                'created_at' => '2022-04-01 11:38:15',
                'updated_at' => NULL,
            ),
            42 =>
            array(
                'id' => 43,
                'title' => 'SubCategory',
                'nickname' => 'subcategory',
                'url' => NULL,
                'url_params' => NULL,
                'icon' => '<i class="ri-shopping-basket-2-line"></i>',
                'parent_id' => 0,
                'menu_order' => 3,
                'permission' => 'subcategory list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            43 =>
            array(
                'id' => 44,
                'title' => 'SubCategory List',
                'nickname' => 'subcategorylist',
                'url' => 'subcategory.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 43,
                'menu_order' => NULL,
                'permission' => 'subcategory list',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            44 =>
            array(
                'id' => 45,
                'title' => 'SubCategory Add',
                'nickname' => 'subcategoryadd',
                'url' => 'subcategory.create',
                'url_params' => NULL,
                'icon' => '<i class="ri-add-box-line"></i>',
                'parent_id' => 43,
                'menu_order' => NULL,
                'permission' => 'subcategory add',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
            45 =>
            array(
                'id' => 46,
                'title' => 'Plans',
                'nickname' => 'plans',
                'url' => 'plans.index',
                'url_params' => NULL,
                'icon' => '<i class="ri-list-unordered"></i>',
                'parent_id' => 0,
                'menu_order' => 5,
                'permission' => 'admin',
                'status' => 1,
                'created_at' => '2022-02-03 11:38:15',
                'updated_at' => NULL,
            ),
        ));
    }
}
