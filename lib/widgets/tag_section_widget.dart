import 'package:flutter/material.dart';
import '../utils/constants.dart';

Widget TagSection(BuildContext context, String title,
    List<String> tags) {
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
                (tag) =>
                Chip(
                  label: Text(tag),
                  deleteIcon: Icon(Icons.close, size: 16),
                  onDeleted: () {
                    // Silme işlemi burada yapılacak
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // Kenarları yumuşat
                    side: BorderSide(
                        color: AppColors.color1), // Kenar çizgisi ekle
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