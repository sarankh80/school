<?php

return [
    'simple'       => [
        'key'   => 'simple',
        'name'  => 'Simple',
        'class' => 'App\Type\Simple',
        'sort'  => 1,
    ],

    'configurable' => [
        'key'   => 'configurable',
        'name'  => 'Configurable',
        'class' => 'App\Type\Configurable',
        'sort'  => 2,
    ],

    'virtual'      => [
        'key'   => 'virtual',
        'name'  => 'Virtual',
        'class' => 'App\Type\Virtual',
        'sort'  => 3,
    ],

    'grouped'      => [
        'key'   => 'grouped',
        'name'  => 'Grouped',
        'class' => 'App\Type\Grouped',
        'sort'  => 4,
    ],

    'downloadable' => [
        'key'   => 'downloadable',
        'name'  => 'Downloadable',
        'class' => 'App\Type\Downloadable',
        'sort'  => 5,
    ],
    
    'bundle'       => [
        'key'  => 'bundle',
        'name'  => 'Bundle',
        'class' => 'App\Type\Bundle',
        'sort'  => 6,
    ]
];