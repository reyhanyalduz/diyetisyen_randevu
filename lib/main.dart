import 'package:diyetisyen_randevu/screens/calendar_dietitian_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/user.dart';
import 'screens/calendar_client_screen.dart';
import 'screens/profile.dart';

final User currentUser = Dietitian(
    name: 'UserAdi', email: 'user@example.com', specialty: '..');
final User currentUser2 = Client(
  name: 'UserAdi',
  email: 'user@example.com',
  height: 100,
  weight: 10.0,
);
final User currentUser3 = Dietitian(
    name: 'UserAdi', email: 'user@example.com', specialty: '..');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr', null); // Türkçe formatı yükle
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diyetisyen Randevu',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(
          user: currentUser),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Seçilen sayfa indeksi
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(ProfileScreen(user: widget.user));
    _pages.add(AppointmentPage());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Seçili sayfa güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Seçili sayfayı göster
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Takvim',
          ),
        ],
        currentIndex: _selectedIndex, // Seçili sayfa
        onTap: _onItemTapped, // Tıklama olayını yönet
      ),
    );
  }
}
