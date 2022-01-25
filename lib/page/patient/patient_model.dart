class PatientModel {
  String? id;
  Gender gender;
  double age;
  bool hypertension;
  bool heartDisease;
  bool everMarried;
  WorkType workType;
  ResidenceType residenceType;
  double avgGlucoseLevel;
  double bmi;
  SmokingStatus smokingStatus;
  bool? strokePredict;
  PatientModel({
    this.id,
    required this.gender,
    required this.age,
    required this.hypertension,
    required this.heartDisease,
    required this.everMarried,
    required this.workType,
    required this.residenceType,
    required this.avgGlucoseLevel,
    required this.bmi,
    required this.smokingStatus,
  });

  // TODO: add convert
  @override
  String toString() {
    return 'id: $id, gender: ${gender.value()}, age: $age, hypertension: ${hypertension ? 1 : 0}, heartDisease: ${heartDisease ? 1 : 0}, everMarried: ${everMarried ? 'Yes' : 'No'}, workType: ${workType.value()}, residenceType: ${residenceType.value()}, avgGlucoseLevel: $avgGlucoseLevel, bmi: $bmi, smokingStatus: ${smokingStatus.value()}';
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender.value(),
      'age': age,
      'hypertension': hypertension,
      'heartDisease': heartDisease,
      'everMarried': everMarried,
      'workType': workType.value(),
      'residenceType': residenceType.value(),
      'avgGlucoseLevel': avgGlucoseLevel,
      'bmi': bmi,
      'smokingStatus': smokingStatus.value(),
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      gender: Gender.values.firstWhere((e) => e.value() == json['gender']),
      age: json['age']?.toDouble() ?? 0,
      hypertension: json['hypertension'] ?? false,
      heartDisease: json['heartDisease'] ?? false,
      everMarried: json['everMarried'] ?? false,
      workType:
          WorkType.values.firstWhere((e) => e.value() == json['workType']),
      residenceType: ResidenceType.values
          .firstWhere((e) => e.value() == json['residenceType']),
      avgGlucoseLevel: json['avgGlucoseLevel']?.toDouble() ?? 0.0,
      bmi: json['bmi']?.toDouble() ?? 0.0,
      smokingStatus: SmokingStatus.values
          .firstWhere((e) => e.value() == json['smokingStatus']),
    );
  }
}

enum Gender { male, female }

extension GenderExt on Gender {
  String value() {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
}

enum WorkType { children, selfEmployed, private, neverWorked, govtJob }

extension WorkTypeExt on WorkType {
  String value() {
    switch (this) {
      case WorkType.children:
        return 'children';
      case WorkType.selfEmployed:
        return 'Self-employed';
      case WorkType.private:
        return 'Private';
      case WorkType.neverWorked:
        return 'Never_worked';
      case WorkType.govtJob:
        return 'Govt_job';
    }
  }
}

enum ResidenceType { urban, rural }

extension ResidencetypeExt on ResidenceType {
  String value() {
    switch (this) {
      case ResidenceType.urban:
        return 'Urban';
      case ResidenceType.rural:
        return 'Rural';
    }
  }
}

enum SmokingStatus { smokes, neverSmoked, formerlySmoked, unknown }

extension SmokingStatusExt on SmokingStatus {
  String value() {
    switch (this) {
      case SmokingStatus.smokes:
        return 'smokes';
      case SmokingStatus.neverSmoked:
        return 'never smoked';
      case SmokingStatus.formerlySmoked:
        return 'formerly smoked';
      case SmokingStatus.unknown:
        return 'Unknown';
    }
  }
}

extension StringExt on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
