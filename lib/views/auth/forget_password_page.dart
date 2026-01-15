import 'package:flutter/material.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../core/services/auth_service.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  onSendResetLink() async {
    final bool isFormOkay = _formKey.currentState?.validate() ?? false;
    if (isFormOkay) {
      setState(() => _isLoading = true);
      
      String? error = await AuthService.resetPassword(_emailController.text.trim());
      
      setState(() => _isLoading = false);
      
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent! Check your email.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Forget Password'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(AppDefaults.margin),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                  vertical: AppDefaults.padding * 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reset your password',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDefaults.padding),
                      const Text(
                        'Please enter your email. We will send a link\nto your email to reset your password.',
                      ),
                      const SizedBox(height: AppDefaults.padding * 3),
                      const Text("Email"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        autofocus: true,
                        validator: Validators.email.call,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading,
                        onFieldSubmitted: (_) => onSendResetLink(),
                      ),
                      const SizedBox(height: AppDefaults.padding),
                      const SizedBox(height: AppDefaults.padding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : onSendResetLink,
                          child: _isLoading 
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Send me link'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
