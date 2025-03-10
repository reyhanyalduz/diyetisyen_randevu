import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../main.dart';
import '../models/user.dart';
import '../screens/calendar_dietitian_screen.dart';
import '../services/appointment_service.dart';
import '../utils/constants.dart';

class CalendarScreen extends StatefulWidget {
  final AppUser currentUser;

  CalendarScreen({required this.currentUser});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<String>> _events;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  final AppointmentService _appointmentService = AppointmentService();
  TimeOfDay _selectedTime =
  TimeOfDay(hour: 10, minute: 0); // Varsayılan saat 10:00

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return;
    }

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _bookAppointment() {
    DateTime appointmentTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    DateTime now = DateTime.now();

    // Eğer seçilen gün bugünse ve seçilen saat geçmişteyse randevuyu engelle
    if (_selectedDay.year == now.year &&
        _selectedDay.month == now.month &&
        _selectedDay.day == now.day &&
        appointmentTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçmiş bir saate randevu alınamaz.')),
      );
      return;
    }

    if (_appointmentService.isTimeAvailable(appointmentTime)) {
      _appointmentService.bookAppointment(appointmentTime);
      setState(() {
        _events[_selectedDay] = _events[_selectedDay] ?? [];
        _events[_selectedDay]!.add(appointmentTime.toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu zaman dilimi uygun değil.')),
      );
    }
  }

  void _onDateSelected(DateTime date) {
    // Seçilen tarih ile ilgili işlemler
    print('Selected date: $date');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Takvim')),
      body: (widget.currentUser.userType == UserType.client)
          ? SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: (day) => _events[day] ?? [],
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (day.isBefore(DateTime.now())) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value:
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  items: [
                    for (int hour = 10; hour <= 17; hour++)
                      if (hour != 12) // 12'yi atla
                        ...[
                          DropdownMenuItem<String>(
                            value: '${hour.toString().padLeft(2, '0')}:00',
                            child: Text(
                                '${hour.toString().padLeft(2, '0')}:00'),
                          ),
                          DropdownMenuItem<String>(
                            value: '${hour.toString().padLeft(2, '0')}:20',
                            child: Text(
                                '${hour.toString().padLeft(2, '0')}:20'),
                          ),
                          DropdownMenuItem<String>(
                            value: '${hour.toString().padLeft(2, '0')}:40',
                            child: Text(
                                '${hour.toString().padLeft(2, '0')}:40'),
                          ),
                        ],
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      List<String> parts = newValue.split(':');
                      int hour = int.parse(parts[0]);
                      int minute = int.parse(parts[1]);
                      setState(() {
                        _selectedTime =
                            TimeOfDay(hour: hour, minute: minute);
                      });
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _bookAppointment,
                    child: Text('Randevu Al',style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all(AppColors.color1),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Randevular',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true,
              physics:
              NeverScrollableScrollPhysics(),
              children: (_events.values
                  .expand((events) => events)
                  .map((event) => DateTime.parse(
                  event)) // String ifadeleri DateTime'a çevir
                  .toList()
                ..sort(
                        (a, b) => a.compareTo(b))) // Tarihe göre sırala
                  .map((date) => Container(
                margin: EdgeInsets.symmetric(
                    vertical: 4.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.color1),
                ),
                child: Text(
                  date.toString(), // Tarihi tekrar String olarak yazdır
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      )
          : DietitianAppointmentPage(),
    );
  }
}
