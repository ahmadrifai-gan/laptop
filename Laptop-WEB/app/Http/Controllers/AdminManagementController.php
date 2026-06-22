<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminManagementController extends Controller
{
    /**
     * Daftar semua admin (kecuali diri sendiri)
     */
    public function index()
    {
        $admins = Admin::where('_id', '!=', Auth::guard('admin')->id())->get();
        return view('admin.admins.index', compact('admins'));
    }

    /**
     * Hapus admin (tidak bisa hapus diri sendiri)
     */
    public function destroy($id)
    {
        $admin = Admin::find($id);

        if (!$admin) {
            return back()->with('error', 'Admin tidak ditemukan.');
        }

        // Cegah hapus diri sendiri
        if ($admin->id == Auth::guard('admin')->id()) {
            return back()->with('error', 'Anda tidak bisa menghapus akun sendiri.');
        }

        $admin->delete();

        return redirect()->route('admin.admins.index')
            ->with('success', 'Admin berhasil dihapus.');
    }
}
