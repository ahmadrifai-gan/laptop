<?php

namespace App\Http\Controllers;

use App\Models\Prediction;
use Illuminate\Http\Request;
use Carbon\Carbon;

class HistoryController extends Controller
{
    public function index(Request $request)
    {
        $query = Prediction::query();

        // Filter tanggal
        if ($request->filled('start_date')) {
            $start = Carbon::parse($request->start_date)->startOfDay();
            $query->where('created_at', '>=', $start);
        }
        if ($request->filled('end_date')) {
            $end = Carbon::parse($request->end_date)->endOfDay();
            $query->where('created_at', '<=', $end);
        }

        // Total data (untuk statistik)
        $totalPredictions = $query->count();

        // Ambil data dengan pagination (Eloquent otomatis)
        $predictions = $query->orderBy('created_at', 'desc')->paginate(10)->withQueryString();

        return view('admin.predict.history', compact('predictions', 'totalPredictions'));
    }
}
