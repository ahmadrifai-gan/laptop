@extends('admin.layouts.app')


@section('title', 'Manajemen Admin')
@section('page-title', 'Manajemen Admin')

@section('content')
<div class="bg-white rounded-lg shadow p-6">
    <div class="flex justify-between items-center mb-4">
        <h3 class="text-lg font-semibold">Daftar Admin</h3>
        <span class="text-sm text-gray-500">Total: {{ $admins->count() }}</span>
    </div>

    @if(session('success'))
    <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded mb-4">
        {{ session('success') }}
    </div>
    @endif

    @if(session('error'))
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-4">
        {{ session('error') }}
    </div>
    @endif

    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nama</th>
                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Dibuat</th>
                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Aksi</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
                @forelse($admins as $admin)
                <tr>
                    <td class="px-4 py-3">{{ $admin->name }}</td>
                    <td class="px-4 py-3">{{ $admin->email }}</td>
                    <td class="px-4 py-3">{{ $admin->created_at->format('d M Y') }}</td>
                    <td class="px-4 py-3">
                        <form action="{{ route('admin.admins.destroy', $admin->id) }}" method="POST" class="inline-block" onsubmit="return confirm('Yakin ingin menghapus admin ini?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-600 hover:text-red-800">
                                <i class="fas fa-trash"></i> Hapus
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="4" class="text-center py-6 text-gray-500">Tidak ada admin lain.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection