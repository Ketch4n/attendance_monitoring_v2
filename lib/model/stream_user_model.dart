// ignore_for_file: non_constant_identifier_names

class StreamUserModel {
  final String email;
  final String name;
  final String id_location;
  final String role;
  final String section;
  final String establishment;

  StreamUserModel({
    required this.email,
    required this.name,
    required this.id_location,
    required this.role,
    required this.section,
    required this.establishment,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'id_location': id_location,
        'role': role,
        'section': section,
        'establishment': establishment,
      };

  static StreamUserModel fromJson(Map<String, dynamic> json) => StreamUserModel(
        email: json['email'],
        name: json['name'],
        id_location: json['id_location'],
        role: json['role'],
        section: json['section'],
        establishment: json['establishment'],
      );
}
