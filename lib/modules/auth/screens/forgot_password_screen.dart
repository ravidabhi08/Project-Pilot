import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/custom_text_field.dart';
import 'package:taskflow_pro/modules/auth/controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.paddingExtraLarge),
                Text(
                  _emailSent ? 'Check Your Email' : 'Forgot Password?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  _emailSent
                      ? 'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions.'
                      : 'Enter your email address and we\'ll send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingExtraLarge),
                if (!_emailSent) ...[
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Obx(() {
                    if (_authController.errorMessage.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                        margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Text(
                          _authController.errorMessage,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  CustomButton(
                    text: 'Send Reset Link',
                    isLoading: _authController.isLoading,
                    onPressed: _handleResetPassword,
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: AppDimensions.iconSizeLarge,
                        ),
                        const SizedBox(width: AppDimensions.paddingMedium),
                        Expanded(
                          child: Text(
                            'Password reset email sent successfully!',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  CustomButton(text: 'Back to Sign In', onPressed: () => context.go('/login')),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController
          .resetPassword(_emailController.text.trim())
          .then((_) {
            setState(() {
              _emailSent = true;
            });
          })
          .catchError((error) {
            // Error is handled by the controller
          });
    }
  }
}
