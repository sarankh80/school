<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ChannelsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        \DB::table('channels')->delete();
        \DB::table('currencies')->delete();
        \DB::table('locales')->delete();

        \DB::table('currencies')->insert(array (
            0 => 
            array (
                'code' => 'USD',
                'name' => 'US Dollar',
                'symbol' => "$",
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33',
            )
        ));


        \DB::table('locales')->insert(array (
            0 => 
            array (
                'code' => 'en',
                'name' => 'English',
                'direction' => "ltr",
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33',
            )
        ));
        
        \DB::table('channels')->insert(array (
            0 => 
            array (
                'code' => 'Default',
                'theme' => 'velocity',
                'hostname' => url('/'),
                'default_locale_id' => 1,
                'base_currency_id' => 1,
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33'
            )
        ));

        \DB::table('channel_translations')->insert(array (
            0 => 
            array (
                'channel_id' => 1,
                'locale'    => 'en',
                'name' => 'Default',
                'description' => 'Default',
                'home_page_content' => "Default",
                'footer_content' => "Default",
                'home_seo' => '{
                    "meta_title": "Demo store",
                    "meta_keywords": "Demo store meta keyword",
                    "meta_description": "Demo store meta description"
                }',
                'created_at' => '2023-01-23 09:05:27',
                'updated_at' => '2023-01-23 09:16:33'
            )
        ));
    }
}
