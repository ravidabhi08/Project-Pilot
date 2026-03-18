import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/custom_text_field.dart';
import 'package:taskflow_pro/modules/auth/controllers/auth_controller.dart';
import 'package:taskflow_pro/routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.paddingExtraLarge),
                Text('Welcome Back', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  'Sign in to your account to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingExtraLarge),
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
                const SizedBox(height: AppDimensions.paddingMedium),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push(AppRoutes.forgotPassword);
                    },
                    child: const Text('Forgot Password?'),
                  ),
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
                  text: 'Sign In',
                  isLoading: _authController.isLoading,
                  onPressed: _handleSignIn,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Row(
                  children: [
                    Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                      child: Text(
                        'OR',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                CustomButton(
                  text: 'Continue with Google',
                  isOutlined: true,
                  icon: Icons.g_mobiledata,
                  onPressed: _handleGoogleSignIn,
                ),
                const SizedBox(height: AppDimensions.paddingExtraLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.register);
                      },
                      child: const Text('Sign Up'),
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

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController
          .signInWithEmailAndPassword(_emailController.text.trim(), _passwordController.text)
          .then((_) {
            if (_authController.isAuthenticated) {
              context.go(AppRoutes.dashboard);
            }
          })
          .catchError((error) {
            // Error is handled by the controller
          });
    }
  }

  void _handleGoogleSignIn() {
    _authController
        .signInWithGoogle()
        .then((_) {
          if (_authController.isAuthenticated) {
            context.go(AppRoutes.dashboard);
          }
        })
        .catchError((error) {
          // Error is handled by the controller
        });
  }
}
