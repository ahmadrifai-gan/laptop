#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
API Wrapper untuk Prediksi Kategori Laptop
Dipanggil dari Laravel Controller
Usage: python predict_api.py '{"TypeName":"...", "Ram":"16GB", ...}'
"""

import sys
import json
import os

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
        input_data = json.loads(sys.argv[1])

        # Initialize predictor
        predictor = LaptopPredictor()

        # Make prediction
        result = predictor.predict(input_data)

        # Return JSON response
        response = {
            'success': True,
            'prediction': result['prediction'],
            'confidence': result['confidence'],
            'neighbors': {
                'indices': result['neighbors_indices'],
                'distances': [round(d, 4) for d in result['distances']]
            }
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
            'error': 'Prediction failed',
            'details': str(e)
        }))
        sys.exit(1)


if __name__ == '__main__':
    main()
