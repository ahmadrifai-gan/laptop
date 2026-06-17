@php $laptop = $laptop ?? null; @endphp

@if($errors->any())
<div class="mb-5 p-4 bg-red-50 border border-red-200 rounded-lg">
    <ul class="list-disc list-inside text-sm text-red-600 space-y-1">
        @foreach($errors->all() as $error)
        <li>{{ $error }}</li>
        @endforeach
    </ul>
</div>
@endif

<div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
    <!-- Company -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Brand / Company <span class="text-red-500">*</span></label>
        <select name="Company" required
                class="w-full px-3 py-2.5 border @error('Company') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih brand...</option>
            @foreach(\App\Models\Laptop::COMPANY_MAP as $key => $name)
            <option value="{{ $name }}" {{ old('Company', $laptop?->company_name) == $name ? 'selected' : '' }}>{{ $name }}</option>
            @endforeach
        </select>
        @error('Company')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Product -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Nama Produk <span class="text-red-500">*</span></label>
        <input type="text" name="Product" value="{{ old('Product', $laptop?->Product) }}" required
               class="w-full px-3 py-2.5 border @error('Product') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
               placeholder="Contoh: MacBook Pro, XPS 15">
        @error('Product')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- TypeName -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Tipe <span class="text-red-500">*</span></label>
        <select name="TypeName" required
                class="w-full px-3 py-2.5 border @error('TypeName') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih tipe...</option>
            @foreach(\App\Models\Laptop::TYPENAME_MAP as $key => $label)
            <option value="{{ $label }}" {{ old('TypeName', $laptop?->type_name_label) == $label ? 'selected' : '' }}>{{ $label }}</option>
            @endforeach
        </select>
        @error('TypeName')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Inches -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Ukuran Layar (inci)</label>
        <input type="number" name="Inches" value="{{ old('Inches', $laptop?->Inches) }}" step="0.1" min="0"
               class="w-full px-3 py-2.5 border @error('Inches') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
               placeholder="Contoh: 15.6">
        @error('Inches')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- ScreenResolution -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Resolusi Layar</label>
        <input type="text" name="ScreenResolution" value="{{ old('ScreenResolution', $laptop?->ScreenResolution) }}"
               class="w-full px-3 py-2.5 border @error('ScreenResolution') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
               placeholder="Contoh: 1920x1080">
        @error('ScreenResolution')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Cpu -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Prosesor (CPU) <span class="text-red-500">*</span></label>
        <select name="Cpu" required
                class="w-full px-3 py-2.5 border @error('Cpu') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih CPU...</option>
            @foreach(\App\Models\Laptop::CPU_MAP as $key => $label)
            <option value="{{ $label }}" {{ old('Cpu', $laptop?->cpu_label) == $label ? 'selected' : '' }}>{{ $label }}</option>
            @endforeach
        </select>
        @error('Cpu')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Ram -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">RAM <span class="text-red-500">*</span></label>
        <select name="Ram" required
                class="w-full px-3 py-2.5 border @error('Ram') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih RAM...</option>
            @foreach([2, 4, 6, 8, 12, 16, 32, 64] as $r)
            <option value="{{ $r }}" {{ old('Ram', $laptop?->Ram) == $r ? 'selected' : '' }}>{{ $r }}GB</option>
            @endforeach
        </select>
        @error('Ram')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Memory -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Storage (GB) <span class="text-red-500">*</span></label>
        <input type="number" name="Memory" value="{{ old('Memory', $laptop?->Memory) }}" required min="0"
               class="w-full px-3 py-2.5 border @error('Memory') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
               placeholder="Contoh: 512">
        @error('Memory')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Gpu -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">GPU <span class="text-red-500">*</span></label>
        <select name="Gpu" required
                class="w-full px-3 py-2.5 border @error('Gpu') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih GPU...</option>
            @foreach(\App\Models\Laptop::GPU_MAP as $key => $label)
            <option value="{{ $label }}" {{ old('Gpu', $laptop?->gpu_label) == $label ? 'selected' : '' }}>{{ $label }}</option>
            @endforeach
        </select>
        @error('Gpu')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- OpSys -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Sistem Operasi</label>
        <select name="OpSys"
                class="w-full px-3 py-2.5 border @error('OpSys') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih OS...</option>
            @foreach(['Windows 10', 'Windows 11', 'macOS', 'Linux', 'Chrome OS', 'No OS'] as $os)
            <option value="{{ $os }}" {{ old('OpSys', $laptop?->OpSys) == $os ? 'selected' : '' }}>{{ $os }}</option>
            @endforeach
        </select>
        @error('OpSys')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Weight -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Berat (kg)</label>
        <input type="number" name="Weight" value="{{ old('Weight', $laptop?->Weight) }}" step="0.01" min="0"
               class="w-full px-3 py-2.5 border @error('Weight') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
               placeholder="Contoh: 1.37">
        @error('Weight')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Price -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Harga (€) <span class="text-red-500">*</span></label>
        <div class="relative">
            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm">€</span>
            <input type="number" name="Price_euros" value="{{ old('Price_euros', $laptop?->Price_euros) }}" required min="0" step="0.01"
                   class="w-full pl-7 pr-3 py-2.5 border @error('Price_euros') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
                   placeholder="999.99">
        </div>
        @error('Price_euros')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>

    <!-- Kategori -->
    <div>
        <label class="block text-sm font-medium text-gray-700 mb-1.5">Kategori <span class="text-red-500">*</span></label>
        <select name="Kategori" required
                class="w-full px-3 py-2.5 border @error('Kategori') border-red-400 @else border-gray-200 @enderror rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            <option value="">Pilih kategori...</option>
            <option value="Gaming" {{ old('Kategori', $laptop?->Kategori) == 'Gaming' ? 'selected' : '' }}>🎮 Gaming</option>
            <option value="Programming" {{ old('Kategori', $laptop?->Kategori) == 'Programming' ? 'selected' : '' }}>💻 Programming</option>
            <option value="Office" {{ old('Kategori', $laptop?->Kategori) == 'Office' ? 'selected' : '' }}>📁 Office</option>
        </select>
        @error('Kategori')<p class="mt-1 text-xs text-red-500">{{ $message }}</p>@enderror
    </div>
</div>
