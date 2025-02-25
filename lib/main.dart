import 'package:diyetisyen_randevu/screens/calendar_dietitian_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/user.dart';
import 'screens/calendar_client_screen.dart';
import 'screens/profile.dart';
import 'screens/profile_client_screen.dart';
import '../utils/constants.dart';

final User currentUser = Client(
  name: 'UserAdi UserSoyadi',
  email: 'user@example.com',
  height: 160,
  weight: 50.0,
);
final User currentUser2 = Client(
  name: 'UserAdi UserSoyadi',
  email: 'user@example.com',
  height: 160,
  weight: 50.0,
);
final User currentUser3 = Dietitian(
    name: 'UserAdi UserSoyadi',
    email: 'user@example.com',
    specialty: 'uzmanlık alanı');

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
      title: 'Diyetisyen Uygulaması',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.color1,
          secondary: AppColors.color3,
          surface: AppColors.color4,
        ),
        scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
          cardColor: AppColors.color4,
      ),
      home: HomeScreen(user: currentUser),
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
  int _selectedIndex = 0; // Seçili sayfa indeksini tutar
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(ClientProfileScreen(
        user: widget.user, currentUser: currentUser));
    _pages.add(CalendarScreen());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Seçili sayfayı güncelle
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
