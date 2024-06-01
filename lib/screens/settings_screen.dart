import 'package:flutter/material.dart';
import '../styles/style.dart'; // Adjust the import according to your file structure

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Color(0xFF232323),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add your settings options here
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.white),
              title: Text('Account', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle account tap
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.white),
              title: Text('Notifications', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle notifications tap
              },
            ),
            ListTile(
              leading: Icon(Icons.security, color: Colors.white),
              title: Text('Privacy', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle privacy tap
              },
            ),
            // Add more settings options here
          ],
        ),
      ),
    );
  }
}
