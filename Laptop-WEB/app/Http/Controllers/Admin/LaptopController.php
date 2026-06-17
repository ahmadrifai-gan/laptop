<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Laptop;
use Illuminate\Http\Request;

class LaptopController extends Controller
{
    public function index(Request $request)
    {
        $query = Laptop::query();

        if ($request->filled("search")) {
            $search = $request->search;
            $query->where("Product", "like", "%{$search}%");
        }

        if ($request->filled("kategori")) {
            $query->where("Kategori", $request->kategori);
        }

        if ($request->filled("company")) {
            $companyCode = Laptop::encodeCompany($request->company);
            if ($companyCode !== null) {
                $query->where("Company", $companyCode);
            }
        }

        $laptops = $query
            ->orderBy("laptop_ID", "asc")
            ->paginate(15)
            ->withQueryString();

        return view("admin.laptops.index", compact("laptops"));
    }

    public function create()
    {
        return view("admin.laptops.create");
    }

    public function store(Request $request)
    {
        $request->validate([
            "Company" => "required|string",
            "Product" => "required|string|max:200",
            "TypeName" => "required|string",
            "Inches" => "required|numeric",
            "Cpu" => "required|string",
            "Ram" => "required|integer|min:1",
            "Memory" => "required|integer|min:1",
            "Gpu" => "required|string",
            "OpSys" => "nullable|string",
            "Weight" => "required|numeric",
            "Price_euros" => "required|numeric|min:0",
            "Kategori" => "required|in:Gaming,Programming,Office",
        ]);

        Laptop::create([
            "laptop_ID" => Laptop::nextLaptopId(),
            "Company" => Laptop::encodeCompany($request->Company) ?? 1,
            "Product" => $request->Product,
            "TypeName" => Laptop::encodeTypeName($request->TypeName) ?? 3,
            "Inches" => (float) $request->Inches,
            "ScreenResolution" => $request->ScreenResolution ?? "",
            "Cpu" => Laptop::encodeCpu($request->Cpu) ?? 4,
            "Ram" => (int) $request->Ram,
            "Memory" => (int) $request->Memory,
            "Gpu" => Laptop::encodeGpu($request->Gpu) ?? 2,
            "OpSys" => $request->OpSys ?? "No OS",
            "Weight" => (float) $request->Weight,
            "Price_euros" => (float) $request->Price_euros,
            "Kategori" => $request->Kategori,
        ]);

        return redirect()
            ->route("admin.laptops.index")
            ->with("success", "Laptop berhasil ditambahkan!");
    }

    public function show(Laptop $laptop)
    {
        return view("admin.laptops.show", compact("laptop"));
    }

    public function edit(Laptop $laptop)
    {
        return view("admin.laptops.edit", compact("laptop"));
    }

    public function update(Request $request, Laptop $laptop)
    {
        $request->validate([
            "Company" => "required|string",
            "Product" => "required|string|max:200",
            "TypeName" => "required|string",
            "Inches" => "required|numeric",
            "Cpu" => "required|string",
            "Ram" => "required|integer|min:1",
            "Memory" => "required|integer|min:1",
            "Gpu" => "required|string",
            "OpSys" => "nullable|string",
            "Weight" => "required|numeric",
            "Price_euros" => "required|numeric|min:0",
            "Kategori" => "required|in:Gaming,Programming,Office",
        ]);

        $laptop->update([
            "Company" =>
                Laptop::encodeCompany($request->Company) ?? $laptop->Company,
            "Product" => $request->Product,
            "TypeName" =>
                Laptop::encodeTypeName($request->TypeName) ?? $laptop->TypeName,
            "Inches" => (float) $request->Inches,
            "ScreenResolution" =>
                $request->ScreenResolution ?? $laptop->ScreenResolution,
            "Cpu" => Laptop::encodeCpu($request->Cpu) ?? $laptop->Cpu,
            "Ram" => (int) $request->Ram,
            "Memory" => (int) $request->Memory,
            "Gpu" => Laptop::encodeGpu($request->Gpu) ?? $laptop->Gpu,
            "OpSys" => $request->OpSys ?? $laptop->OpSys,
            "Weight" => (float) $request->Weight,
            "Price_euros" => (float) $request->Price_euros,
            "Kategori" => $request->Kategori,
        ]);

        return redirect()
            ->route("admin.laptops.index")
            ->with("success", "Laptop berhasil diperbarui!");
    }

    public function destroy(Laptop $laptop)
    {
        $laptop->delete();
        return redirect()
            ->route("admin.laptops.index")
            ->with("success", "Laptop berhasil dihapus!");
    }
}
