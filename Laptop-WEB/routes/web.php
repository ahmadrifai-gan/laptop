<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\LaptopController;
use Illuminate\Support\Facades\Route;

Route::get("/", fn() => redirect()->route("admin.login"));

// Admin Auth
Route::prefix("admin")
    ->name("admin.")
    ->group(function () {
        Route::get("/login", [AuthController::class, "showLogin"])->name(
            "login",
        );
        Route::post("/login", [AuthController::class, "login"])->name(
            "login.post",
        );
        Route::post("/logout", [AuthController::class, "logout"])->name(
            "logout",
        );

        // Protected
        Route::middleware("admin.auth")->group(function () {
            Route::get("/dashboard", [
                DashboardController::class,
                "index",
            ])->name("dashboard");
            Route::resource("laptops", LaptopController::class);
        });
    });
