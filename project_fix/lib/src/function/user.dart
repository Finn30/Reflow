class Users {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phone;
  String? gender;
  String? createdAt;
  String? pictUrl;

  Users({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.gender,
    this.createdAt,
    this.pictUrl,
  });

  Users.fromMap(Map<String, dynamic> data) {
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    password = data['password'];
    phone = data['phone'];
    gender = data['gender'];
    createdAt = data['createdAt'];
    pictUrl = data['pictUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'createdAt': createdAt,
      'pictUrl': pictUrl,
    };
  }
}