import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/auth_service.dart';
import 'already_have_accout.dart';
import 'sign_up_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isPasswordShown = false;

  onPassShowClicked() {
    isPasswordShown = !isPasswordShown;
    setState(() {});
  }

  onSignUp() async {
    final bool isFormOkay = _formKey.currentState?.validate() ?? false;
    if (isFormOkay) {
      setState(() => _isLoading = true);
      
      String? error = await AuthService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      setState(() => _isLoading = false);
      
      if (error == null) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/entry-point', 
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.margin),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              validator: Validators.requiredWithFieldName('Name').call,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
            ),
            const SizedBox(height: AppDefaults.padding),
            
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
            
            const Text("Phone Number"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              textInputAction: TextInputAction.next,
              validator: Validators.required.call,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: !_isLoading,
            ),
            const SizedBox(height: AppDefaults.padding),
            
            const Text("Password"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              validator: Validators.password.call,
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
            const SizedBox(height: AppDefaults.padding),
            
            SignUpButton(onPressed: _isLoading ? null : () => onSignUp()),
            const AlreadyHaveAnAccount(),
            const SizedBox(height: AppDefaults.padding),
          ],
        ),
      ),
    );
  }
}
