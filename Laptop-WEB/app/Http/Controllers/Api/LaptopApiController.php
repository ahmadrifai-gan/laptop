<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Laptop;
use Illuminate\Http\Request;

class LaptopApiController extends Controller
{
    public function index(Request $request)
    {
        $query = Laptop::query();

        if ($request->filled("kategori")) {
            $query->where("Kategori", $request->kategori);
        }

        if ($request->filled("search")) {
            $query->where("Product", "like", "%" . $request->search . "%");
        }

        $laptops = $query->orderBy("Price_euros")->paginate(20);

        // Decode fields for response
        $decoded = $laptops->getCollection()->map(fn($l) => $this->decode($l));
        $laptops->setCollection($decoded);

        return response()->json([
            "success" => true,
            "data" => $laptops,
        ]);
    }

    public function show(Laptop $laptop)
    {
        return response()->json([
            "success" => true,
            "data" => $this->decode($laptop),
        ]);
    }

    public function byKategori(string $kategori)
    {
        $valid = ["Gaming", "Programming", "Office"];
        if (!in_array($kategori, $valid)) {
            return response()->json(
                [
                    "success" => false,
                    "message" =>
                        "Kategori tidak valid. Gunakan: Gaming, Programming, atau Office",
                ],
                422,
            );
        }

        $laptops = Laptop::where("Kategori", $kategori)
            ->orderBy("Price_euros")
            ->get()
            ->map(fn($l) => $this->decode($l));

        return response()->json([
            "success" => true,
            "kategori" => $kategori,
            "total" => $laptops->count(),
            "data" => $laptops,
        ]);
    }

    /**
     * Decode encoded integer fields ke string yang bisa dibaca.
     */
    private function decode(Laptop $laptop): array
    {
        return [
            "id" => (string) $laptop->_id,
            "laptop_id" => $laptop->laptop_ID,
            "company" => $laptop->company_name,
            "product" => $laptop->Product,
            "type_name" => $laptop->type_name_label,
            "inches" => $laptop->Inches,
            "screen_resolution" => $laptop->ScreenResolution,
            "cpu" => $laptop->cpu_label,
            "ram" => $laptop->Ram,
            "ram_label" => $laptop->ram_label,
            "memory" => $laptop->Memory,
            "memory_label" => $laptop->memory_label,
            "gpu" => $laptop->gpu_label,
            "op_sys" => $laptop->OpSys,
            "weight" => $laptop->Weight,
            "weight_label" => $laptop->weight_label,
            "price_euros" => $laptop->Price_euros,
            "price_formatted" => $laptop->price_formatted,
            "kategori" => $laptop->Kategori,
        ];
    }
}
