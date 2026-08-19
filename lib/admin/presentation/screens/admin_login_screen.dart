import 'package:beach_resort_management/admin/viewmodels/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 
  // ADMIN LOGIN
  

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel =
        context.read<AdminViewModel>();

    final success = await viewModel.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      // Go to admin dashboard
      context.go('/admin-dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ??
                'Admin login failed.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        context.watch<AdminViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text('Admin Login'),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Card(
            elevation: 5,

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(25),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    
                    // ADMIN ICON
                 

                    Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color:
                            Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 55,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 20),

                  
                    // TITLE
                 

                    const Text(
                      'Admin Login',

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Login to access the admin panel',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                  
                    // EMAIL
                  

                    TextFormField(
                      controller:
                          _emailController,

                      keyboardType:
                          TextInputType
                              .emailAddress,

                      textInputAction:
                          TextInputAction.next,

                      decoration:
                          const InputDecoration(
                        labelText: 'Email',

                        hintText:
                            'Enter admin email',

                        prefixIcon:
                            Icon(Icons.email),

                        border:
                            OutlineInputBorder(),

                        enabledBorder:
                            OutlineInputBorder(),

                        focusedBorder:
                            OutlineInputBorder(),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Enter email';
                        }

                        if (!value
                            .contains('@')) {
                          return 'Enter a valid email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                  
                    // PASSWORD
                    

                    TextFormField(
                      controller:
                          _passwordController,

                      obscureText:
                          _obscurePassword,

                      textInputAction:
                          TextInputAction.done,

                      onFieldSubmitted:
                          (_) {
                        if (!viewModel.isLoading) {
                          _login();
                        }
                      },

                      decoration:
                          InputDecoration(
                        labelText:
                            'Password',

                        hintText:
                            'Enter admin password',

                        prefixIcon:
                            const Icon(
                          Icons.lock,
                        ),

                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },

                          icon: Icon(
                            _obscurePassword
                                ? Icons
                                    .visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        border:
                            const OutlineInputBorder(),

                        enabledBorder:
                            const OutlineInputBorder(),

                        focusedBorder:
                            const OutlineInputBorder(),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Enter password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                  
                    // LOGIN BUTTON
                  

                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child:
                          ElevatedButton(
                        onPressed:
                            viewModel.isLoading
                                ? null
                                : _login,

                        style:
                            ElevatedButton
                                .styleFrom(
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),

                        child:
                            viewModel.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,

                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style:
                                        TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}