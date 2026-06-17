@extends('admin.layouts.app')
@section('title', 'Dashboard')
@section('page-title', 'Dashboard')

@section('content')
<!-- Stats Grid -->
<div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
    <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-laptop text-blue-600"></i>
            </div>
            <span class="text-xs font-medium text-blue-600 bg-blue-50 px-2 py-0.5 rounded-full">Total</span>
        </div>
        <p class="text-2xl font-bold text-gray-800">{{ $stats['total'] }}</p>
        <p class="text-xs text-gray-500 mt-0.5">Total Laptop</p>
    </div>
    <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 bg-red-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-gamepad text-red-500"></i>
            </div>
        </div>
        <p class="text-2xl font-bold text-gray-800">{{ $stats['gaming'] }}</p>
        <p class="text-xs text-gray-500 mt-0.5">Gaming</p>
    </div>
    <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 bg-teal-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-code text-teal-500"></i>
            </div>
        </div>
        <p class="text-2xl font-bold text-gray-800">{{ $stats['programming'] }}</p>
        <p class="text-xs text-gray-500 mt-0.5">Programming</p>
    </div>
    <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-briefcase text-yellow-500"></i>
            </div>
        </div>
        <p class="text-2xl font-bold text-gray-800">{{ $stats['office'] }}</p>
        <p class="text-xs text-gray-500 mt-0.5">Office</p>
    </div>
</div>

<!-- Quick Actions + Recent Laptops -->
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Quick Actions -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <h2 class="font-semibold text-gray-800 mb-4">Aksi Cepat</h2>
        <div class="space-y-3">
            <a href="{{ route('admin.laptops.create') }}"
               class="flex items-center gap-3 p-3 bg-blue-50 hover:bg-blue-100 rounded-lg transition-colors">
                <div class="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                    <i class="fas fa-plus text-white text-xs"></i>
                </div>
                <span class="text-sm font-medium text-blue-700">Tambah Laptop Baru</span>
            </a>
            <a href="{{ route('admin.laptops.index') }}"
               class="flex items-center gap-3 p-3 bg-gray-50 hover:bg-gray-100 rounded-lg transition-colors">
                <div class="w-8 h-8 bg-gray-600 rounded-lg flex items-center justify-center">
                    <i class="fas fa-list text-white text-xs"></i>
                </div>
                <span class="text-sm font-medium text-gray-700">Kelola Semua Laptop</span>
            </a>
        </div>

        <!-- Model Info -->
        <div class="mt-6 pt-6 border-t border-gray-100">
            <h3 class="font-medium text-gray-700 text-sm mb-3">Info Model ML</h3>
            <div class="space-y-2">
                <div class="flex justify-between text-xs">
                    <span class="text-gray-500">Algoritma</span>
                    <span class="font-medium text-gray-700">K-Nearest Neighbors</span>
                </div>
                <div class="flex justify-between text-xs">
                    <span class="text-gray-500">Akurasi</span>
                    <span class="font-medium text-green-600">96.93%</span>
                </div>
                <div class="flex justify-between text-xs">
                    <span class="text-gray-500">K Value</span>
                    <span class="font-medium text-gray-700">3</span>
                </div>
                <div class="flex justify-between text-xs">
                    <span class="text-gray-500">Dataset</span>
                    <span class="font-medium text-gray-700">1303 laptops</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Laptops -->
    <div class="lg:col-span-2 bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <div class="flex items-center justify-between mb-4">
            <h2 class="font-semibold text-gray-800">Laptop Terbaru</h2>
            <a href="{{ route('admin.laptops.index') }}" class="text-xs text-blue-600 hover:underline">Lihat semua</a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-sm">
                <thead>
                    <tr class="text-xs text-gray-500 border-b border-gray-100">
                        <th class="text-left pb-2 font-medium">Laptop</th>
                        <th class="text-left pb-2 font-medium">Kategori</th>
                        <th class="text-right pb-2 font-medium">Harga</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                    @forelse($recentLaptops as $laptop)
                    <tr class="hover:bg-gray-50">
                        <td class="py-2.5">
                            <p class="font-medium text-gray-800">{{ $laptop->company_name }} {{ $laptop->Product }}</p>
                            <p class="text-xs text-gray-400">{{ $laptop->cpu_label }}</p>
                        </td>
                        <td class="py-2.5">
                            @php
                                $colors = ['Gaming' => 'red', 'Programming' => 'teal', 'Office' => 'yellow'];
                                $c = $colors[$laptop->Kategori] ?? 'gray';
                            @endphp
                            <span class="px-2 py-0.5 rounded-full text-xs font-medium bg-{{ $c }}-100 text-{{ $c }}-700">
                                {{ $laptop->Kategori }}
                            </span>
                        </td>
                        <td class="py-2.5 text-right font-medium text-gray-700">{{ $laptop->price_formatted }}</td>
                    </tr>
                    @empty
                    <tr><td colspan="3" class="py-8 text-center text-gray-400 text-sm">Belum ada data laptop</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
