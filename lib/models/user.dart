// lib/models/user.dart

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? address;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.address,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Create from Firestore document
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }

  // CopyWith method for immutability
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? address,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
}
