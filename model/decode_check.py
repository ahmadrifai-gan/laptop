import pickle

with open('models/encoders.pkl', 'rb') as f:
    encoders = pickle.load(f)

for col, enc in encoders.items():
    print(f'--- {col} ---')
    for i, cls in enumerate(enc.classes_):
        print(f'  {i}: {cls}')
