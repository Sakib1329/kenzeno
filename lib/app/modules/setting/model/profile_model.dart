// model/profile_model.dart

class ProfileModel {
  String? id;
  String? email;
  String? phoneNumber;
  String? avatar;           // this is your profile_image
  String? firstName;
  String? lastName;
  String? gender;
  int? age;
  String? dateOfBirth;
  double? heightCm;
  double? weightKg;
  String? goal;
  String? activityLevel;
  int? coachType;
  String? preferredWorkoutTime;     // you can parse to TimeOfDay if needed
  List<WorkoutDay>? preferredWorkoutDays;
  String? joinedAt;

  ProfileModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.avatar,
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.goal,
    this.activityLevel,
    this.coachType,
    this.preferredWorkoutTime,
    this.preferredWorkoutDays,
    this.joinedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      avatar: json['avatar'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] is int ? json['age'] : int.tryParse(json['age'].toString()),
      dateOfBirth: json['date_of_birth'] as String?,
      heightCm: _parseDouble(json['height_cm']),
      weightKg: _parseDouble(json['weight_kg']),
      goal: json['goal'] as String?,
      activityLevel: json['activity_level'] as String?,
      coachType: json['coach_type'] is int ? json['coach_type'] : int.tryParse(json['coach_type'].toString() ?? ''),
      preferredWorkoutTime: json['preferred_workout_time'] as String?,
      preferredWorkoutDays: json['preferred_workout_days'] == null
          ? null
          : (json['preferred_workout_days'] as List)
          .map((e) => WorkoutDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      joinedAt: json['joined_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (goal != null) 'goal': goal,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (coachType != null) 'coach_type': coachType,
      if (preferredWorkoutTime != null) 'preferred_workout_time': preferredWorkoutTime,
      if (avatar != null && avatar!.isNotEmpty) 'avatar': avatar,
      // preferred_workout_days can be added later when you support editing
    };
  }

  // Helper to safely parse double (handles int → double conversion)
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

// Supporting model for workout days
class WorkoutDay {
  final int id;
  final String name;

  WorkoutDay({required this.id, required this.name});

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}