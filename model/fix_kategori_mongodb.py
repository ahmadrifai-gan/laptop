"""
Script untuk memperbaiki field Kategori di MongoDB
berdasarkan data asli laptop_price.xls (CSV)
"""
import pandas as pd
from pymongo import MongoClient

# ── Load CSV asli ──────────────────────────────────────────
print("📂 Membaca laptop_price.xls...")
for enc in ['utf-8', 'latin-1', 'cp1252']:
    try:
        df = pd.read_csv('laptop_price.xls', encoding=enc)
        print(f"   ✅ Berhasil dengan encoding: {enc}")
        break
    except:
        continue

print(f"   Total data: {len(df)} laptop")
print(f"   Kolom: {list(df.columns)}")

# ── Fungsi kategorisasi (berdasarkan data ASLI sebelum encode) ──
def categorize_laptop(row):
    """
    Kategorisasi berdasarkan spesifikasi asli (string GPU)
    """
    ram_str  = str(row['Ram']).replace('GB', '').strip()
    ram      = int(ram_str) if ram_str.isdigit() else 0
    gpu_str  = str(row['Gpu']).strip().lower()
    gpu_brand = gpu_str.split()[0] if gpu_str else ''

    # Gaming: RAM >= 16GB DAN GPU Nvidia atau AMD
    if ram >= 16 and gpu_brand in ['nvidia', 'amd']:
        return 'Gaming'
    # Programming: RAM >= 8GB
    elif ram >= 8:
        return 'Programming'
    # Office: selainnya
    else:
        return 'Office'

df['Kategori_fix'] = df.apply(categorize_laptop, axis=1)

print("\n📊 Distribusi Kategori yang Benar:")
print(df['Kategori_fix'].value_counts().to_string())

# ── Konfirmasi sebelum update ──────────────────────────────
print("\n⚠️  Script ini akan UPDATE field Kategori di MongoDB.")
confirm = input("   Ketik 'ya' untuk lanjut: ").strip().lower()
if confirm != 'ya':
    print("❌ Dibatalkan.")
    exit()

# ── Koneksi MongoDB ───────────────────────────────────────
print("\n🔌 Menghubungkan ke MongoDB...")
client = MongoClient('mongodb://localhost:27017/')
db     = client['Laptop']
col    = db['data']
print(f"   ✅ Terhubung. Dokumen di 'data': {col.count_documents({})}")

# ── Update setiap dokumen ─────────────────────────────────
print("\n🔄 Mengupdate Kategori...")
updated = 0
skipped = 0
not_found = 0

for _, row in df.iterrows():
    laptop_id  = int(row['laptop_ID'])
    new_kat    = row['Kategori_fix']

    result = col.update_one(
        {'laptop_ID': laptop_id},
        {'$set': {'Kategori': new_kat}}
    )

    if result.matched_count > 0:
        updated += 1
    else:
        not_found += 1

    if updated % 200 == 0 and updated > 0:
        print(f"   Progress: {updated}/{len(df)}...")

print(f"\n✅ Selesai!")
print(f"   Diupdate  : {updated}")
print(f"   Tidak ada : {not_found}")

# ── Verifikasi hasil ──────────────────────────────────────
print("\n📊 Distribusi Kategori di MongoDB setelah update:")
pipeline = [{'$group': {'_id': '$Kategori', 'count': {'$sum': 1}}}]
for doc in col.aggregate(pipeline):
    print(f"   {doc['_id']}: {doc['count']}")

# ── Contoh laptop Gaming ──────────────────────────────────
print("\n🎮 Contoh 5 laptop Gaming:")
gaming = col.find({'Kategori': 'Gaming'}, {'Product': 1, 'Gpu': 1, 'Ram': 1, 'Price_euros': 1, '_id': 0}).limit(5)
for g in gaming:
    print(f"   {g}")

client.close()
print("\n✅ Done!")
