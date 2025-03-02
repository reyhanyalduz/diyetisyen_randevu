import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      AppUser? user = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // Kullanıcı tipine göre yönlendirme
        if (user.userType == UserType.client) {
          Navigator.pushReplacementNamed(context, '/clientHome');
        } else {
          Navigator.pushReplacementNamed(context, '/deneme');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giriş başarısız, lütfen bilgilerinizi kontrol edin.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "E-posta"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty || !value.contains("@") ? "Geçerli bir e-posta girin" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Şifre"),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? "Şifre en az 6 karakter olmalı" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Giriş Yap"),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text("Hesabınız yok mu? Kayıt olun"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
