class ResumeModel {
  final String fullName;
  final String email;
  final String phone;
  final String city;
  final String linkedin;

  ResumeModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.linkedin,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'linkedin': linkedin,
    };
  }

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      linkedin: map['linkedin'] ?? '',
    );
  }
}
