<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class PredictionController extends Controller
{
    /**
     * Get laptop category prediction based on specs
     * POST /api/predict
     */
    public function predict(Request $request)
    {
        try {
            // Validate input
            $validated = $request->validate([
                'TypeName' => 'required|string',
                'Ram' => 'required|string',
                'Memory' => 'required|string',
                'Cpu' => 'required|string',
                'Gpu' => 'required|string',
                'Weight' => 'required|string',
                'Price_euros' => 'required|numeric',
            ]);

            // Prepare Python script
            $modelPath = base_path('../model');
            $pythonScript = $modelPath . '/predict_api.py';

            // Convert validated data to JSON
            $inputData = json_encode($validated);

            // Run Python prediction script
            $process = new Process([
                'python',
                $pythonScript,
                $inputData
            ]);

            $process->setTimeout(30);
            $process->run();

            if (!$process->isSuccessful()) {
                throw new ProcessFailedException($process);
            }

            // Parse result
            $output = $process->getOutput();
            $result = json_decode($output, true);

            if (!$result) {
                return response()->json([
                    'success' => false,
                    'message' => 'Failed to parse prediction result'
                ], 500);
            }

            return response()->json([
                'success' => true,
                'data' => $result
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'errors' => $e->errors()
            ], 422);

        } catch (ProcessFailedException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Prediction service error',
                'error' => $e->getMessage()
            ], 500);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Internal server error',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get laptop recommendations based on specs
     * POST /api/recommendations
     */
    public function recommendations(Request $request)
    {
        try {
            // Validate input
            $validated = $request->validate([
                'TypeName' => 'required|string',
                'Ram' => 'required|string',
                'Memory' => 'required|string',
                'Cpu' => 'required|string',
                'Gpu' => 'required|string',
                'Weight' => 'required|string',
                'Price_euros' => 'required|numeric',
                'top_n' => 'nullable|integer|min:1|max:20',
            ]);

            $topN = $validated['top_n'] ?? 5;
            unset($validated['top_n']);

            // Prepare Python script
            $modelPath = base_path('../model');
            $pythonScript = $modelPath . '/recommend_api.py';

            // Convert validated data to JSON
            $inputData = json_encode([
                'input' => $validated,
                'top_n' => $topN
            ]);

            // Run Python recommendation script
            $process = new Process([
                'python',
                $pythonScript,
                $inputData
            ]);

            $process->setTimeout(30);
            $process->run();

            if (!$process->isSuccessful()) {
                throw new ProcessFailedException($process);
            }

            // Parse result
            $output = $process->getOutput();
            $result = json_decode($output, true);

            if (!$result) {
                return response()->json([
                    'success' => false,
                    'message' => 'Failed to parse recommendations'
                ], 500);
            }

            return response()->json([
                'success' => true,
                'data' => $result
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'errors' => $e->errors()
            ], 422);

        } catch (ProcessFailedException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Recommendation service error',
                'error' => $e->getMessage()
            ], 500);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Internal server error',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get available laptop categories
     * GET /api/categories
     */
    public function categories()
    {
        return response()->json([
            'success' => true,
            'data' => [
                'categories' => [
                    'Gaming',
                    'Programming',
                    'Office'
                ]
            ]
        ], 200);
    }
}
