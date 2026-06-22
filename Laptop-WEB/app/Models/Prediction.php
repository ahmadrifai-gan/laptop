<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Prediction extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'predictions';

    protected $fillable = [
        'user_id',
        'input_data',
        'predicted_price',
        'category',
        'status',
        'accuracy',
    ];

    protected $casts = [
        'input_data' => 'array',
        'predicted_price' => 'float',
        'accuracy' => 'float',
    ];
}
