<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Contracts\ChannelTranslation as ChannelTranslationContract;

class ChannelTranslation extends Model implements ChannelTranslationContract
{
    protected $guarded = [];
}