class Client {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a Client object from a JSON map
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  // Method to convert a Client object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Optional: Method to create a copy of the Client object with some fields updated
  Client copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Client{id: $id, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}