<?php

namespace App\Models;

use Parental\HasParent;

class Handyman extends User
{
    use HasParent;

    protected $guard_name = 'web';
}
