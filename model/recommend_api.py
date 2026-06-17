#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
API Wrapper untuk Rekomendasi Laptop
Dipanggil dari Laravel Controller
Usage: python recommend_api.py '{"input": {...}, "top_n": 5}'
"""

import sys
import json
import os
import pandas as pd

# Add model directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from predik import LaptopPredictor


def main():
    """Main API handler"""

    try:
        # Get input from command line argument
        if len(sys.argv) < 2:
            print(json.dumps({
                'success': False,
                'error': 'No input provided'
            }))
            sys.exit(1)

        # Parse JSON input
        data = json.loads(sys.argv[1])
        input_data = data.get('input', {})
        top_n = data.get('top_n', 5)

        # Validate
        if not input_data:
            print(json.dumps({
                'success': False,
                'error': 'No input data provided'
            }))
            sys.exit(1)

        # Initialize predictor
        predictor = LaptopPredictor()

        # Get recommendations
        recommendations = predictor.get_recommendations(input_data, top_n=top_n)

        # Process recommendations data
        processed_recommendations = []
        if recommendations.get('rekomendasi'):
            for laptop in recommendations['rekomendasi']:
                # Convert all values to JSON-serializable types
                processed_laptop = {}
                for key, value in laptop.items():
                    if pd.isna(value):
                        processed_laptop[key] = None
                    elif isinstance(value, (int, float, str, bool)):
                        processed_laptop[key] = value
                    else:
                        processed_laptop[key] = str(value)
                processed_recommendations.append(processed_laptop)

        # Return JSON response
        response = {
            'success': True,
            'kategori_diprediksi': recommendations['kategori_diprediksi'],
            'confidence': recommendations['confidence'],
            'total_recommendations': recommendations['jumlah_rekomendasi'],
            'recommendations': processed_recommendations
        }

        print(json.dumps(response, ensure_ascii=False))
        sys.exit(0)

    except json.JSONDecodeError as e:
        print(json.dumps({
            'success': False,
            'error': 'Invalid JSON input',
            'details': str(e)
        }))
        sys.exit(1)

    except KeyError as e:
        print(json.dumps({
            'success': False,
            'error': 'Missing required field',
            'field': str(e)
        }))
        sys.exit(1)

    except Exception as e:
        print(json.dumps({
            'success': False,
            'error': 'Recommendation failed',
            'details': str(e)
        }))
        sys.exit(1)


if __name__ == '__main__':
    main()
