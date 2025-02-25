import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime selectedDate = DateTime.now(); // Varsayılan olarak bugünü seç
  List<Map<String, dynamic>> appointments = [
    {"date": DateTime(2024, 2, 24), "time": "10:00", "name": "User1"},
    {"date": DateTime(2024, 2, 25), "time": "10:20", "name": "User2"},
    {"date": DateTime(2024, 2, 25), "time": "10:40", "name": "User3"},
    {"date": DateTime(2024, 2, 25), "time": "11:20", "name": "User4"},
    {"date": DateTime(2024, 2, 18), "time": "11:40", "name": "User5"},
    {"date": DateTime(2024, 2, 25), "time": "14:20", "name": "User6"},
    {"date": DateTime(2024, 2, 20), "time": "14:40", "name": "User7"},
    {"date": DateTime(2024, 2, 25), "time": "17:00", "name": "User8"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Randevu Takvimi"), ),
      body: Column(
        children: [
          _buildDateSelector(), // Tarih seçim butonları
          Expanded(child: _buildAppointmentTable()), // Randevu tablosu
        ],
      ),
    );
  }

  // Üstteki tarih seçim bileşeni
  Widget _buildDateSelector() {
    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(7, (index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              width: 50,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: selectedDate.day == date.day ? AppColors.color3 : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E', 'tr').format(date)),
                  Text("${date.day}"),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Randevu Tablosu
  Widget _buildAppointmentTable() {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        final hour = 10 + index;
        List<Map<String, dynamic>> matchingAppointments = [];

        for (var a in appointments) {
          if (a['date'].day == selectedDate.day) {
            final timeParts = a['time'].split(':');
            final appointmentHour = int.tryParse(timeParts[0]) ?? -1;
            final appointmentMinutes = int.tryParse(timeParts[1]) ?? -1;

            if (appointmentHour == hour ||
                (appointmentHour == hour - 1 && appointmentMinutes >= 59)) {
              matchingAppointments.add(a);
            }
          }
        }

        return Column(
          children: [
            //  Saat başlığı
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color.fromARGB(255, 243, 243, 243),
              width: double.infinity,
              child: Text("$hour:00",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // O saat aralığına ait randevular
            ...matchingAppointments.map((appointment) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.color3,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("${appointment['time']} - ${appointment['name']}",
                    style: TextStyle(fontSize: 16)),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
