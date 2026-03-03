//                                                       5
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/domain/entities/app_user.dart';
import 'package:reddit_app/features/auth/presentations/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscurePassword = true; // for togling the password privacy
  // Add this variable in your _LoginScreenState

  @override
  Widget build(BuildContext context) {
    /// LISTEN TO AUTH STATE (navigation + errors)
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (prev, next) {
      // Only show snackbar if error is NEW (wasn't an error before)

      if (next is AsyncError && prev is! AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true, // default is true
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// APP LOGO
                // can add later

                /// Title
                const Center(
                  child: Text(
                    "Let’s sign you in.",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    "Welcome back, you’ve been missed!",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 32),

                /// Email Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    // hintText: "Your email",
                    labelText: "Email",
                    // prefixIcon: const Icon(Icons.email_outlined),
                    labelStyle: TextStyle(
                      color: Colors.grey.shade600,
                    ), // <-- Label color when not focused),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(color: Colors.cyan),// color will not change cz border using default theme colors.
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Password Field
                TextField(
                  controller: passController,
                  obscureText: _obscurePassword,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    labelText: "Password",
                    // hintText: "Enter your password",
                    // prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          }
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onForgetPassBox,
                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: 12),

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final pass = passController.text.trim();

                      if (email.isEmpty || pass.isEmpty) {
                        // for the fullfillment of all fields
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all fields"),
                          ),
                        );
                        return;
                      }
                      ref
                          .read(authControllerProvider.notifier)
                          .login(email, pass);
                      _navigateIfLoggedIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2AC1BC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Log In", style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 24),

                /// Or continue with
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "or continue with",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                /// Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialButton(
                      Image.asset("assets/images/google.png"),
                      onTap: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle();
                        _navigateIfLoggedIn(); // method for navigation
                      },
                    ),
                    _socialButton(const Icon(Icons.apple, size: 32)),
                    _socialButton(Image.asset("assets/images/fb1.png")),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/signup');
                      },
                      child: Text("Sign Up Now"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(Widget icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: SizedBox(width: 32, height: 32, child: icon)),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _navigateIfLoggedIn() {
    final state = ref.read(authControllerProvider);
    if (state is AsyncData && state.value != null && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void onForgetPassBox() {
    // delete the note
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: TextField(
            controller: emailController,
            obscureText: false,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(
                color: Colors.grey.shade600,
              ), // <-- Label color when not focused),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .forgotPass(emailController.text);

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password reset email sent. Check your inbox.",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
