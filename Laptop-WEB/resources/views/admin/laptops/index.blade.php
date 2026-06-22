@extends('admin.layouts.app')
@section('title', 'Data Laptop')
@section('page-title', 'Data Laptop')

@section('content')
<!-- Header Actions -->
<div class="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between mb-6">
    <div>
        <p class="text-sm text-gray-500">Total: <span class="font-semibold text-gray-700">{{ $laptops->total() }}</span> laptop</p>
    </div>
    <a href="{{ route('admin.laptops.create') }}"
       class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium px-4 py-2.5 rounded-lg transition-colors shadow-sm">
        <i class="fas fa-plus text-xs"></i> Tambah Laptop
    </a>
</div>

<!-- Filters -->
<div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-6">
    <form method="GET" class="flex flex-wrap gap-3 items-end">
        <div class="flex-1 min-w-[200px]">
            <label class="text-xs font-medium text-gray-600 mb-1 block">Cari Produk</label>
            <div class="relative">
                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"><i class="fas fa-search"></i></span>
                <input type="text" name="search" value="{{ request('search') }}"
                       class="w-full pl-8 pr-3 py-2 text-sm border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                       placeholder="Nama produk...">
            </div>
        </div>
        <div>
            <label class="text-xs font-medium text-gray-600 mb-1 block">Brand</label>
            <select name="company" class="px-3 py-2 text-sm border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                <option value="">Semua Brand</option>
                @foreach(\App\Models\Laptop::COMPANY_MAP as $key => $name)
                <option value="{{ $name }}" {{ request('company') == $name ? 'selected' : '' }}>{{ $name }}</option>
                @endforeach
            </select>
        </div>
        <div>
            <label class="text-xs font-medium text-gray-600 mb-1 block">Kategori</label>
            <select name="kategori" class="px-3 py-2 text-sm border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                <option value="">Semua</option>
                <option value="Gaming" {{ request('kategori') == 'Gaming' ? 'selected' : '' }}>Gaming</option>
                <option value="Programming" {{ request('kategori') == 'Programming' ? 'selected' : '' }}>Programming</option>
                <option value="Office" {{ request('kategori') == 'Office' ? 'selected' : '' }}>Office</option>
            </select>
        </div>
        <button type="submit" class="px-4 py-2 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition-colors">Filter</button>
        @if(request()->hasAny(['search', 'kategori', 'company']))
        <a href="{{ route('admin.laptops.index') }}" class="px-4 py-2 bg-gray-100 text-gray-600 text-sm rounded-lg hover:bg-gray-200 transition-colors">Reset</a>
        @endif
    </form>
</div>

<!-- Table -->
<div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-sm">
            <thead class="bg-gray-50 border-b border-gray-100">
                <tr class="text-xs text-gray-500 font-medium">
                    <th class="text-left px-4 py-3">#</th>
                    <th class="text-left px-4 py-3">Brand</th>
                    <th class="text-left px-4 py-3">Produk</th>
                    <th class="text-left px-4 py-3">Tipe</th>
                    <th class="text-left px-4 py-3">CPU / RAM / Storage</th>
                    <th class="text-left px-4 py-3">GPU</th>
                    <th class="text-left px-4 py-3">Kategori</th>
                    <th class="text-right px-4 py-3">Harga</th>
                    <th class="text-center px-4 py-3">Aksi</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-50">
                @forelse($laptops as $laptop)
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-4 py-3 text-gray-400 text-xs">{{ $loop->iteration + ($laptops->currentPage() - 1) * $laptops->perPage() }}</td>
                    <td class="px-4 py-3">
                        <p class="font-semibold text-gray-800">{{ $laptop->company_name }}</p>
                    </td>
                    <td class="px-4 py-3">
                        <p class="text-gray-700">{{ $laptop->Product }}</p>
                    </td>
                    <td class="px-4 py-3">
                        <span class="text-xs text-gray-500">{{ $laptop->type_name_label }}</span>
                    </td>
                    <td class="px-4 py-3">
                        <div class="space-y-0.5">
                            <p class="text-gray-600 text-xs"><i class="fas fa-microchip text-gray-300 mr-1"></i>{{ $laptop->cpu_label }}</p>
                            <p class="text-gray-600 text-xs"><i class="fas fa-memory text-gray-300 mr-1"></i>{{ $laptop->ram_label }} RAM &middot; {{ $laptop->memory_label }}</p>
                        </div>
                    </td>
                    <td class="px-4 py-3">
                        <span class="text-xs text-gray-600">{{ $laptop->gpu_label }}</span>
                    </td>
                    <td class="px-4 py-3">
                        @php $colors = ['Gaming' => 'red', 'Programming' => 'teal', 'Office' => 'yellow']; $c = $colors[$laptop->Kategori] ?? 'gray'; @endphp
                        <span class="px-2.5 py-1 rounded-full text-xs font-medium bg-{{ $c }}-100 text-{{ $c }}-700">
                            {{ $laptop->Kategori ?? '-' }}
                        </span>
                    </td>
                    <td class="px-4 py-3 text-right font-semibold text-gray-800">{{ $laptop->price_formatted }}</td>
                    <td class="px-4 py-3">
                        <div class="flex items-center justify-center gap-2">
                            <a href="{{ route('admin.laptops.edit', $laptop) }}"
                               class="w-7 h-7 flex items-center justify-center bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors text-xs"
                               title="Edit">
                                <i class="fas fa-edit"></i>
                            </a>
                            <form method="POST" action="{{ route('admin.laptops.destroy', $laptop) }}"
                                  onsubmit="return confirm('Hapus laptop ini?')">
                                @csrf @method('DELETE')
                                <button type="submit"
                                        class="w-7 h-7 flex items-center justify-center bg-red-50 text-red-500 rounded-lg hover:bg-red-100 transition-colors text-xs"
                                        title="Hapus">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="9" class="px-5 py-12 text-center">
                        <i class="fas fa-laptop text-gray-200 text-4xl mb-3 block"></i>
                        <p class="text-gray-400 text-sm">Belum ada data laptop.</p>
                        <a href="{{ route('admin.laptops.create') }}" class="mt-2 inline-block text-blue-600 text-sm hover:underline">Tambah sekarang</a>
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    @if($laptops->hasPages())
    <div class="px-5 py-4 border-t border-gray-100">
        {{ $laptops->links() }}
    </div>
    @endif
</div>
@endsection
