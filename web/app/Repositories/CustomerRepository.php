<?php

namespace App\Repositories;

use Illuminate\Container\Container;
use Illuminate\Support\Facades\Storage;
use App\Eloquent\Repository;
use App\Repositories\CustomerGroupRepository;
use App\Models\Booking;
use App\Models\Customer;

class CustomerRepository extends Repository
{
    /**
     * Create a new repository instance.
     *
     * @param  App\Repositories\CustomerGroupRepository  $customerGroupRepository
     * @param  \Illuminate\Container\Container  $container
     * @return void
     */
    public function __construct(
        protected CustomerGroupRepository $customerGroupRepository,
        Container $container
    )
    {
        parent::__construct($container);
    }

    /**
     * Specify model class name.
     *
     * @return string
     */
    public function model(): string
    {
        return Customer::class;
    }
     
    /**
     * Save a new entity in repository
     *
     * @param array $attributes
     *
     * @return mixed
     *
     */
    public function create($request)
    {
        $attributes = $request->all();
        $attributes['display_name'] = $attributes['first_name'] . ' ' . $attributes['last_name'];
        $attributes['customer_group_id'] = $this->customerGroupRepository->findOneWhere(['name' => 'general'])->id;
        $attributes['user_type'] = "user";

        $current_customer = $this->model->phoneNotVerified()->where('phone_number', $attributes['phone_number'])->first();
        if(!empty($current_customer))
        {
            $current_customer->fill($attributes);
            $current_customer->save();

            $customer = $this->model->find($current_customer->id);
        }else{
            $customer = $this->model->create($attributes);
            $customer->assignRole('user');
        }


        if ($request->hasFile('profile_image')) {
            storeMediaFile($customer, $attributes['profile_image'], 'profile_image');
        }

        return $customer;
    }

    /**
     * Check if customer has order pending or processing.
     *
     * @param  \Webkul\Customer\Models\Customer
     * @return boolean
     */
    public function checkIfCustomerHasOrderPendingOrProcessing($customer)
    {
        return $customer->all_orders->pluck('status')->contains(function ($val) {
            return $val === 'pending' || $val === 'processing';
        });
    }

    /**
     * Returns current customer group
     *
     * @return \Webkul\Customer\Models\CustomerGroup
     */
    public function getCurrentGroup()
    {
        if ($customer = auth()->guard('sanctum')->user()) {
            return $customer->group;
        }
        
        return $this->customerGroupRepository->getCustomerGuestGroup();
    }

    /**
     * Check if bulk customers, if they have order pending or processing.
     *
     * @param  array
     * @return boolean
     */
    public function checkBulkCustomerIfTheyHaveOrderPendingOrProcessing($customerIds)
    {
        foreach ($customerIds as $customerId) {
            $customer = $this->findOrFail($customerId);

            if ($this->checkIfCustomerHasOrderPendingOrProcessing($customer)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Upload customer's images.
     *
     * @param  array  $data
     * @param  \Webkul\Customer\Models\Customer  $customer
     * @param  string $type
     * @return void
     */
    public function uploadImages($data, $customer, $type = 'image')
    {
        if (isset($data[$type])) {
            $request = request();

            foreach ($data[$type] as $imageId => $image) {
                $file = $type . '.' . $imageId;
                $dir = 'customer/' . $customer->id;

                if ($request->hasFile($file)) {
                    if ($customer->{$type}) {
                        Storage::delete($customer->{$type});
                    }

                    $customer->{$type} = $request->file($file)->store($dir);
                    $customer->save();
                }
            }
        } else {
            if ($customer->{$type}) {
                Storage::delete($customer->{$type});
            }

            $customer->{$type} = null;
            $customer->save();
        }
    }

    /**
     * Sync new registered customer data.
     *
     * @param  \Webkul\Customer\Contracts\Customer  $customer
     * @return mixed
     */
    public function syncNewRegisteredCustomerInformation($customer)
    {
        /**
         * Setting registered customer to orders.
         */
        Booking::where('customer_email', $customer->email)->update([
            'is_guest'      => 0,
            'customer_id'   => $customer->id,
            'customer_type' => \Webkul\Customer\Models\Customer::class,
        ]);

        /**
         * Grabbing orders by `customer_id`.
         */
        $orders = Booking::where('customer_id', $customer->id)->get();

        /**
         * Setting registered customer to associated order's relations.
         */
        $orders->each(function ($order) use ($customer) {
            $order->addresses()->update([
                'customer_id' => $customer->id,
            ]);

            $order->shipments()->update([
                'customer_id'   => $customer->id,
                'customer_type' => \Webkul\Customer\Models\Customer::class,
            ]);

            $order->downloadable_link_purchased()->update([
                'customer_id' => $customer->id,
            ]);
        });
    }
}
