<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\LaptopController;
use App\Http\Controllers\HistoryController; // <-- Tambahkan ini
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AdminManagementController;

Route::get("/", fn() => redirect()->route("admin.login"));

// Admin Auth
Route::prefix("admin")
    ->name("admin.")
    ->group(function () {
        Route::get("/login", [AuthController::class, "showLogin"])->name("login");
        Route::post("/login", [AuthController::class, "login"])->name("login.post");
        Route::post("/logout", [AuthController::class, "logout"])->name("logout");

        // Protected
        Route::middleware("admin.auth")->group(function () {
            Route::get("/dashboard", [DashboardController::class, "index"])->name("dashboard");
            Route::resource("laptops", LaptopController::class);

            // ===== TAMBAHKAN ROUTE HISTORY DI SINI =====
            Route::get("/history", [HistoryController::class, "index"])->name("history");
            Route::get('/admins', [App\Http\Controllers\AdminManagementController::class, 'index'])->name('admins.index');
            Route::delete('/admins/{id}', [App\Http\Controllers\AdminManagementController::class, 'destroy'])->name('admins.destroy');
        });
    });
