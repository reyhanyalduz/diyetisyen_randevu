import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/constants.dart';

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
                    _buildInfoCardx('Vücut Kitle İndeksi',
                        '${(user as Client).bmi.toStringAsFixed(2)}'),
                    _buildInfoCardx('Kilo', '${(user as Client).weight} kg'),
                    _buildInfoCardx('Boy', '${(user as Client).height} cm'),
                  ],
                ),


                SizedBox(height: 20),
                _buildTagSection(context, 'Alerjiler', ['Gluten', 'Laktoz']),
                _buildTagSection(context, 'Hastalıklar', ['Diyabet']),
                SizedBox(height: 20),
                //_buildTabSection(),
                SizedBox(height: 20),
                _buildDietList(),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoCardx(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 12)),
          Text(' : '),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTagSection(
      BuildContext context, String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8, // Chip'ler arasındaki yatay boşluğu belirler
          runSpacing: 8, // Satırlar arasındaki boşluğu belirler
          children: [
            ...tags.map(
                  (tag) => Chip(
                label: Text(tag),
                deleteIcon: Icon(Icons.close, size: 16),
                onDeleted: () {
                  // Silme işlemi burada yapılacak
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Kenarları yumuşat
                  side: BorderSide(color: AppColors.color1), // Kenar çizgisi ekle
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Yeni alerji ekleme işlemi burada yapılacak
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Yeni Alerji Ekle',
                      ),
                      content: TextField(
                        decoration: InputDecoration(hintText: "Alerji Adı"),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Ekle'),
                          onPressed: () {
                            // Alerjiyi ekleme işlemi burada yapılacak
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('İptal'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Chip(
                label: Icon(Icons.add, size: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.color1),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDietList() {
    List<String> meals = [
      'Kahvaltı',
      'Ara Öğün',
      'Öğle Yemeği',
      'Akşam Yemeği'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Diyet Listesi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Column(
          children: meals
              .map((meal) => Card(
            color: AppColors.color3,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(meal, style: TextStyle(fontSize: 18)),
            ),
          ))
              .toList(),
        ),
      ],
    );
  }
}
