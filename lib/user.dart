import 'package:ecoquest/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        debugPrint('No current user ID found.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await _supabase
          .from('friends')
          .select('*')
          .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId');

      final friendIds = <String>{};

      // Extract friend IDs
      for (final row in response) {
        if (row['user1_id'] != currentUserId) {
          friendIds.add(row['user1_id']);
        }
        if (row['user2_id'] != currentUserId) {
          friendIds.add(row['user2_id']);
        }
      }

      if (friendIds.isEmpty) {
        setState(() {
          _friends = [];
          _isLoading = false;
        });
        return;
      }

      // Fetch user details for all friend IDs
      final userResponse = await _supabase
          .from('users')
          .select('*')
          .in_('id', friendIds.toList());

      setState(() {
        _friends = List<Map<String, dynamic>>.from(userResponse);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Exception occurred while fetching friends: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = app_provider.Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'EcoQuest',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.username,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userProvider.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    // Progress Bar
                    SizedBox(
                      width: 150,
                      child: LinearProgressIndicator(
                        value: userProvider.experience,
                        backgroundColor: const Color(0xFFD6D6D6),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'lvl. ${userProvider.level}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/qrCode');
            },
            child: const Text('Show your QR code'),
          ),
          const SizedBox(height: 10),
          // Friends/Near Me Toggle
          ToggleButtons(
            isSelected: const [true, false],
            onPressed: (index) {},
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: Colors.blueAccent,
            color: Colors.black,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Friends"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Near me"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Friends List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _friends.isEmpty
                ? const Center(child: Text('No friends found.'))
                : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return FriendTile(
                  username: friend['username'],
                  email: friend['email'],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qrScanner');
        },
        child: const Icon(Icons.person_add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final String username;
  final String email;

  const FriendTile({
    required this.username,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: 40, color: Colors.grey),
      ),
      title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(email),
      onTap: () {},
    );
  }
}