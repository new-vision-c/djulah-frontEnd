class User {
  String? id;
  String? name;
  String? phone;
  String? token;
  String? refreshToken;

//<editor-fold desc="Data Methods">
  User({
    this.id,
    this.name,
    this.phone,
    this.token,
    this.refreshToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          token == other.token &&
          refreshToken == other.refreshToken);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      token.hashCode ^
      refreshToken.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' id: $id,' +
        ' name: $name,' +
        ' phone: $phone,' +
        ' token: $token,' +
        ' refreshToken: $refreshToken,' +
        '}';
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    List<Role>? roles,
    String? token,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'phone': this.phone,
      'token': this.token,
      'refreshToken': this.refreshToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      token: map['token'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      token: json["token"],
      refreshToken: json["refreshToken"],
    );
  }
//

//</editor-fold>
}

class Role{
  final String? id;
  final String? name;

  Role({
     this.id,
     this.name
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["id"],
      name: json["name"],
    );
  }
}