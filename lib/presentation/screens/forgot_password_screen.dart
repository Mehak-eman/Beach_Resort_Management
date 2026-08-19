

import 'package:beach_resort_management/presentation/widgets/auth_button.dart';
import 'package:beach_resort_management/presentation/widgets/auth_header.dart';
import 'package:beach_resort_management/presentation/widgets/auth_text_field.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }

    if (!value.contains("@")) {
      return "Enter a valid email";
    }

    return null;
  }

  void resetPassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset link sent (UI Only)",
          ),
        ),
      );

      // TODO: Connect Supabase Reset Password
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                const AuthHeader(
                  title: "Forgot Password?",
                  subtitle:
                      "Enter your email address to receive a password reset link.",
                ),

                const SizedBox(height: 40),

                AuthTextField(
                  controller: emailController,
                  hintText: "Email Address",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),

                const SizedBox(height: 30),

                AuthButton(
                  text: "SEND RESET LINK",
                  onPressed: resetPassword,
                ),

                const SizedBox(height: 30),

                TextButton.icon(
                  onPressed: () {
                    context.go(RouteNames.login);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back to Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}