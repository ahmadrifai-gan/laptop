@extends('admin.layouts.app')

@section('title', 'Riwayat Prediksi')
@section('page-title', 'Riwayat Prediksi Sistem')

@section('content')
<div class="bg-white rounded-lg shadow p-6">
    <form method="GET" action="{{ route('admin.history') }}" class="flex flex-wrap items-end gap-4 mb-6">
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Rentang Tanggal</label>
            <div class="flex items-center gap-2">
                <input type="date" name="start_date" value="{{ request('start_date') }}" class="border border-gray-300 rounded-md px-3 py-2 text-sm">
                <span class="text-gray-500">s/d</span>
                <input type="date" name="end_date" value="{{ request('end_date') }}" class="border border-gray-300 rounded-md px-3 py-2 text-sm">
            </div>
        </div>
        <div>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-md text-sm">Filter</button>
            <a href="{{ route('admin.history') }}" class="ml-2 bg-gray-200 text-gray-700 px-4 py-2 rounded-md text-sm">Reset</a>
        </div>
    </form>

    <div class="flex items-center gap-6 text-sm text-gray-600 mb-4 border-b pb-4">
        <div>Total Prediksi: <span class="font-semibold">{{ $totalPredictions }}</span></div>
        <span class="w-px h-5 bg-gray-300"></span>
        <div>Menampilkan {{ $predictions->firstItem() ?? 0 }} - {{ $predictions->lastItem() ?? 0 }} dari {{ $predictions->total() }}</div>
    </div>

    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 text-sm">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-4 py-3 text-left">Tanggal</th>
                    <th class="px-4 py-3 text-left">Spesifikasi</th>
                    <th class="px-4 py-3 text-left">Harga Prediksi</th>
                    <th class="px-4 py-3 text-left">Kategori</th>
                    <th class="px-4 py-3 text-left">Status</th>
                </tr>
            </thead>
            <tbody>
                @forelse($predictions as $pred)
                <tr>
                    <td class="px-4 py-3">{{ $pred->created_at->locale('id')->isoFormat('D MMM YYYY HH:mm') }} WIB</td>
                    <td class="px-4 py-3">
                        @php
                            $s = $pred->input_data ?? [];
                            $display = ($s['TypeName'] ?? '').' '.($s['Cpu'] ?? '').', '.($s['Ram'] ?? 0).'GB RAM, '.($s['Memory'] ?? 0).'GB SSD';
                        @endphp
                        {{ Str::limit($display, 50) }}
                    </td>
                    <td class="px-4 py-3 font-medium">Rp {{ number_format($pred->predicted_price ?? 0, 0, ',', '.') }}</td>
                    <td class="px-4 py-3"><span class="bg-blue-100 text-blue-700 px-2 py-1 rounded-full text-xs">{{ $pred->category ?? '-' }}</span></td>
                    <td class="px-4 py-3"><span class="bg-green-100 text-green-700 px-2 py-1 rounded-full text-xs">{{ $pred->status }}</span></td>
                </tr>
                @empty
                <tr><td colspan="5" class="text-center py-6 text-gray-500">Belum ada riwayat prediksi.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
    <div class="mt-4">{{ $predictions->links() }}</div>
</div>
@endsection