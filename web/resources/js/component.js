import Vue from 'vue';
import 'livewire-vue';
import VeeValidate from 'vee-validate';
import Draggable from 'vuedraggable';
import { Multiselect } from 'vue-multiselect';
import Accordian from './components/Backend/accordian';
import DatagridPlus from './components/Backend/datagrid/datagrid-plus';
import DateComponent from './components/Backend/date';
import DatetimeComponent from './components/Backend/datetime';
import Flash from './components/Backend/flash';
import FlashWrapper from './components/Backend/flash-wrapper';
import ImageItem from './components/Backend/image/image-item';
import ImageUpload from './components/Backend/image/image-upload';
import ImageWrapper from './components/Backend/image/image-wrapper';
import Modal from './components/Backend/modal';
import OverlayLoader from './components/Backend/overlay-loader';
import SwatchPicker from './components/Backend/swatch-picker';
import DefaultImage from './components/Backend/default-image';
import Tab from './components/Backend/tabs/tab';
import Tabs from './components/Backend/tabs/tabs';
import TimeComponent from './components/Backend/time';
import TreeCheckbox from './components/Backend/tree-view/tree-checkbox';
import TreeItem from './components/Backend/tree-view/tree-item';
import TreeRadio from './components/Backend/tree-view/tree-radio';
import TreeView from './components/Backend/tree-view/tree-view';
import CartRuleConditionItem from './components/Backend/cart-rule-condition-item';
import CouponType from './components/Backend/coupon-type';
import Condition from './components/Backend/condition';

/**
 * Vue prototype.
 */
Vue.prototype.$http = axios;

Vue.use(VeeValidate);

/**
 * Window assignation.
 */
window.Vue = Vue;
window.eventBus = new Vue();

/**
 * Components.
 */
Vue.component('datagrid-plus', DatagridPlus);
Vue.component('flash-wrapper', FlashWrapper);
Vue.component('flash', Flash);
Vue.component('tabs', Tabs);
Vue.component('tab', Tab);
Vue.component('tree-view', TreeView);
Vue.component('tree-item', TreeItem);
Vue.component('tree-checkbox', TreeCheckbox);
Vue.component('tree-radio', TreeRadio);
Vue.component('accordian', Accordian);
Vue.component('modal', Modal);
Vue.component('image-upload', ImageUpload);
Vue.component('image-wrapper', ImageWrapper);
Vue.component('image-item', ImageItem);
Vue.component('datetime', DatetimeComponent);
Vue.component('date', DateComponent);
Vue.component('time-component', TimeComponent);
Vue.component('swatch-picker', SwatchPicker);
Vue.component('overlay-loader', OverlayLoader);
Vue.component('multiselect', Multiselect);
Vue.component('default-image', DefaultImage);
Vue.component('draggable', Draggable);
Vue.component('cart-rule-condition-item', CartRuleConditionItem);
Vue.component('coupon-type', CouponType);
Vue.component('condition', Condition);

const app = new Vue({
    el: '#app'
});

/**
 * Require.
 */
require('flatpickr/dist/flatpickr.css');
require('vue-swatches/dist/vue-swatches.css');
require('vue-multiselect/dist/vue-multiselect.min.css');
require('@babel/polyfill');
require('url-search-params-polyfill');
require('url-polyfill');