import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/diet_list_widget.dart';
import '../widgets/info_card_widget.dart';
import '../widgets/tag_section_widget.dart';

class ClientProfileScreen extends StatelessWidget {
  final User user;
  final User currentUser;

  ClientProfileScreen({required this.user, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 50),
                    ),
                    SizedBox(width: 10),
                    Text('${user.name}',
                        //${user.name}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoCard('Vücut Kitle İndeksi',
                        '${(user as Client).bmi.toStringAsFixed(2)}'),
                    InfoCard('Kilo', '${(user as Client).weight} kg'),
                    InfoCard('Boy', '${(user as Client).height} cm'),
                  ],
                ),
                SizedBox(height: 20),
                TagSection(context, 'Alerjiler', ['Gluten', 'Laktoz']),
                TagSection(context, 'Hastalıklar', ['Diyabet']),
                SizedBox(height: 20),
                //_buildTabSection(),
                SizedBox(height: 20),
                BuildDietList(),
              ],
            ),
          ),
        ));
  }



}