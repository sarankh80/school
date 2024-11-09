<?php

namespace App\Models;

use Parental\HasParent;

class Admin extends User
{
    use HasParent;

    protected $guard_name = 'web';
}
