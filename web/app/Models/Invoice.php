<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    use HasFactory;

        /**
     * The attributes that aren't mass assignable.
     *
     * @var string[]
     */
    protected $guarded = [
        'id',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'customer_id'   => 'integer',
        'provider_id'   => 'integer',
        'booking_id'   => 'integer',
        'created_at' => 'datetime:Y-m-d H:i:s',
    ];

    /**
     * Invoice status.
     *
     * @var array
     */
    protected $statusLabel = [
        'pending'  => 'Pending',
        'paid'     => 'Paid',
        'refunded' => 'Refunded',
    ];

    /**
     * Returns the status label from status code.
     */
    public function getStatusLabelAttribute()
    {
        return $this->statusLabel[$this->state] ?? '';
    }

    /**
     * Get the order that belongs to the invoice.
     */
    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

    /**
     * Get the invoice items record associated with the invoice.
     */
    public function items()
    {
        return $this->hasMany(InvoiceItem::class);
    }

    /**
     * Get the order that belongs to the customer.
     */
    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }

    /**
     * Get the order that belongs to the provider.
     */
    public function provider()
    {
        return $this->belongsTo(Provider::class);
    }

    /**
     * Get the address for the invoice.
     */
    public function address()
    {
        return $this->belongsTo(Address::class, 'address_id');
    }
}
