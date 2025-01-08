class UserModel {
  final String name;
  final String profilepic;
  final String uid;
  final bool isAuthenticated;
  final String email;
  final String role;
  UserModel({
    required this.name,
    required this.profilepic,
    required this.uid,
    required this.isAuthenticated,
    required this.email,
    required this.role,
  });

  UserModel copyWith({
    String? name,
    String? profilepic,
    String? uid,
    bool? isAuthenticated,
    String? email,
    String? role,
  }) {
    return UserModel(
        name: name ?? this.name,
        profilepic: profilepic ?? this.profilepic,
        uid: uid ?? this.uid,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        email: email ?? this.email,
        role: role ?? this.role
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'profilepic': profilepic});
    result.addAll({'uid': uid});
    result.addAll({'isAuthenticated': isAuthenticated});
    result.addAll({'email': email});
    result.addAll({'role': role});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        profilepic: map['profilepic'] ?? '',
        uid: map['uid'] ?? '',
        isAuthenticated: map['isAuthenticated'] ?? false,
        email: map['email'] ?? '',
        role:  map['role'] ?? ''
    );
  }
}