<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Laptop;

class DashboardController extends Controller
{
    public function index()
    {
        $stats = [
            "total" => Laptop::count(),
            "gaming" => Laptop::where("Kategori", "Gaming")->count(),
            "programming" => Laptop::where("Kategori", "Programming")->count(),
            "office" => Laptop::where("Kategori", "Office")->count(),
        ];

        $recentLaptops = Laptop::orderBy("laptop_ID", "desc")->take(5)->get();

        return view("admin.dashboard", compact("stats", "recentLaptops"));
    }
}
