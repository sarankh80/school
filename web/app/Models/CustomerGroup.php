<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class CustomerGroup extends Model
{
    use HasFactory;

    protected $table = 'customer_groups';

    protected $fillable = [
        'name',
        'code',
        'is_user_defined',
    ];

    /**
     * Get the customers for this group.
     */
    public function customers()
    {
        return $this->hasMany(Customer::class);
    }
}
