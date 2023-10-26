// ignore_for_file: non_constant_identifier_names

class ClassModel {
  int id;
  int section_id;
  String section_name;
  String code;
  int admin_id;
  int student_id;

  ClassModel({
    required this.id,
    required this.section_id,
    required this.section_name,
    required this.code,
    required this.admin_id,
    required this.student_id,

  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['class_id'],
      section_id: json['section_id'],
      section_name: json['section_name'],
      code: json['code'],
      admin_id: json['admin_id'],
      student_id: json['student_id']
    );
  }
}

class RoomModel {
  int id;
  int establishment_id;
  String establishment_name;
  String code;
  String location;
  int creator_id;
  int student_id;

  RoomModel({
    required this.id,
    required this.establishment_id,
    required this.establishment_name,
    required this.code,
    required this.location,
    required this.creator_id,
    required this.student_id,

  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['room_id'],
      establishment_id: json['establishment_id'],
      establishment_name: json['establishment_name'],
      code: json['code'],
      location: json['location'],
      creator_id: json['creator_id'],
      student_id: json['student_id']
    );
  }
}
