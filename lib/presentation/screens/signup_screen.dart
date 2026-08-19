

import 'package:beach_resort_management/config/auth_service.dart';
import 'package:beach_resort_management/presentation/widgets/auth_button.dart';
import 'package:beach_resort_management/presentation/widgets/auth_header.dart';
import 'package:beach_resort_management/presentation/widgets/auth_password_field.dart';
import 'package:beach_resort_management/presentation/widgets/auth_text_field.dart';
import 'package:beach_resort_management/presentation/widgets/social_login_button.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

bool _isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your email";
    }

    if (!value.contains("@")) {
      return "Enter a valid email";
    }

    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

Future<void> signup() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  try {
    await _authService.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Account created successfully! Please check your email to verify your account.",
        ),
        backgroundColor: Colors.green,
      ),
    );

    context.go(RouteNames.login);
  }catch (e) {
  if (!mounted) return;

  String message = e.toString();

  if (message.contains("Email rate limit exceeded")) {
    message =
        "Too many email requests. Please wait a few minutes and try again.";
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                const AuthHeader(
                  title: "Create Account",
                  subtitle: "Join Beach Resort today",
                ),

                const SizedBox(height: 40),

                AuthTextField(
                  controller: nameController,
                  hintText: "Full Name",
                  prefixIcon: Icons.person_outline,
                  validator: requiredValidator,
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: emailController,
                  hintText: "Email Address",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: phoneController,
                  hintText: "Phone Number",
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: requiredValidator,
                ),

                const SizedBox(height: 20),

                AuthPasswordField(
                  controller: passwordController,
                  hintText: "Password",
                  validator: requiredValidator,
                ),

                const SizedBox(height: 20),

                AuthPasswordField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  validator: confirmPasswordValidator,
                ),

                const SizedBox(height: 25),

               _isLoading
    ? const CircularProgressIndicator()
    : AuthButton(
        text: "CREATE ACCOUNT",
        onPressed: signup,
      ),

                const SizedBox(height: 25),

                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 25),

                SocialLoginButton(
                  onPressed: () {
                    
                  },
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),

                    GestureDetector(
                      onTap: () {
                        context.go(RouteNames.login);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}