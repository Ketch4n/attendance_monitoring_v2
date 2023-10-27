class ClassmateModel {
  final String id;
  final String email;
  final String name;
  final String student_id;
  final String section_id;
  final String admin_id;

  ClassmateModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.student_id,
      required this.section_id,
      required this.admin_id,
      });

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'id': id,
        'email': email,
        'name': name,
        'student_id': student_id,
        'section_id': section_id,
        'admin_id' : admin_id,

      };

  static ClassmateModel fromJson(Map<String, dynamic> json) => ClassmateModel(
      // id: json['id'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
      student_id: json['student_id'],
      section_id: json['section_id'],
      admin_id: json['admin_id'],
      );
}
