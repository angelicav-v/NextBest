import 'package:flutter/material.dart';

/// Reusable share dialog for sharing recommendations with friends
class ShareDialog extends StatefulWidget {
  final String placeName;
  final String category; // Food, Activity, Entertainment
  final VoidCallback? onShareWithFriends;

  const ShareDialog({
    super.key,
    required this.placeName,
    required this.category,
    this.onShareWithFriends,
  });

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  late int _selectedTabIndex;
  Set<String> _selectedFriends = {};
  TextEditingController _messageController = TextEditingController();

  // Mock friends list
  final List<Map<String, dynamic>> _friendsList = [
    {'name': 'Sarah', 'status': 'Online'},
    {'name': 'Mike', 'status': 'Online'},
    {'name': 'Jessica', 'status': 'Offline'},
    {'name': 'David', 'status': 'Online'},
    {'name': 'Emily', 'status': 'Online'},
    {'name': 'Alex', 'status': 'Online'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = 0; // Start with Friends tab
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _toggleFriendSelection(String friendName) {
    setState(() {
      if (_selectedFriends.contains(friendName)) {
        _selectedFriends.remove(friendName);
      } else {
        _selectedFriends.add(friendName);
      }
    });
  }

  void _shareWithSelectedFriends() {
    if (_selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one friend')),
      );
      return;
    }

    // Callback to parent with selected friends and message
    widget.onShareWithFriends?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shared ${widget.placeName} with ${_selectedFriends.length} friend${_selectedFriends.length == 1 ? '' : 's'}'),
      ),
    );

    Navigator.pop(context);
  }

  void _copyLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link to ${widget.placeName} copied to clipboard!')),
    );
  }

  void _shareViaText() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening text message app...')),
    );
  }

  void _shareViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening email app...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D1B4E), Color(0xFF0F0020)],
          ),
          border: Border.all(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share Your Pick',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.placeName,
                        style: const TextStyle(
                          color: Color(0xFFE12AFB),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Tab buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: _selectedTabIndex == 0
                              ? const LinearGradient(colors: [Color(0xFF9D00FF), Color(0xFFB300FF)])
                              : null,
                          color: _selectedTabIndex == 0 ? null : Colors.transparent,
                          border: Border.all(
                            color: _selectedTabIndex == 0
                                ? Colors.transparent
                                : const Color(0xFFAD46FF).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.people_outline, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Friends',
                              style: TextStyle(
                                color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFFDAB2FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: _selectedTabIndex == 1
                              ? const LinearGradient(colors: [Color(0xFF9D00FF), Color(0xFFB300FF)])
                              : null,
                          color: _selectedTabIndex == 1 ? null : Colors.transparent,
                          border: Border.all(
                            color: _selectedTabIndex == 1
                                ? Colors.transparent
                                : const Color(0xFFAD46FF).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'External',
                              style: TextStyle(
                                color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFFDAB2FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFAD46FF), height: 1),

            // Tab content
            if (_selectedTabIndex == 0)
              _buildFriendsTab()
            else
              _buildExternalTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search friends...',
              hintStyle: const TextStyle(color: Color(0xFFDAB2FF), fontSize: 12),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFDAB2FF), size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFAD46FF), width: 1.07),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFAD46FF), width: 1.5),
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Friends',
              style: TextStyle(
                color: Color(0xFFDAB2FF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _friendsList.length,
              itemBuilder: (context, index) {
                final friend = _friendsList[index];
                final isSelected = _selectedFriends.contains(friend['name']);

                return GestureDetector(
                  onTap: () => _toggleFriendSelection(friend['name']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? const Color(0xFF9D00FF).withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE12AFB)
                            : const Color(0xFFAD46FF).withOpacity(0.3),
                        width: isSelected ? 1.5 : 1.07,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              friend['name'][0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                friend['status'],
                                style: TextStyle(
                                  color: friend['status'] == 'Online'
                                      ? const Color(0xFF00C950)
                                      : Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Color(0xFFE12AFB), size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Message field
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a message (optional)',
                style: TextStyle(
                  color: Color(0xFFDAB2FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What do you think about this place?',
                  hintStyle: const TextStyle(color: Color(0xFFDAB2FF), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFAD46FF), width: 1.07),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFAD46FF), width: 1.5),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        // Share button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _selectedFriends.isEmpty
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF9D00FF).withOpacity(0.3),
                          const Color(0xFFB300FF).withOpacity(0.3),
                        ],
                      )
                    : const LinearGradient(colors: [Color(0xFF9D00FF), Color(0xFFB300FF)]),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _selectedFriends.isEmpty ? null : _shareWithSelectedFriends,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Share with ${_selectedFriends.length} Friend${_selectedFriends.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExternalTab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Share via',
            style: const TextStyle(
              color: Color(0xFFDAB2FF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: [
              _buildExternalOption(
                icon: Icons.link,
                label: 'Copy Link',
                onTap: _copyLink,
              ),
              _buildExternalOption(
                icon: Icons.message,
                label: 'Text Message',
                onTap: _shareViaText,
              ),
              _buildExternalOption(
                icon: Icons.mail_outline,
                label: 'Email',
                onTap: _shareViaEmail,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
            ),
            child: Text(
              'Share ${widget.placeName} with anyone outside the app!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFDAB2FF),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExternalOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.3),
          border: Border.all(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFE12AFB), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}