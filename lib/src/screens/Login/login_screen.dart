import 'package:flutter/material.dart';
import 'package:owpet/src/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    // Logika untuk koneksi API login
    final email = emailController.text;
    final password = passwordController.text;

    // Gantikan URL dan tambahkan logika koneksi API di sini
    print('Login dengan Email: $email, Password: $password');
    await AuthService().login(email, password);
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/login.png',
              width: MediaQuery.of(context).size.width,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => login(context),
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
