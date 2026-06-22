<?php

use App\Http\Controllers\PredictionController;
use App\Http\Controllers\Api\LaptopApiController;
use Illuminate\Support\Facades\Route;

// ML Prediction endpoints
Route::post('/predict', [PredictionController::class, 'predict'])->name('api.predict');
Route::post('/recommendations', [PredictionController::class, 'recommendations'])->name('api.recommendations');
Route::get('/categories', [PredictionController::class, 'categories'])->name('api.categories');

// Laptop data endpoints
Route::get('/laptops', [LaptopApiController::class, 'index'])->name('api.laptops.index');
Route::get('/laptops/{laptop}', [LaptopApiController::class, 'show'])->name('api.laptops.show');
Route::get('/laptops/kategori/{kategori}', [LaptopApiController::class, 'byKategori'])->name('api.laptops.by-kategori');
