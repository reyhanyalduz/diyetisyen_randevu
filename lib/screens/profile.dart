import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ad: ${user.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('E-posta: ${user.email}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            if (user is Client) ...[
              Text('Boy: ${(user as Client).height} cm', style: TextStyle(fontSize: 20)),
              Text('Kilo: ${(user as Client).weight} kg', style: TextStyle(fontSize: 20)),
            ] else if (user is Dietitian) ...[
              Text('Uzmanlık Alanı: ${(user as Dietitian).specialty}', style: TextStyle(fontSize: 20)),
            ],
          ],
        ),
      ),
    );
  }
}
