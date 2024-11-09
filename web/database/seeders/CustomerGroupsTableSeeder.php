<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CustomerGroupsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        \DB::table('customer_groups')->delete();

        \DB::table('customer_groups')->insert(array (
            0 => 
            array (
                'name' => 'Guest',
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33',
            ),
            1 => 
            array (
                'name' => 'General',
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33',
            ),
            2 => 
            array (
                'name' => 'Wholesale',
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33',
            )
        ));
    }
}
