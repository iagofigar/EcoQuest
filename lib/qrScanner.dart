import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:ecoquest/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  Barcode? result;
  MobileScannerController controller = MobileScannerController();
  bool isDetecting = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.stop();
    }
    controller.start();
  }

  void addFriend(String scannedValue) async {
    final currentUserId = app_provider.Provider.of<UserProvider>(context, listen: false).id;

    if (currentUserId == null) {
      _showPopup('User is not logged in.');
      return;
    }

    if (currentUserId == scannedValue) {
      _showPopup('Cannot add yourself as a friend!');
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('friends')
          .select()
          .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
          .or('user1_id.eq.$scannedValue,user2_id.eq.$scannedValue');

      if (response != null && response.isNotEmpty) {
        _showPopup('You are already friends with this user!');
        return;
      }

      final uuid = const Uuid().v4();

      await supabase.from('friends').insert({
        'user1_id': currentUserId,
        'user2_id': scannedValue,
      });

      _showPopup('Friend added successfully!');
    } catch (e) {
      _showPopup('Error adding friend: $e');
    }
  }

  void _showPopup(String message) {
    Navigator.pushReplacementNamed(context, '/user');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(fontSize: 18), // Set a larger font size
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aim at your friend\'s QR code!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4.0),
                ),
                child: MobileScanner(
                  controller: controller,
                  onDetect: (barcodeCapture) {
                    final scannedValue = barcodeCapture.barcodes.first.rawValue;
                    if (scannedValue != null && isDetecting) {
                      isDetecting = false; // Prevent multiple scans
                      addFriend(scannedValue); // Call addFriend with the scanned value
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/rewards');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/map');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}