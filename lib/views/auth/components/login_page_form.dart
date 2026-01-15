import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_themes.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/auth_service.dart';
import 'login_button.dart';

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({
    super.key,
  });

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isPasswordShown = false;

  onPassShowClicked() {
    isPasswordShown = !isPasswordShown;
    setState(() {});
  }

  onLogin() async {
    final bool isFormOkay = _key.currentState?.validate() ?? false;
    if (isFormOkay) {
      setState(() => _isLoading = true);
      
      String? error = await AuthService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      setState(() => _isLoading = false);
      
      if (error == null) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          AppRoutes.entryPoint, 
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email Field
              const Text("Email"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email.call,
                textInputAction: TextInputAction.next,
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppDefaults.padding),

              // Password Field
              const Text("Password"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                validator: Validators.password.call,
                onFieldSubmitted: (v) => onLogin(),
                textInputAction: TextInputAction.done,
                obscureText: !isPasswordShown,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  suffixIcon: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: onPassShowClicked,
                      icon: SvgPicture.asset(
                        AppIcons.eye,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // Forget Password labelLarge
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text('Forget Password?'),
                ),
              ),

              // Login labelLarge
              LoginButton(onPressed: _isLoading ? null : () => onLogin()),
            ],
          ),
        ),
      ),
    );
  }
}
