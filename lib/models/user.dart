// lib/models/user.dart

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    this.isAdmin = false,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'isAdmin': isAdmin,
    };
  }

  // Create from Firestore document
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      address: map['address'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  // CopyWith method for immutability
  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    bool? isAdmin,
    String? address,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
