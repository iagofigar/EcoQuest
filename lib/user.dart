import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Subtitle',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    // Progress Bar
                    SizedBox(
                      width: 150,
                      child: LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Color(0xFFD6D6D6),
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'lvl. 3',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
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
            child: ListView(
              children: const [
                FriendTile(
                  username: 'DcMod0199',
                  message: 'Join vc!',
                  avatar: Icons.discord,
                ),
                FriendTile(
                  username: 'EvilBasicJoe',
                  message: 'Not really evil though!',
                  avatar: Icons.android,
                ),
                FriendTile(
                  username: 'DaveTheMagical&WiseCheeseWizard',
                  message: '🧀',
                  avatar: Icons.person,
                ),
              ],
            ),
          ),
          // Floating Add Friend Button
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
  final String message;
  final IconData avatar;

  const FriendTile({
    required this.username,
    required this.message,
    required this.avatar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(avatar, color: Colors.black),
      ),
      title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      onTap: () {},
    );
  }
}