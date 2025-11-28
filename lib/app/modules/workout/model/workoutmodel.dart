// lib/models/workout.dart
class UserExercise {
  final int id;
  final String exerciseName;
  final String exerciseDescription;
  final String? videoUrl;
  final int sets;
  final int reps;
  final int durationSeconds;
  final int restTime;
  final int order;
  final String notes;

  UserExercise({
    required this.id,
    required this.exerciseName,
    required this.exerciseDescription,
    this.videoUrl,
    required this.sets,
    required this.reps,
    required this.durationSeconds,
    required this.restTime,
    required this.order,
    required this.notes,
  });

  factory UserExercise.fromJson(Map<String, dynamic> json) {
    return UserExercise(
      id: json['id'],
      exerciseName: json['exercise_name'],
      exerciseDescription: json['exercise_description'] ?? '',
      videoUrl: json['video'],
      sets: json['sets'],
      reps: json['reps'],
      durationSeconds: json['duration_seconds'],
      restTime: json['rest_time'],
      order: json['order'],
      notes: json['notes'] ?? '',
    );
  }
}

class Workout {
  final int id;
  final String name;
  final String description;
  final String estimatedDuration;
  final String estimatedCalories;
  final int exerciseCount;
  final String difficulty;
  final String image;
  final List<UserExercise>? exercises;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.estimatedDuration,
    required this.estimatedCalories,
    required this.exerciseCount,
    required this.difficulty,
    required this.image,
    this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      estimatedDuration: json['estimated_duration'] ?? 'N/A',
      estimatedCalories: json['estimated_calories'] ?? 'N/A',
      exerciseCount: json['exercise_count'] ?? 0,
      difficulty: json['difficulty'] ?? 'Beginner',
      image: json['image'] ?? '',
      exercises: json['user_exercises'] != null
          ? (json['user_exercises'] as List)
          .map((e) => UserExercise.fromJson(e))
          .toList()
          : null,
    );
  }
}