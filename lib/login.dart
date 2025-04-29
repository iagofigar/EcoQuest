import 'package:ecoquest/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as app_provider;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;

  Future<void> _login() async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed('/loading');

      // Save user data in UserProvider
      final user = response.user;
      // log
      if (user != null) {
        final userDataResponse = await _supabaseClient
            .from('users')
            .select('*')
            .eq('id', user.id)
            .single();
        final userData = userDataResponse;
        app_provider.Provider.of<UserProvider>(context, listen: false).setUser(
          id: userData['id'],
          username: userData['username'] ?? 'Unknown',
          email: userData['email'] ?? '',
          experience: userData['experience']?.toDouble() ?? 0.0,
          level: userData['level'] ?? 1,
          credits: userData['credits'] ?? 0,
        );
      }

      Navigator.of(context).pushReplacementNamed('/loading');
    } catch (error) {
      if ((error as AuthException).message != 'Email not confirmed') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign in error")),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/verification');
      }
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Increased vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Increased vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}