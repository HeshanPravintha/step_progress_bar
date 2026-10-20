import 'package:flutter/material.dart';
import 'package:step_progress_bar/step_progress_bar.dart';

class CircleDemoPage extends StatefulWidget {
  const CircleDemoPage({super.key});

  @override
  State<CircleDemoPage> createState() => _CircleDemoPageState();
}

class _CircleDemoPageState extends State<CircleDemoPage> {
  int _step = 1;
  static const _total = 4;
  static const _accent = Color(0xFF6C63FF);

  static const _steps = [
    (
      icon: Icons.person_add_outlined,
      title: 'Account',
      subtitle: 'Create your login credentials',
      body: 'Pick an email and password you will use to sign in.',
    ),
    (
      icon: Icons.badge_outlined,
      title: 'Profile',
      subtitle: 'Tell us who you are',
      body: 'Add your name and a photo so your team can recognize you.',
    ),
    (
      icon: Icons.tune_outlined,
      title: 'Preferences',
      subtitle: 'Choose how we reach you',
      body: 'Pick which notifications you want to receive, and how often.',
    ),
    (
      icon: Icons.check_circle_outline,
      title: 'Done',
      subtitle: "You're all set",
      body: 'Your account is ready — review your details and finish up.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step - 1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: StepProgressBar(
              totalSteps: _total,
              currentStep: _step,
              labels: const ['Account', 'Profile', 'Prefs', 'Done'],
              icons: const [
                Icons.person_add_outlined,
                Icons.badge_outlined,
                Icons.tune_outlined,
                Icons.check_circle_outline,
              ],
              theme: const StepProgressBarTheme(
                activeColor: _accent,
                completedColor: _accent,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step $_step of $_total',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.subtitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEFF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(step.icon, size: 40, color: _accent),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.body,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_step > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: _accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_step > 1) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _step < _total
                        ? () => setState(() => _step++)
                        : () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_step < _total ? 'Continue' : 'Finish'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
