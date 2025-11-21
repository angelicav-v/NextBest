import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3C0366), // purple at top (0%)
            Color(0xFF000000), // black in middle (50%)
            Color(0xFF4B004F), // purple at bottom (100%)
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class FriendVotesScreen extends StatefulWidget {
  const FriendVotesScreen({super.key});

  @override
  State<FriendVotesScreen> createState() => _FriendVotesScreenState();
}

class _FriendVotesScreenState extends State<FriendVotesScreen> {
  int _selectedTabIndex = 0;
  
  // Track user votes: Map of voteId to vote type ('yes' or 'no')
  final Map<int, String> _userVoteMap = {};
  
  // Mock data for received votes
  final List<Map<String, dynamic>> receivedVotes = [
    {
      'id': 1,
      'friendName': 'Sarah',
      'friendAvatar': '👩',
      'quote': '"This place has the best local produce! Who wants to check it out this Saturday?"',
      'location': 'Main Street Farmers Market',
      'category': 'Activities',
      'categoryColor': Color(0xFF00BCD4),
      'distance': '0.4 mi',
      'rating': 4.8,
      'yesCount': 12,
      'noCount': 3,
      'yesPercentage': 80,
      'userVoted': false,
      'userVote': null,
    },
    {
      'id': 2,
      'friendName': 'Mike',
      'friendAvatar': '👨',
      'quote': '"Perfect spot for a Sunday picnic!"',
      'location': 'Luetta Moore Park',
      'category': 'Activities',
      'categoryColor': Color(0xFF00BCD4),
      'distance': '2.1 mi',
      'rating': 4.9,
      'yesCount': 8,
      'noCount': 2,
      'yesPercentage': 80,
      'userVoted': false,
      'userVote': null,
    },
  ];

  // Mock data for my votes
  final List<Map<String, dynamic>> myVotes = [
    {
      'id': 1,
      'locationName': 'Dingus Magees',
      'emoji': '🍔',
      'quote': '"Thinking about trying this place for dinner tonight!"',
      'category': 'Food',
      'categoryColor': Color(0xFFFF9500),
      'status': 'Active',
      'statusColor': Color(0xFF00C950),
      'distance': '0.8 mi',
      'rating': 4.6,
      'sharedCount': 12,
      'yesCount': 8,
      'noCount': 2,
      'yesPercentage': 80,
    },
    {
      'id': 2,
      'locationName': 'Georgia Southern Botanical Garden',
      'emoji': '🌸',
      'quote': '"Perfect spot for weekend photos!"',
      'category': 'Activities',
      'categoryColor': Color(0xFF00BCD4),
      'status': 'Closed',
      'statusColor': Color(0xFFE53935),
      'distance': '2.1 mi',
      'rating': 4.9,
      'sharedCount': 20,
      'yesCount': 17,
      'noCount': 3,
      'yesPercentage': 85,
    },
    {
      'id': 3,
      'locationName': "Clyde's Theatre Pub",
      'emoji': '🎬',
      'quote': '"Anyone want to catch a movie this weekend?"',
      'category': 'Entertainment',
      'categoryColor': Color(0xFF00BCD4),
      'status': 'Active',
      'statusColor': Color(0xFF00C950),
      'distance': '0.3 mi',
      'rating': 4.7,
      'sharedCount': 15,
      'yesCount': 6,
      'noCount': 1,
      'yesPercentage': 86,
    },
  ];

  void _showDeleteToast(String locationName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Removed "$locationName" from your votes'),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                          
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.5, 1.0],
                            colors: const [
                              Color(0xFF00D3F2),
                              Color(0xFFC27AFF),
                              Color(0xFFED6AFF),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Friend Votes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: _selectedTabIndex == 0
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFE12AFB),
                                      Color(0xFFC800DE),
                                    ],
                                  )
                                : null,
                            color: _selectedTabIndex == 0
                                ? null
                                : Colors.black.withOpacity(0.3),
                            border: Border.all(
                              color: const Color(0xFFAD46FF).withOpacity(0.3),
                              width: 1.07,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Received',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: _selectedTabIndex == 1
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFE12AFB),
                                      Color(0xFFC800DE),
                                    ],
                                  )
                                : null,
                            color: _selectedTabIndex == 1
                                ? null
                                : Colors.black.withOpacity(0.3),
                            border: Border.all(
                              color: const Color(0xFFAD46FF).withOpacity(0.3),
                              width: 1.07,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'My Votes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildReceivedVotesContent()
                    : _buildMyVotesContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedVotesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...receivedVotes.map((vote) => _buildReceivedVoteCard(vote)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildReceivedVoteCard(Map<String, dynamic> vote) {
    final userVote = _userVoteMap[vote['id']];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF000000).withOpacity(0.4),
        border: Border.all(
          color: const Color(0xFFAD46FF).withOpacity(0.3),
          width: 1.07,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Friend header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE12AFB), Color(0xFFD946EF)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      vote['friendAvatar'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vote['friendName']} created a vote',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quote
            Text(
              vote['quote'],
              style: TextStyle(
                color: const Color(0xFFDAB2FF).withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Location card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF59168B),
                    Color(0xFF721378),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFC27AFF).withOpacity(0.2),
                  width: 1.07,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vote['location'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: vote['categoryColor'].withOpacity(0.2),
                          border: Border.all(
                            color: vote['categoryColor'].withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          vote['category'],
                          style: TextStyle(
                            color: vote['categoryColor'],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFE12AFB),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vote['distance'],
                            style: const TextStyle(
                              color: Color(0xFFDAB2FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vote['rating']}',
                            style: const TextStyle(
                              color: Color(0xFFDAB2FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Vote percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${vote['yesPercentage']}% want to go',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${vote['yesCount'] + vote['noCount']} votes',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Yes/No counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFFE12AFB),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${vote['yesCount']} Yes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFFE53935),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${vote['noCount']} No',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // View Details button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFAD46FF).withOpacity(0.3),
                    width: 1.07,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'View Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Yes/No/Comment buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: userVote == 'yes'
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [
                                Color(0xFF00A63E),
                                Color(0xFF009966),
                              ],
                            )
                          : null,
                      border: Border.all(
                        color: userVote == 'yes'
                            ? const Color(0xFF00A63E)
                            : const Color(0xFF00C950),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (userVote == 'yes') {
                              _userVoteMap.remove(vote['id']);
                            } else {
                              _userVoteMap[vote['id']] = 'yes';
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_outlined,
                                color: userVote == 'yes'
                                    ? Colors.white
                                    : const Color(0xFF00C950),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Yes',
                                style: TextStyle(
                                  color: userVote == 'yes'
                                      ? Colors.white
                                      : const Color(0xFF00C950),
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
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: userVote == 'no'
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [
                                Color(0xFFE7000B),
                                Color(0xFFEC003F),
                              ],
                            )
                          : null,
                      border: Border.all(
                        color: userVote == 'no'
                            ? const Color(0xFFE7000B)
                            : const Color(0xFFE53935),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (userVote == 'no') {
                              _userVoteMap.remove(vote['id']);
                            } else {
                              _userVoteMap[vote['id']] = 'no';
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_down_outlined,
                                color: userVote == 'no'
                                    ? Colors.white
                                    : const Color(0xFFE53935),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'No',
                                style: TextStyle(
                                  color: userVote == 'no'
                                      ? Colors.white
                                      : const Color(0xFFE53935),
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
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFAD46FF).withOpacity(0.3),
                      width: 1.07,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: const Icon(
                        Icons.comment_outlined,
                        color: Color(0xFF00BCD4),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyVotesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...myVotes.map((vote) => _buildMyVoteCard(vote)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMyVoteCard(Map<String, dynamic> vote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF000000).withOpacity(0.4),
        border: Border.all(
          color: const Color(0xFFAD46FF).withOpacity(0.3),
          width: 1.07,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF59168B), Color(0xFF721378)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      vote['emoji'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vote['locationName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: vote['categoryColor'].withOpacity(0.2),
                        ),
                        child: Text(
                          vote['category'],
                          style: TextStyle(
                            color: vote['categoryColor'],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: vote['statusColor'].withOpacity(0.2),
                        border: Border.all(
                          color: vote['statusColor'].withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        vote['status'],
                        style: TextStyle(
                          color: vote['statusColor'],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showDeleteToast(vote['locationName']),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFFE53935).withOpacity(0.2),
                          border: Border.all(
                            color: const Color(0xFFE53935).withOpacity(0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFE53935),
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quote
            Text(
              vote['quote'],
              style: TextStyle(
                color: const Color(0xFFDAB2FF).withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Share count
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: Color(0xFF00BCD4),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Shared with ${vote['sharedCount']} friends',
                  style: const TextStyle(
                    color: Color(0xFF00BCD4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Vote percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      color: Color(0xFF00C950),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${vote['yesCount']} Yes',
                      style: const TextStyle(
                        color: Color(0xFF00C950),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${vote['yesPercentage']}% approval',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_down,
                      color: Color(0xFFE53935),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${vote['noCount']} No',
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Distance and rating
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFE12AFB),
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  vote['distance'],
                  style: const TextStyle(
                    color: Color(0xFFDAB2FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  '${vote['rating']}',
                  style: const TextStyle(
                    color: Color(0xFFDAB2FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}