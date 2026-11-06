class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String role; // 'student' or 'staff'
  final String department;
  final String campus;
  final String? profilePhotoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.department = 'Computer Science',
    this.campus = 'Kigali, Rwanda',
    this.profilePhotoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isStaff => role.toLowerCase() == 'staff' || role.toLowerCase() == 'admin';
  bool get isStudent => !isStaff;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role,
      'department': department,
      'campus': campus,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? 'Campus User',
      role: map['role'] as String? ?? 'student',
      department: map['department'] as String? ?? 'Computer Science',
      campus: map['campus'] as String? ?? 'Kigali, Rwanda',
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? role,
    String? department,
    String? campus,
    String? profilePhotoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      department: department ?? this.department,
      campus: campus ?? this.campus,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
