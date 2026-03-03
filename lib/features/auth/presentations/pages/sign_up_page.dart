import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/domain/entities/app_user.dart';
import 'package:reddit_app/features/auth/presentations/auth_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  bool _obscurePassword = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  String? emailError;

  // Email validation
  String? validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(email)) {
      return "Invalid email format";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /// LISTEN TO AUTH STATE (navigation + errors)
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (prev, next) {
      if (next is AsyncError && prev is! AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Handle email-not-verified specifically
      if (next is AsyncError) {
        final error = next.error.toString();
        if (error.contains('verify') || error.contains('Verify')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Verification email sent. Please check your inbox.",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // REMOVE the data navigation — verified users only come from login not register
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  "Sign up to continue",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 32),

              /// NAME
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    emailError = validateEmail(
                      value,
                    ); // this for the email validation.
                  });
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError,
                  helperText: "example@email.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// PASSWORD
              TextField(
                controller: passController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText:
                      passController.text.length < 8 &&
                          passController.text.isNotEmpty
                      ? "Password must be atlesat 8 characters"
                      : null,
                  suffixIcon: IconButton(
                    // icon to show and hide pass
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// CONFIRM PASSWORD
              TextField(
                controller: confirmPassController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final pass = passController.text.trim();
                    final confirmPass = confirmPassController.text.trim();

                    if (name.isEmpty ||
                        email.isEmpty ||
                        pass.isEmpty ||
                        confirmPass.isEmpty) {
                      // for the fullfillment of all fields
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }
                    if (pass != confirmPass) {
                      // for pass confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    ref
                        .read(authControllerProvider.notifier)
                        .register(name, email, pass);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2AC1BC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text("Login now"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}

/* 
void register(){
    // prepare info
    final name = nameController.text;
    final email = emailController.text;
    final pass = passController.text;
    final confirmPass = confirmPassController.text;

    // auth controller instance
    final authController = ref.read(authControllerProvider.notifier);

    // ensure fields arent empty
    if(name.isNotEmpty && email.isNotEmpty && pass.isNotEmpty){
      if(pass == confirmPass){
        authController.register(name, email, pass);
      }
      // if pass dosnt match
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password didn't match!"))
        );
      }
    }
    // if fields are empty
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter required fields!"))
      );
    }
  }

*/
