// Model to hold real response
class MealAnalysisResult {
  final int tempUploadId;
  final String mealName;
  final double estimatedCalories;
  final String overallHealthInsight;
  final Map<String, double> macronutrients;
  final Map<String, double> micronutrients;
  final String improvementSuggestion;
  final String imagePath;

  MealAnalysisResult({
    required this.tempUploadId,
    required this.mealName,
    required this.estimatedCalories,
    required this.overallHealthInsight,
    required this.macronutrients,
    required this.micronutrients,
    required this.improvementSuggestion,
    required this.imagePath,
  });

  factory MealAnalysisResult.fromJson(Map<String, dynamic> json) {
    return MealAnalysisResult(
      tempUploadId: json['temp_upload_id'],
      mealName: json['analysis_data']['meal_name'] ?? 'Unknown Meal',
      estimatedCalories: (json['analysis_data']['estimated_calories'] as num).toDouble(),
      overallHealthInsight: json['analysis_data']['overall_health_insight'] ?? '',
      macronutrients: {
        'protein': (json['analysis_data']['macronutrients']['protein_g'] as num).toDouble(),
        'fat': (json['analysis_data']['macronutrients']['fat_g'] as num).toDouble(),
        'carbs': (json['analysis_data']['macronutrients']['carbs_g'] as num).toDouble(),
      },
      micronutrients: {
        'vitamin_c': (json['analysis_data']['micronutrients']['vitamin_c_mg'] as num?)?.toDouble() ?? 0.0,
        'iron': (json['analysis_data']['micronutrients']['iron_mg'] as num?)?.toDouble() ?? 0.0,
      },
      improvementSuggestion: json['analysis_data']['improvement_suggestion'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }
}