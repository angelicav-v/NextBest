class Friend {
  final String id;
  final String name;
  final String? profileImage;
  final DateTime addedDate;

  Friend({
    required this.id,
    required this.name,
    this.profileImage,
    required this.addedDate,
  });

  // Convert JSON to Friend object (for backend)
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      addedDate: DateTime.parse(json['addedDate'] as String),
    );
  }

  // Convert Friend to JSON (for backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'addedDate': addedDate.toIso8601String(),
    };
  }
}