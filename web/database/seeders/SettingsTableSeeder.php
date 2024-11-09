<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class SettingsTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        \DB::table('settings')->delete();
        
        \DB::table('settings')->insert(array (
            0 => 
            array (
                'id' => 1,
                'key' => 'ADMOB_APP_ID',
                'type' => 'ADMOB',
                'value' => NULL,
            ),
            1 => 
            array (
                'id' => 2,
                'key' => 'ADMOB_BANNER_ID',
                'type' => 'ADMOB',
                'value' => NULL,
            ),
            2 => 
            array (
                'id' => 3,
                'key' => 'ADMOB_INTERSTITIAL_ID',
                'type' => 'ADMOB',
                'value' => NULL,
            ),
            3 => 
            array (
                'id' => 4,
                'key' => 'COLOR_PRIMARY_COLOR',
                'type' => 'COLOR',
                'value' => '#000000',
            ),
            4 => 
            array (
                'id' => 5,
                'key' => 'COLOR_SECONDARY_COLOR',
                'type' => 'COLOR',
                'value' => '#000000',
            ),
            5 => 
            array (
                'id' => 6,
                'key' => 'CURRENCY_COUNTRY_ID',
                'type' => 'CURRENCY',
                'value' => '231',
            ),
            6 => 
            array (
                'id' => 7,
                'key' => 'CURRENCY_POSITION',
                'type' => 'CURRENCY',
                'value' => 'left',
            ),
            7 => 
            array (
                'id' => 8,
                'key' => 'ONESIGNAL_API_KEY',
                'type' => 'ONESIGNAL',
                'value' => NULL,
            ),
            8 => 
            array (
                'id' => 9,
                'key' => 'ONESIGNAL_REST_API_KEY',
                'type' => 'ONESIGNAL',
                'value' => NULL,
            ),
            9 => 
            array (
                'id' => 10,
                'key' => 'DISTANCE_TYPE',
                'type' => 'DISTANCE',
                'value' => 'km',
            ),
            10 => 
            array (
                'id' => 11,
                'key' => 'DISTANCE_RADIOUS',
                'type' => 'DISTANCE',
                'value' => '50',
            ),
            11 => 
            array (
                'id' => 12,
                'key' => 'dashboard_setting',
                'type' => 'dashboard_setting',
                'value' => '{"Top_Cards":"top_card","Monthly_Revenue_card":"monthly_revenue_card","Top_Services_card":"top_service_card","New_Provider_card":"new_provider_card","Upcoming_Booking_card":"upcoming_booking_card","New_Customer_card":"new_customer_card"}',
            ),
            12 => 
            array (
                'id' => 13,
                'key' => 'provider_dashboard_setting',
                'type' => 'provider_dashboard_setting',
                'value' => '{"Top_Cards":"top_card","Monthly_Revenue_card":"monthly_revenue_card","Top_Services_card":"top_service_card","New_Provider_card":"new_provider_card","Upcoming_Booking_card":"upcoming_booking_card","New_Customer_card":"new_customer_card"}',
            ),
            13 => 
            array (
                'id' => 14,
                'key' => 'handyman_dashboard_setting',
                'type' => 'handyman_dashboard_setting',
                'value' => '{"Top_Cards":"top_card","Schedule_Card":"schedule_card"}',
            ),
            14 => 
            array (
                'id' => 15,
                'key' => 'ONESIGNAL_APP_ID_PROVIDER',
                'type' => 'ONESIGNAL',
                'value' => NULL,
            ),
            15 => 
            array (
                'id' => 16,
                'key' => 'ONESIGNAL_REST_API_KEY_PROVIDER',
                'type' => 'ONESIGNAL',
                'value' => NULL,
            ),
            16 => 
            array (
                'id' => 17,
                'key' => 'GOOGLE_MAP_KEY',
                'type' => 'GOOGLE_MAP_KEY',
                'value' => NULL,
            ),
        ));
        
        
    }
}