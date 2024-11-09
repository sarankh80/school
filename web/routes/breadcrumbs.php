<?php // routes/breadcrumbs.php

// Note: Laravel will automatically resolve `Breadcrumbs::` without
// this import. This is nice for IDE syntax and refactoring.
use Diglactic\Breadcrumbs\Breadcrumbs;

// This import is also not required, and you could replace `BreadcrumbTrail $trail`
//  with `$trail`. This is nice for IDE type checking and completion.
use Diglactic\Breadcrumbs\Generator as BreadcrumbTrail;

// Home
Breadcrumbs::for('home', function (BreadcrumbTrail $trail) {
    $trail->push('Home', route('home'));
});

// Home > Service
Breadcrumbs::for('service', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.service'), route('services.index'));
});

// Home > Service > Create
Breadcrumbs::for('create_service', function (BreadcrumbTrail $trail) {
    $trail->parent('service');
    $trail->push(__('messages.add_button_form', ['form' => __('messages.service')]), route('services.create'));
});

// Home > Service > Edit
Breadcrumbs::for('edit_service', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('service');
    $trail->push(__('messages.update_form_title', ['form' => __('messages.service')]), route('services.edit', $id));
});

// Home > Brand
Breadcrumbs::for('brands', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.brand'), route('brands.index'));
});

// Home > Brand > Create
Breadcrumbs::for('create_brand', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.brand'), route('brands.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.brand')]), route('brands.create'));
});

// Home > Brand > Create
Breadcrumbs::for('edit_brand', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('brands');
    $trail->push(__('messages.update_form_title', ['form' => __('messages.brand')]), route('brands.edit', $id));
});

// Home > Category
Breadcrumbs::for('categories', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.category'), route('categories.index'));
});

// Home > Category > Create
Breadcrumbs::for('create_category', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.category'), route('categories.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.category')]), route('categories.create'));
});

// Home > Category > Edit
Breadcrumbs::for('edit_category', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.category'), route('categories.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.category')]), route('categories.edit', $id));
});

// Home > Unit
Breadcrumbs::for('units', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.unit'), route('units.index'));
});

// Home > Unit > Create
Breadcrumbs::for('create_unit', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.unit'), route('units.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.unit')]), route('units.create'));
});

// Home > Unit > Edit
Breadcrumbs::for('edit_unit', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.unit'), route('units.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.unit')]), route('units.edit', $id));
});


// Home > Provider
Breadcrumbs::for('providers', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.provider'), route('providers.index'));
});

// Home > Provider > Create
Breadcrumbs::for('create_provider', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.provider'), route('providers.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.provider')]), route('providers.create'));
});

// Home > Provider > Edit
Breadcrumbs::for('edit_provider', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.provider'), route('providers.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.provider')]), route('providers.edit', $id));
});

// Home > Provider > Show
Breadcrumbs::for('show_provider', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.provider'), route('providers.index'));
    $trail->push(__('messages.view_form_title', ['form' => __('messages.provider')]), route('providers.show', $id));
});

// Home > Address
Breadcrumbs::for('addresses', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.address'), route('addresses.index'));
});

// Home > Address > Create
Breadcrumbs::for('create_address', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.address'), route('addresses.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.address')]), route('addresses.create'));
});

// Home > Address > Edit
Breadcrumbs::for('edit_address', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.address'), route('addresses.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.address')]), route('addresses.edit', $id));
});

// Home > Address > Show
Breadcrumbs::for('show_address', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.address'), route('addresses.index'));
    $trail->push(__('messages.view_form_title', ['form' => __('messages.address')]), route('addresses.show', $id));
});


// Home > Cart Rule
Breadcrumbs::for('cart_rule', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.cart-rules'), route('cart_rules.index'));
});

// Home > Cart Rule > Create
Breadcrumbs::for('create_cart_rule', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.cart-rules'), route('cart_rules.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.cart-rules')]), route('cart_rules.create'));
});

// Home > Address > Edit
Breadcrumbs::for('edit_cart_rule', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.cart-rules'), route('cart_rules.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.cart-rules')]), route('cart_rules.edit', $id));
});


// Home > Catalog Rule
Breadcrumbs::for('catalog_rule', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.catalog-rules'), route('catalog_rules.index'));
});

// Home > catalog Rule > Create
Breadcrumbs::for('create_catalog_rule', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.catalog-rules'), route('catalog_rules.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.catalog-rules')]), route('catalog_rules.create'));
});

// Home > catalog Rule > Edit
Breadcrumbs::for('edit_catalog_rule', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.catalog-rules'), route('catalog_rules.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.catalog-rules')]), route('catalog_rules.edit', $id));
});


// Home > User
Breadcrumbs::for('users', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.user'), route('users.index'));
});

// Home > User > Create
Breadcrumbs::for('create_user', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.user'), route('users.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.user')]), route('users.create'));
});

// Home > User > Edit
Breadcrumbs::for('edit_user', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.user'), route('users.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.user')]), route('users.edit', $id));
});

// Home > User > Show
Breadcrumbs::for('show_user', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.user'), route('users.index'));
    $trail->push(__('messages.view_form_title', ['form' => __('messages.user')]), route('users.show', $id));
});

// Home > Admin
Breadcrumbs::for('admins', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.admins'), route('admins.index'));
});

// Home > Admin > Create
Breadcrumbs::for('create_admin', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.admins'), route('admins.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.admins')]), route('admins.create'));
});

// Home > Admin > Edit
Breadcrumbs::for('edit_admin', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.admins'), route('admins.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.admins')]), route('admins.edit', $id));
});

// Home > User > Show
Breadcrumbs::for('show_admin', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.admins'), route('admins.index'));
    $trail->push(__('messages.view_form_title', ['form' => __('messages.admins')]), route('admins.show', $id));
}); 

// Home > Slider
Breadcrumbs::for('sliders', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.slider'), route('sliders.index'));
});

// Home > Slider > Create
Breadcrumbs::for('create_slider', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.slider'), route('sliders.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.slider')]), route('sliders.create'));
});

// Home > Slider > Edit
Breadcrumbs::for('edit_slider', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.slider'), route('sliders.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.slider')]), route('sliders.edit', $id));
});

// Home > Booking
Breadcrumbs::for('bookings', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.booking'), route('booking.index'));
});

// Home > Booking > Create
Breadcrumbs::for('create_booking', function (BreadcrumbTrail $trail) {
    $trail->parent('home');
    $trail->push(__('messages.booking'), route('booking.index'));
    $trail->push(__('messages.add_button_form', ['form' => __('messages.booking')]), route('booking.create'));
});

// Home > Booking > Edit
Breadcrumbs::for('edit_booking', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.booking'), route('booking.index'));
    $trail->push(__('messages.update_form_title', ['form' => __('messages.booking')]), route('booking.edit', $id));
});

// Home > Booking > Show
Breadcrumbs::for('show_booking', function (BreadcrumbTrail $trail, $id) {
    $trail->parent('home');
    $trail->push(__('messages.booking'), route('booking.index'));
    $trail->push(__('messages.view_form_title', ['form' => __('messages.booking')]), route('booking.show', $id));
});