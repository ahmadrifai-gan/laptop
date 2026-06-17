<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Laptop extends Model
{
    protected $connection = "mongodb";
    protected $table = "data";

    protected $fillable = [
        "laptop_ID",
        "Company",
        "Product",
        "TypeName",
        "Inches",
        "ScreenResolution",
        "Cpu",
        "Ram",
        "Memory",
        "Gpu",
        "OpSys",
        "Weight",
        "Price_euros",
        "Kategori",
    ];

    protected $casts = [
        "Company" => "integer",
        "TypeName" => "integer",
        "Cpu" => "integer",
        "Gpu" => "integer",
        "Ram" => "integer",
        "Memory" => "integer",
        "Inches" => "float",
        "Weight" => "float",
        "Price_euros" => "float",
        "laptop_ID" => "integer",
    ];

    // -----------------------------------------------
    // Mapping decode (sesuai LabelEncoder dari model)
    // -----------------------------------------------
    public const COMPANY_MAP = [
        0 => "Acer",
        1 => "Apple",
        2 => "Asus",
        3 => "Chuwi",
        4 => "Dell",
        5 => "Fujitsu",
        6 => "Google",
        7 => "HP",
        8 => "Huawei",
        9 => "LG",
        10 => "Lenovo",
        11 => "MSI",
        12 => "Mediacom",
        13 => "Microsoft",
        14 => "Razer",
        15 => "Samsung",
        16 => "Toshiba",
        17 => "Vero",
        18 => "Xiaomi",
    ];

    public const TYPENAME_MAP = [
        0 => "2 in 1 Convertible",
        1 => "Gaming",
        2 => "Netbook",
        3 => "Notebook",
        4 => "Ultrabook",
        5 => "Workstation",
    ];

    public const CPU_MAP = [
        0 => "Celeron",
        1 => "Other",
        2 => "Pentium",
        3 => "Core i3",
        4 => "Core i5",
        5 => "Core i7",
    ];

    public const GPU_MAP = [
        0 => "AMD",
        1 => "ARM",
        2 => "Intel",
        3 => "Nvidia",
    ];

    // -----------------------------------------------
    // Accessors (nilai terbaca)
    // -----------------------------------------------
    public function getCompanyNameAttribute(): string
    {
        return self::COMPANY_MAP[$this->Company] ??
            "Unknown ({$this->Company})";
    }

    public function getTypeNameLabelAttribute(): string
    {
        return self::TYPENAME_MAP[$this->TypeName] ??
            "Unknown ({$this->TypeName})";
    }

    public function getCpuLabelAttribute(): string
    {
        return self::CPU_MAP[$this->Cpu] ?? "Unknown ({$this->Cpu})";
    }

    public function getGpuLabelAttribute(): string
    {
        return self::GPU_MAP[$this->Gpu] ?? "Unknown ({$this->Gpu})";
    }

    public function getPriceFormattedAttribute(): string
    {
        return "€" . number_format((float) $this->Price_euros, 2);
    }

    public function getRamLabelAttribute(): string
    {
        return $this->Ram . "GB";
    }

    public function getMemoryLabelAttribute(): string
    {
        return $this->Memory . "GB";
    }

    public function getWeightLabelAttribute(): string
    {
        return $this->Weight . "kg";
    }

    // -----------------------------------------------
    // Scopes
    // -----------------------------------------------
    public function scopeByKategori($query, string $kategori)
    {
        return $query->where("Kategori", $kategori);
    }

    public function scopeByCompany($query, int $companyCode)
    {
        return $query->where("Company", $companyCode);
    }

    // -----------------------------------------------
    // Helper statis
    // -----------------------------------------------
    public static function encodeCompany(string $name): ?int
    {
        return array_search($name, self::COMPANY_MAP) !== false
            ? array_search($name, self::COMPANY_MAP)
            : null;
    }

    public static function encodeTypeName(string $name): ?int
    {
        return array_search($name, self::TYPENAME_MAP) !== false
            ? array_search($name, self::TYPENAME_MAP)
            : null;
    }

    public static function encodeCpu(string $name): ?int
    {
        return array_search($name, self::CPU_MAP) !== false
            ? array_search($name, self::CPU_MAP)
            : null;
    }

    public static function encodeGpu(string $name): ?int
    {
        return array_search($name, self::GPU_MAP) !== false
            ? array_search($name, self::GPU_MAP)
            : null;
    }

    public static function nextLaptopId(): int
    {
        $max = self::max("laptop_ID");
        return ($max ?? 0) + 1;
    }
}
