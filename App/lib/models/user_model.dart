class User {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final List<String> friendIds;
  final DateTime createdDate;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    required this.friendIds,
    required this.createdDate,
  });

  // Convert JSON to User object (for backend)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      friendIds: List<String>.from(json['friendIds'] as List),
      createdDate: DateTime.parse(json['createdDate'] as String),
    );
  }

  // Convert User to JSON (for backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'friendIds': friendIds,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}