<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\Booking;
use App\Models\Provider;
use Illuminate\Container\Container;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Log;

/** 
 * Class BookingRepository.
 *
 * @package namespace App\Repositories;
 */
class BookingRepository extends BaseRepository
{
    /**
     * Create a new repository instance.
     *
     * @param  \App\Repositories\BookingItemRepository  $orderItemRepository
     * @param  \Illuminate\Container\Container  $container
     * @return void
     */
    public function __construct(
        protected BookingItemRepository $bookingItemRepository,
        Container $container
    )
    {
        parent::__construct($container);
    }

    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return Booking::class;
    }
    
    /**
     * Transform the Booking model.
     * 
     * @return App\Presenters\BookingPresenter
     */
    public function presenter()
    {
        return "App\\Presenters\\BookingPresenter";
    }

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    { 
        $this->pushCriteria(app(RequestCriteria::class));
    }
    
    /**
     * Find player id in repository
     *
     * @param Booking $booking
     * @param
     *
     * @return mixed
     *
     */
    public function getPlayerIds($booking, $latitude, $longitude)
    {
        $booking_providers = $booking->providerByLocation($latitude, $longitude);

        return Provider::whereIn('id', $booking_providers)->whereNotNull('player_id')->get()->pluck('player_id');
    }

    /**
     * Save a new entity in repository
     *
     * @param array $attributes
     *
     * @return mixed
     * 
     */
    public function create(array $data)
    {
        DB::beginTransaction();
 
        try {
            $booking = $this->model->create($data);

            $booking_providers = $booking->providerByLocation($data['latitude'], $data['longitude']);

            $booking->requestProvider()->sync($booking_providers ?? []);
    
            foreach ($data['items'] as $item) {
                $bookingItem = $this->bookingItemRepository->create(array_merge($item, ['booking_id' => $booking->id]));
            }

            // Event::dispatch('checkout.order.save.after', $booking);
        } catch (\Exception $e) {
            /* rolling back first */
            DB::rollBack();

            /* storing log for errors */
            Log::error(
                'BookingRepository:create: ' . $e->getMessage(),
                ['data' => $data]
            );
        } finally {
            /* commit in each case */
            DB::commit();
        }

        return $booking;
    }


    /**
     * Update entity in repository
     *
     * @param array $attributes
     *
     * @return mixed
     * 
     */
    public function update(array $data, $booking_id)
    {
        DB::beginTransaction();
 
        try {
            $booking = $this->model->findOrFail($booking_id);
            
            $booking->fill($data);
            $booking->save();

            $this->bookingItemRepository->deleteWhere(['booking_id' => $booking_id]);

            foreach ($data['items'] as $item) {
                $bookingItem = $this->bookingItemRepository->create(array_merge($item, ['booking_id' => $booking_id]));
            }

        } catch (\Exception $e) {
            /* rolling back first */
            DB::rollBack();

            /* storing log for errors */
            Log::error(
                'BookingRepository:update: ' . $e->getMessage(),
                ['data' => $data]
            );
        } finally {
            /* commit in each case */
            DB::commit();
        }

        return $booking;
    }
}
