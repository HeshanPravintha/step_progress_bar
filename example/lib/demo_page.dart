import 'package:flutter/material.dart';
import 'package:step_progress_bar/step_progress_bar.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _BarDemo {
  const _BarDemo({
    required this.title,
    required this.subtitle,
    required this.totalSteps,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final int totalSteps;
  final Widget Function(int currentStep, ValueChanged<int> onStepTapped)
  builder;
}

class _DemoPageState extends State<DemoPage> {
  final _pageController = PageController();
  int _pageIndex = 0;
  final Map<int, int> _stepByPage = {};

  late final List<_BarDemo> _demos = [
    _BarDemo(
      title: 'Default Circle Bar',
      subtitle: 'Simple numbered circles connected by a line',
      totalSteps: 4,
      builder: (step, onTap) =>
          StepProgressBar(totalSteps: 4, currentStep: step),
    ),
    _BarDemo(
      title: 'Circle Bar with Labels & Icons',
      subtitle: 'Each step carries an icon and a caption',
      totalSteps: 4,
      builder: (step, onTap) => StepProgressBar(
        totalSteps: 4,
        currentStep: step,
        labels: const ['Cart', 'Address', 'Payment', 'Done'],
        icons: const [
          Icons.shopping_cart,
          Icons.location_on,
          Icons.credit_card,
          Icons.check_circle,
        ],
      ),
    ),
    _BarDemo(
      title: 'Tappable Circle Bar',
      subtitle: 'Tap any step to jump directly to it',
      totalSteps: 4,
      builder: (step, onTap) => StepProgressBar(
        totalSteps: 4,
        currentStep: step,
        labels: const ['Cart', 'Address', 'Payment', 'Done'],
        onStepTapped: onTap,
      ),
    ),
    _BarDemo(
      title: 'Custom Themed Circle Bar',
      subtitle: 'Orange theme, 5 steps',
      totalSteps: 5,
      builder: (step, onTap) => StepProgressBar(
        totalSteps: 5,
        currentStep: step,
        theme: StepProgressBarTheme(
          activeColor: Colors.deepOrange,
          completedColor: Colors.deepOrange,
          inactiveColor: Colors.orange.shade100,
        ),
        labels: const ['One', 'Two', 'Three', 'Four', 'Five'],
      ),
    ),
    _BarDemo(
      title: 'Vertical Bar',
      subtitle: 'Steps stacked top to bottom',
      totalSteps: 4,
      builder: (step, onTap) => StepProgressBar(
        totalSteps: 4,
        currentStep: step,
        axis: Axis.vertical,
        labels: const ['Cart', 'Address', 'Payment', 'Done'],
        icons: const [
          Icons.shopping_cart,
          Icons.location_on,
          Icons.credit_card,
          Icons.check_circle,
        ],
      ),
    ),
    _BarDemo(
      title: 'Segmented Bar',
      subtitle: 'Flat rectangular progress blocks',
      totalSteps: 6,
      builder: (step, onTap) => StepProgressBar(
        totalSteps: 6,
        currentStep: step,
        style: StepProgressBarStyle.segmented,
      ),
    ),
    _BarDemo(
      title: 'Segmented Bar — Colored',
      subtitle: 'Red, health-declaration style',
      totalSteps: 6,
      builder: (step, onTap) => StepProgressBar(
        totalSteps: 6,
        currentStep: step,
        style: StepProgressBarStyle.segmented,
        theme: const StepProgressBarTheme(
          completedColor: Color(0xFFE8193C),
          activeColor: Color(0xFFE8193C),
          inactiveColor: Color(0xFFFFCDD2),
          segmentHeight: 6,
        ),
      ),
    ),
  ];

  int _stepFor(int index) => _stepByPage[index] ?? 1;

  void _setStep(int index, int step) {
    final total = _demos[index].totalSteps;
    setState(() => _stepByPage[index] = step.clamp(0, total));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Live Demo'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '${_pageIndex + 1} / ${_demos.length}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _demos.length,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              itemBuilder: (context, index) {
                final demo = _demos[index];
                final step = _stepFor(index);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demo.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          demo.subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: demo.builder(
                            step,
                            (i) => _setStep(index, i + 1),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: step > 0
                                  ? () => _setStep(index, step - 1)
                                  : null,
                              child: const Text('Back'),
                            ),
                            const SizedBox(width: 16),
                            FilledButton(
                              onPressed: step < demo.totalSteps
                                  ? () => _setStep(index, step + 1)
                                  : null,
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pageIndex > 0
                        ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          )
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous Bar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _pageIndex < _demos.length - 1
                        ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          )
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Bar'),
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
