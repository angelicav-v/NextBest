import 'package:flutter_test/flutter_test.dart';
import 'package:nextbest/models/user_model.dart';

/// Unit Tests for User Model
/// Team 3 Member: Angelica Velez Vega
/// Component: User Model

void main() {
  group('User Model Tests', () {
    
    // ============ CONSTRUCTOR TESTS ============
    test('User Constructor - Valid Input Creates Valid User Object', () {

      // Arrange
      final userId = 'testuserId1';
      final username = 'violetwu';
      final email = 'violet@example.com';
      final profileImage = 'https://example.com/profile.jpg';
      final List<String> friendIds = ['friend1', 'friend2'];
      final createdDate = DateTime(2025, 1, 1);
      
      // Act
      final user = User(
        id: userId,
        username: username,
        email: email,
        profileImage: profileImage,
        friendIds: friendIds,
        createdDate: createdDate,
      );
      
      // Assert
      expect(user.id, equals(userId));
      expect(user.username, equals(username));
      expect(user.email, equals(email));
      expect(user.profileImage, equals(profileImage));
      expect(user.friendIds, equals(friendIds));
      expect(user.createdDate, equals(createdDate));
    });

    test('User Constructor - No Profile Image (Null Value)', () {

      // Arrange
      final userId = 'testuserId2';
      final username = 'justinbrady';
      final email = 'justin@example.com';
      final List<String> friendIds = [];
      final createdDate = DateTime(2025, 1, 15);
      
      // Act
      final user = User(
        id: userId,
        username: username,
        email: email,
        profileImage: null,
        friendIds: friendIds,
        createdDate: createdDate,
      );
      
      // Assert
      expect(user.profileImage, isNull);
      expect(user.id, isNotEmpty);
      expect(user.username, isNotEmpty);
    });

    test('User Constructor - Empty Friend List', () {
      // Arrange & Act
      final user = User(
        id: 'user789',
        username: 'newuser',
        email: 'new@example.com',
        profileImage: null,
        friendIds: [],
        createdDate: DateTime.now(),
      );
      
      // Assert
      expect(user.friendIds, isEmpty);
      expect(user.friendIds.length, equals(0));
    });

    // ============ FROM JSON TESTS ============

    test('User.fromJson - Valid JSON Converts to User Object', () {
      // Arrange
      final json = {
        'id': 'user999',
        'username': 'testuser',
        'email': 'test@example.com',
        'profileImage': 'https://example.com/test.jpg',
        'friendIds': <String>['friend1', 'friend2', 'friend3'],
        'createdDate': '2025-01-10T10:30:00.000Z',
      };
      
      // Act
      final user = User.fromJson(json);
      
      // Assert
      expect(user.id, equals('user999'));
      expect(user.username, equals('testuser'));
      expect(user.email, equals('test@example.com'));
      expect(user.profileImage, equals('https://example.com/test.jpg'));
      expect(user.friendIds.length, equals(3));
    });

    test('User.fromJson - Null Profile Image in JSON', () {
      // Arrange
      final json = {
        'id': 'user111',
        'username': 'noimage',
        'email': 'noimage@example.com',
        'profileImage': null,
        'friendIds': [],
        'createdDate': '2025-01-12T15:00:00.000Z',
      };
      
      // Act
      final user = User.fromJson(json);
      
      // Assert
      expect(user.profileImage, isNull);
      expect(user.id, equals('user111'));
    });

    test('User.fromJson - Empty Friend IDs List', () {
      // Arrange
      final json = {
        'id': 'user222',
        'username': 'nofriends',
        'email': 'alone@example.com',
        'profileImage': null,
        'friendIds': [],
        'createdDate': '2025-01-05T12:00:00.000Z',
      };
      
      // Act
      final user = User.fromJson(json);
      
      // Assert
      expect(user.friendIds, isEmpty);
    });

    // ============ TO JSON TESTS ============

    test('User.toJson - Converts User Object to JSON Dictionary', () {
      // Arrange
      final user = User(
        id: 'user333',
        username: 'jsontest',
        email: 'json@example.com',
        profileImage: 'https://example.com/json.jpg',
        friendIds: <String>['f1', 'f2'],
        createdDate: DateTime(2025, 1, 1),
      );
      
      // Act
      final json = user.toJson();
      
      // Assert
      expect(json['id'], equals('user333'));
      expect(json['username'], equals('jsontest'));
      expect(json['email'], equals('json@example.com'));
      expect(json['profileImage'], equals('https://example.com/json.jpg'));
      expect(json['friendIds'], equals(['f1', 'f2']));
      expect(json.containsKey('createdDate'), isTrue);
    });

    test('User.toJson - Null Profile Image Converts Correctly', () {
      // Arrange
      final user = User(
        id: 'user444',
        username: 'nullimage',
        email: 'null@example.com',
        profileImage: null,
        friendIds: [],
        createdDate: DateTime(2025, 1, 1),
      );
      
      // Act
      final json = user.toJson();
      
      // Assert
      expect(json['profileImage'], isNull);
      expect(json['id'], equals('user444'));
    });

    test('User.toJson - Date Converts to ISO 8601 Format', () {
      // Arrange
      final testDate = DateTime(2025, 1, 15, 10, 30, 45);
      final user = User(
        id: 'user555',
        username: 'datetest',
        email: 'date@example.com',
        profileImage: null,
        friendIds: [],
        createdDate: testDate,
      );
      
      // Act
      final json = user.toJson();
      
      // Assert
      expect(json['createdDate'], isA<String>());
      expect(json['createdDate'], contains('2025-01-15'));
    });

    // ============ ROUND TRIP TEST (toJson -> fromJson) ============

    test('User Round Trip - toJson then fromJson Preserves Data', () {
      // Arrange
      final originalUser = User(
        id: 'user666',
        username: 'roundtrip',
        email: 'roundtrip@example.com',
        profileImage: 'https://example.com/roundtrip.jpg',
        friendIds: <String>['f1', 'f2', 'f3'],
        createdDate: DateTime(2025, 1, 20),
      );
      
      // Act
      final json = originalUser.toJson();
      final reconstructedUser = User.fromJson(json);
      
      // Assert
      expect(reconstructedUser.id, equals(originalUser.id));
      expect(reconstructedUser.username, equals(originalUser.username));
      expect(reconstructedUser.email, equals(originalUser.email));
      expect(reconstructedUser.profileImage, equals(originalUser.profileImage));
      expect(reconstructedUser.friendIds, equals(originalUser.friendIds));
    });

  });
}