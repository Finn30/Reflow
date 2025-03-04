class Users {
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phone;
  String? gender;
  String? createdAt;
  String? pictUrl;
  String? age;

  Users({
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.gender,
    this.createdAt,
    this.pictUrl,
    this.age,
  });

  Users.fromMap(Map<String, dynamic> data) {
    fullName = data['fullName'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    password = data['password'];
    phone = data['phone'];
    gender = data['gender'];
    createdAt = data['createdAt'];
    pictUrl = data['pictUrl'];
    age = data['age'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'createdAt': createdAt,
      'pictUrl': pictUrl,
      'age': age,
    };
  }
}
