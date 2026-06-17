import pandas as pd

# Load data - file .xls ini sebenarnya CSV
for enc in ['utf-8', 'latin-1', 'cp1252']:
    try:
        df = pd.read_csv('laptop_price.xls', encoding=enc)
        print(f'Loaded with encoding: {enc}')
        break
    except Exception as e:
        print(f'Failed {enc}: {e}')

print(f"Total rows: {len(df)}")
print(f"\nColumns: {list(df.columns)}")
print(f"\nSample data (first 3 rows):")
print(df.head(3).to_string())

print(f"\n--- RAM distribution ---")
print(df['Ram'].value_counts().sort_index())

print(f"\n--- GPU unique values (first word) ---")
df['Gpu_brand'] = df['Gpu'].str.split().str[0]
print(df['Gpu_brand'].value_counts())

print(f"\n--- Laptops with RAM >= 16GB ---")
df['Ram_num'] = df['Ram'].str.replace('GB','').astype(int)
high_ram = df[df['Ram_num'] >= 16]
print(f"Count: {len(high_ram)}")
print(high_ram[['Company','Product','Ram','Gpu']].head(10).to_string())

print(f"\n--- Laptops RAM>=16 AND GPU=Nvidia/AMD ---")
gaming_mask = (df['Ram_num'] >= 16) & (df['Gpu_brand'].str.lower().isin(['nvidia','amd']))
gaming = df[gaming_mask]
print(f"Count (potential Gaming): {len(gaming)}")
print(gaming[['Company','Product','Ram','Gpu','Price_euros']].head(10).to_string())
