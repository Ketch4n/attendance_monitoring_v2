class AdminModel {
  final String admin_uid;
  final String email;
  final String name;
  final String user_id;
  final String role;
  final String id;
  final String code;
  final String section_name;

  AdminModel({
    required this.admin_uid,
    required this.email,
    required this.name,
    required this.user_id,
    required this.role,
    required this.id,
    required this.code,
    required this.section_name,
  });

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'admin_uid': admin_uid,
        'email': email,
        'name': name,
        'user_id': user_id,
        'role': role,
        'id': id,
        'code': code,
        'section_name': section_name,
      };

  static AdminModel fromJson(Map<String, dynamic> json) => AdminModel(
        // id: json['id'],
        admin_uid: json['admin_uid'],
        email: json['email'],
        name: json['name'],
        user_id: json['user_id'],
        role: json['role'],
        id: json['id'],
        code: json['code'],
        section_name: json['section_name'],
      );
}
