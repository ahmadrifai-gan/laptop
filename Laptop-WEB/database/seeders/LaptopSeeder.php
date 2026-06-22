<?php
namespace Database\Seeders;

use App\Models\Laptop;
use Illuminate\Database\Seeder;

class LaptopSeeder extends Seeder
{
    public function run(): void
    {
        $laptops = [
            [
                "company" => "Apple",
                "product" => "MacBook Pro",
                "type_name" => "Ultrabook",
                "inches" => "15.4",
                "cpu" => "Intel Core i7",
                "ram" => "16GB",
                "memory" => "512GB SSD",
                "gpu" => "AMD Radeon Pro 455",
                "op_sys" => "macOS",
                "weight" => "1.83kg",
                "price_euros" => 2399.0,
                "kategori" => "Programming",
                "is_active" => true,
            ],
            [
                "company" => "ASUS",
                "product" => "ROG GL502",
                "type_name" => "Gaming",
                "inches" => "15.6",
                "cpu" => "Intel Core i7",
                "ram" => "16GB",
                "memory" => "1TB HDD +  256GB SSD",
                "gpu" => "Nvidia GeForce GTX 1070",
                "op_sys" => "Windows 10",
                "weight" => "2.24kg",
                "price_euros" => 1799.0,
                "kategori" => "Gaming",
                "is_active" => true,
            ],
            [
                "company" => "Dell",
                "product" => "Inspiron 15",
                "type_name" => "Notebook",
                "inches" => "15.6",
                "cpu" => "Intel Core i3",
                "ram" => "4GB",
                "memory" => "1TB HDD",
                "gpu" => "Intel HD Graphics 620",
                "op_sys" => "Windows 10",
                "weight" => "2.04kg",
                "price_euros" => 499.0,
                "kategori" => "Office",
                "is_active" => true,
            ],
        ];

        foreach ($laptops as $laptop) {
            Laptop::firstOrCreate(
                [
                    "company" => $laptop["company"],
                    "product" => $laptop["product"],
                ],
                $laptop,
            );
        }
    }
}
