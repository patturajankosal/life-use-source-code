import 'package:flutter/material.dart';
import 'auth/register_contact_screen.dart';

export 'auth/register_contact_screen.dart';

/// Backward-compatible widget forwarding to the production RegisterContactScreen.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterContactScreen();
  }
}
