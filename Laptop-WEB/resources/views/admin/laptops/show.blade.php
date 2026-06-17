@extends('admin.layouts.app')
@section('title', 'Detail Laptop')
@section('page-title', 'Detail Laptop')

@section('content')
<div class="max-w-2xl">
    <!-- Back + Action Buttons -->
    <div class="flex items-center justify-between mb-6">
        <a href="{{ route('admin.laptops.index') }}"
           class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 transition-colors">
            <i class="fas fa-arrow-left text-xs"></i> Kembali ke Daftar
        </a>
        <div class="flex items-center gap-2">
            <a href="{{ route('admin.laptops.edit', $laptop) }}"
               class="inline-flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-lg transition-colors">
                <i class="fas fa-edit text-xs"></i> Edit
            </a>
        </div>
    </div>

    <!-- Header Card -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden mb-4">
        <div class="p-6 border-b border-gray-100">
            <div class="flex items-start justify-between gap-4">
                <div>
                    <p class="text-xs font-medium text-gray-400 uppercase tracking-wide mb-1">{{ $laptop->company_name }}</p>
                    <h1 class="text-xl font-bold text-gray-800">{{ $laptop->Product }}</h1>
                    <p class="text-sm text-gray-500 mt-1">{{ $laptop->type_name_label }} &middot; {{ $laptop->Inches }}"</p>
                </div>
                <div class="text-right flex-shrink-0">
                    <p class="text-2xl font-bold text-gray-800">{{ $laptop->price_formatted }}</p>
                    @php $colors = ['Gaming' => 'red', 'Programming' => 'teal', 'Office' => 'yellow']; $c = $colors[$laptop->Kategori] ?? 'gray'; @endphp
                    <span class="inline-block mt-1 px-3 py-1 rounded-full text-xs font-medium bg-{{ $c }}-100 text-{{ $c }}-700">
                        {{ $laptop->Kategori }}
                    </span>
                </div>
            </div>
        </div>

        <!-- Specs Grid -->
        <div class="p-6">
            <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">Spesifikasi</h2>
            <div class="grid grid-cols-2 gap-4">
                <!-- CPU -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-microchip text-blue-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">Prosesor</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->cpu_label }}</p>
                    </div>
                </div>

                <!-- RAM -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-purple-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-memory text-purple-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">RAM</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->ram_label }}</p>
                    </div>
                </div>

                <!-- Storage -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-green-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-hdd text-green-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">Storage</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->memory_label }}</p>
                    </div>
                </div>

                <!-- GPU -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-orange-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-tv text-orange-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">GPU</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->gpu_label }}</p>
                    </div>
                </div>

                <!-- Screen -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-teal-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-desktop text-teal-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">Layar</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->Inches }}" {{ $laptop->ScreenResolution ? '· ' . $laptop->ScreenResolution : '' }}</p>
                    </div>
                </div>

                <!-- OS -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-laptop-code text-gray-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">Sistem Operasi</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->OpSys ?? '-' }}</p>
                    </div>
                </div>

                <!-- Weight -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-yellow-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-weight text-yellow-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">Berat</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->weight_label }}</p>
                    </div>
                </div>

                <!-- Laptop ID -->
                <div class="flex items-start gap-3">
                    <div class="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-hashtag text-gray-500 text-xs"></i>
                    </div>
                    <div>
                        <p class="text-xs text-gray-400">Laptop ID</p>
                        <p class="text-sm font-medium text-gray-700">{{ $laptop->laptop_ID }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete -->
    <div class="bg-white rounded-xl shadow-sm border border-red-100 p-5">
        <h3 class="text-sm font-semibold text-red-600 mb-1">Zona Berbahaya</h3>
        <p class="text-xs text-gray-500 mb-4">Menghapus laptop ini akan menghapus data secara permanen dan tidak dapat dikembalikan.</p>
        <form method="POST" action="{{ route('admin.laptops.destroy', $laptop) }}"
              onsubmit="return confirm('Hapus laptop {{ $laptop->company_name }} {{ $laptop->Product }}? Tindakan ini tidak dapat dibatalkan.')">
            @csrf @method('DELETE')
            <button type="submit"
                    class="inline-flex items-center gap-2 px-4 py-2 bg-red-600 hover:bg-red-700 text-white text-sm font-medium rounded-lg transition-colors">
                <i class="fas fa-trash text-xs"></i> Hapus Laptop
            </button>
        </form>
    </div>
</div>
@endsection
