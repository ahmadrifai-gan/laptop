@extends('layouts.admin')

@section('title', 'Prediksi Harga Baru')
@section('page-title', 'Prediksi Harga Baru')

@section('content')
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Form -->
    <div class="lg:col-span-2 bg-white rounded-lg shadow p-6">
        <p class="text-sm text-gray-500 mb-6">
            Masukkan spesifikasi lengkap untuk mendapatkan estimasi nilai pasar laptop berdasarkan algoritma prediksi machine learning terbaru.
        </p>

        <form id="predictionForm" action="{{ route('admin.predict.store') }}" method="POST">
            @csrf

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Brand Laptop -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Brand Laptop</label>
                    <select name="brand" id="brand" class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <option value="">Pilih Brand</option>
                        @foreach($brands ?? [] as $brand)
                            <option value="{{ $brand }}">{{ $brand }}</option>
                        @endforeach
                        <option value="Ultrabook">Ultrabook</option>
                    </select>
                    @error('brand')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>

                <!-- Ukuran Layar -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ukuran Layar (Inci)</label>
                    <input type="number" step="0.1" name="screen_size" id="screen_size" 
                           placeholder="cth. 14.0" 
                           class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    @error('screen_size')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>

                <!-- Resolusi -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Resolusi</label>
                    <input type="text" name="resolution" id="resolution" 
                           placeholder="cth. 1920×1080" 
                           class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                    @error('resolution')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>

                <!-- CPU Model -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">CPU Model</label>
                    <select name="cpu" id="cpu" class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <option value="">Pilih CPU</option>
                        @foreach($cpus ?? [] as $cpu)
                            <option value="{{ $cpu }}">{{ $cpu }}</option>
                        @endforeach
                        <option value="Intel Core i7">Intel Core i7</option>
                        <option value="Intel Core i5">Intel Core i5</option>
                        <option value="AMD Ryzen 7">AMD Ryzen 7</option>
                        <option value="AMD Ryzen 5">AMD Ryzen 5</option>
                    </select>
                    @error('cpu')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>

                <!-- RAM -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">RAM (GB)</label>
                    <input type="number" name="ram" id="ram" placeholder="8" min="1"
                           class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500" required>
                    @error('ram')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>

                <!-- Storage -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Storage (GB)</label>
                    <input type="number" name="storage" id="storage" placeholder="512" min="1"
                           class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500" required>
                    @error('storage')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>

                <!-- GPU Unit -->
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">GPU Unit</label>
                    <select name="gpu" id="gpu" class="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <option value="">Pilih GPU</option>
                        @foreach($gpus ?? [] as $gpu)
                            <option value="{{ $gpu }}">{{ $gpu }}</option>
                        @endforeach
                        <option value="Nvidia GeForce RTX 4060">Nvidia GeForce RTX 4060</option>
                        <option value="Nvidia GeForce RTX 4070">Nvidia GeForce RTX 4070</option>
                        <option value="Intel Iris Xe Graphics">Intel Iris Xe Graphics</option>
                    </select>
                    @error('gpu')
                        <span class="text-red-500 text-xs">{{ $message }}</span>
                    @enderror
                </div>
            </div>

            <div class="mt-6">
                <button type="submit" id="predictBtn" 
                        class="bg-blue-600 text-white px-6 py-2.5 rounded-md text-sm hover:bg-blue-700 transition duration-200 flex items-center gap-2">
                    <i class="fas fa-calculator"></i> Hitung Prediksi Harga
                </button>
            </div>
        </form>
    </div>

    <!-- Result Panel -->
    <div class="bg-white rounded-lg shadow p-6 flex flex-col">
        <h4 class="text-md font-semibold text-gray-700 mb-2">Menunggu Input</h4>
        <p class="text-sm text-gray-500 flex-1">
            Lengkapkan formulir di sebelah kiri untuk melihat estimasi harga pasar terkini.
        </p>
        <div id="resultContainer" class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-200 text-center transition-all">
            <span id="resultPrice" class="text-2xl font-bold text-gray-400">Rp -</span>
            <div id="resultDetail" class="mt-2 text-sm text-gray-500 hidden">
                <p class="text-green-600 font-medium">Estimasi Berdasarkan Spesifikasi</p>
            </div>
        </div>
    </div>
</div>

<!-- Insight Pasar -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
    <div class="bg-white rounded-lg shadow p-5">
        <div class="flex items-start gap-3">
            <div class="p-2 bg-green-100 rounded-full text-green-600">
                <i class="fas fa-arrow-up"></i>
            </div>
            <div>
                <h4 class="font-semibold text-gray-700">Tren GPU Naik</h4>
                <p class="text-sm text-gray-500">Harga laptop gaming meningkat 4% di kuartal ini.</p>
            </div>
        </div>
    </div>
    <div class="bg-white rounded-lg shadow p-5">
        <div class="flex items-start gap-3">
            <div class="p-2 bg-yellow-100 rounded-full text-yellow-600">
                <i class="fas fa-clock"></i>
            </div>
            <div>
                <h4 class="font-semibold text-gray-700">Waktu Terbaik</h4>
                <p class="text-sm text-gray-500">Bulan ini ideal untuk penjualan model Ultrabook.</p>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('predictionForm');
        const resultPrice = document.getElementById('resultPrice');
        const resultDetail = document.getElementById('resultDetail');

        // Handle form submission via AJAX
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(form);
            const submitBtn = document.getElementById('predictBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Memproses...';

            fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                    'Accept': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const price = data.data.predicted_price || data.data.price;
                    resultPrice.textContent = 'Rp ' + new Intl.NumberFormat('id-ID').format(price);
                    resultPrice.classList.remove('text-gray-400');
                    resultPrice.classList.add('text-green-600');
                    resultDetail.classList.remove('hidden');
                    // Tampilkan ringkasan spesifikasi
                    const specs = data.data.input_data || {};
                    const detailHtml = `
                        <p class="text-xs text-gray-500 mt-1">
                            ${specs.brand || ''} ${specs.cpu || ''} · ${specs.ram || 0}GB RAM · ${specs.storage || 0}GB SSD
                        </p>
                    `;
                    resultDetail.innerHTML = detailHtml;
                } else {
                    alert('Gagal memproses prediksi: ' + (data.message || 'Error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Terjadi kesalahan, silakan coba lagi.');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-calculator"></i> Hitung Prediksi Harga';
            });
        });
    });
</script>
@endpush
@endsection