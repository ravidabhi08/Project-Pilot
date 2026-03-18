import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Manage Projects',
      description:
          'Create and organize your projects with ease. Track progress and collaborate with your team.',
      icon: Icons.folder_special,
    ),
    OnboardingItem(
      title: 'Assign Tasks',
      description:
          'Break down projects into manageable tasks. Assign them to team members and set deadlines.',
      icon: Icons.assignment,
    ),
    OnboardingItem(
      title: 'Track Progress',
      description:
          'Monitor task completion, view timelines, and get real-time updates on project status.',
      icon: Icons.timeline,
    ),
    OnboardingItem(
      title: 'Collaborate',
      description:
          'Comment on tasks, share files, and communicate effectively with your team members.',
      icon: Icons.people,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  return _buildPage(_onboardingItems[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusExtraLarge),
            ),
            child: Icon(item.icon, size: 80, color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.paddingExtraLarge),
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingItems.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: CustomButton(
                    text: 'Previous',
                    isOutlined: true,
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: CustomButton(
                  text: _currentPage == _onboardingItems.length - 1 ? 'Get Started' : 'Next',
                  onPressed: () {
                    if (_currentPage == _onboardingItems.length - 1) {
                      context.go(AppRoutes.login);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          TextButton(
            onPressed: () {
              context.go(AppRoutes.login);
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({required this.title, required this.description, required this.icon});
}
