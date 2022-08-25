<?php
namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller as Controller;
use Illuminate\Support\Facades\DB;

class DBController extends Controller
{
    public function writeTable(Request $request)
    {
        $path = $request->input('path');
        $data = $request->input('data');

        $values = array('path' => $path, 'data' => $data);

        $present = DB::table('data')->where('path', '=', "$path")->get()->first();
        if ($present == null) {
            DB::table('data')->insert($values);
        }else{
            DB::table('data')->update($values);
        }

        $response = [
            'error' => '0',
        ];
        return response()->json($response, 200);
    }

    public function readTable(Request $request)
    {
        $path = $request->input('path');

        $data = "";
        $present = DB::table('data')->where('path', '=', "$path")->get()->first();
        if ($present != null)
            $data = $present->data;

        $response = [
            'error' => '0',
            'data' => $data,
            'path' => $path,
        ];
        return response()->json($response, 200);
    }
}
