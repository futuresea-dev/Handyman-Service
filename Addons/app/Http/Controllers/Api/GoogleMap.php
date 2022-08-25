<?php
namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller as Controller;

class GoogleMap extends Controller
{
    public function searchNearbyWithRadius(Request $request)
    {

        $lat = $request->input('lat');
        $lng = $request->input('lng');
        $key = $request->input('key');

        $path_to = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

        $path = $path_to."?location={$lat}%2C{$lng}&radius=20&key={$key}";

        $curl_session = curl_init();
        curl_setopt($curl_session, CURLOPT_URL, $path);
        curl_setopt($curl_session, CURLOPT_POST, false);
        curl_setopt($curl_session, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl_session, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl_session, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);
        $result = curl_exec($curl_session);

        $json = json_decode($result, true);
        curl_close($curl_session);

        return response()->json($json, 200);
    }

}
