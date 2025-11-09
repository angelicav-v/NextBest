import '../models/friend_model.dart';

class FriendService {
  // This will connect to your backend API
  // For now, these are placeholders

  /// Generate a friend invite link
  static String generateFriendLink(String userId) {
    // TODO: Replace with actual backend URL
    return 'nextbest.app/friend/$userId';
  }

  /// Copy friend link to clipboard
  static Future<void> copyFriendLink(String userId) async {
    // TODO: Implement clipboard functionality
    // Use: import 'package:flutter/services.dart';
    // Clipboard.setData(ClipboardData(text: generateFriendLink(userId)));
    print('Link copied: ${generateFriendLink(userId)}');
  }

  /// Add friend by user ID
  static Future<bool> addFriend(String currentUserId, String friendUserId) async {
    try {
      // TODO: Implement actual API call
      // POST /api/friends/add
      print('Adding friend: $friendUserId to user: $currentUserId');
      return true;
    } catch (e) {
      print('Error adding friend: $e');
      return false;
    }
  }

  /// Get user's friend list
  static Future<List<Friend>> getFriends(String userId) async {
    try {
      // TODO: Implement actual API call
      // GET /api/friends/$userId
      print('Fetching friends for user: $userId');
      return [];
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  /// Remove friend
  static Future<bool> removeFriend(String currentUserId, String friendUserId) async {
    try {
      // TODO: Implement actual API call
      // DELETE /api/friends/$friendUserId
      print('Removing friend: $friendUserId from user: $currentUserId');
      return true;
    } catch (e) {
      print('Error removing friend: $e');
      return false;
    }
  }

  /// Search for users to add
  static Future<List<Friend>> searchUsers(String query) async {
    try {
      // TODO: Implement actual API call
      // GET /api/users/search?q=$query
      print('Searching for users: $query');
      return [];
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }
}