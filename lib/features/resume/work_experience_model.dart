class WorkExperience {
  String id;
  String jobTitle;
  String companyName;
  String location;
  String employmentType;
  DateTime? startDate;
  DateTime? endDate;
  bool currentlyWorking;
  String description;

  WorkExperience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.employmentType,
    this.startDate,
    this.endDate,
    this.currentlyWorking = false,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "jobTitle": jobTitle,
      "companyName": companyName,
      "location": location,
      "employmentType": employmentType,
      "startDate": startDate?.millisecondsSinceEpoch,
      "endDate": endDate?.millisecondsSinceEpoch,
      "currentlyWorking": currentlyWorking,
      "description": description,
    };
  }

  factory WorkExperience.fromMap(Map<String, dynamic> map) {
    return WorkExperience(
      id: map["id"] ?? "",
      jobTitle: map["jobTitle"] ?? "",
      companyName: map["companyName"] ?? "",
      location: map["location"] ?? "",
      employmentType: map["employmentType"] ?? "",
      startDate: map["startDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["startDate"])
          : null,
      endDate: map["endDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["endDate"])
          : null,
      currentlyWorking: map["currentlyWorking"] ?? false,
      description: map["description"] ?? "",
    );
  }
}
