@extends('admin.layouts.app')
@section('title', 'Edit Laptop')
@section('page-title', 'Edit Laptop')

@section('content')
<div class="max-w-3xl">
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
            <h2 class="font-semibold text-gray-800">Edit: {{ $laptop->company_name }} {{ $laptop->Product }}</h2>
            <a href="{{ route('admin.laptops.index') }}" class="text-sm text-gray-500 hover:text-gray-700">
                <i class="fas fa-arrow-left mr-1"></i> Kembali
            </a>
        </div>
        <form method="POST" action="{{ route('admin.laptops.update', $laptop) }}" class="p-6">
            @csrf @method('PUT')
            @include('admin.laptops._form')
            <div class="flex gap-3 mt-6 pt-6 border-t border-gray-100">
                <button type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-lg transition-colors">
                    <i class="fas fa-save mr-1"></i> Perbarui
                </button>
                <a href="{{ route('admin.laptops.index') }}" class="px-6 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm font-medium rounded-lg transition-colors">
                    Batal
                </a>
            </div>
        </form>
    </div>
</div>
@endsection
