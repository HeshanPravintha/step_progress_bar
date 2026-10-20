import 'package:flutter/material.dart';
import 'package:step_progress_bar/step_progress_bar.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Progress Bar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C63FF),
        useMaterial3: true,
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  int _currentStep = 1;
  int? _lastTapped;
  double _connectorLength = 48;

  String _stepLabel(int totalSteps) {
    if (_currentStep == 0) return 'Not started';
    if (_currentStep == totalSteps) return 'All done!';
    return 'Step $_currentStep of $totalSteps';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Step Progress Bar'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Segmented page demo button ────────────────────────────
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _SegmentedPage()),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.view_stream_rounded,
                        color: Colors.white, size: 28),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Segmented Bar — Live Demo',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          SizedBox(height: 2),
                          Text('Multi-step wizard with segmented progress',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Basic ─────────────────────────────────────────────────
            _SectionCard(
              title: 'Basic — 4 Steps',
              child: Column(
                children: [
                  _HScroll(
                    child: StepProgressBar(
                      totalSteps: 4,
                      currentStep: _currentStep,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: _currentStep > 0
                            ? () => setState(() => _currentStep--)
                            : null,
                        child: const Text('Back'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton(
                        onPressed: _currentStep < 4
                            ? () => setState(() => _currentStep++)
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stepLabel(4),
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Connected vs Separated ────────────────────────────────
            _SectionCard(
              title: 'Connected  (connectorSpacing: 0)',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 20,
                  currentStep: _currentStep,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _SectionCard(
              title: 'Separated  (connectorSpacing: 8)',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  theme: const StepProgressBarTheme(connectorSpacing: 20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── With labels ───────────────────────────────────────────
            _SectionCard(
              title: 'With Labels',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  labels: const ['Cart', 'Address', 'Payment', 'Done'],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── With icons + labels ───────────────────────────────────
            _SectionCard(
              title: 'With Icons + Labels',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  labels: const ['Cart', 'Address', 'Payment', 'Done'],
                  icons: const [
                    Icons.shopping_cart,
                    Icons.location_on,
                    Icons.credit_card,
                    Icons.check_circle,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Tappable ──────────────────────────────────────────────
            _SectionCard(
              title: 'Tappable Steps',
              child: Column(
                children: [
                  _HScroll(
                    child: StepProgressBar(
                      totalSteps: 4,
                      currentStep: _currentStep,
                          labels: const ['Cart', 'Address', 'Payment', 'Done'],
                      onStepTapped: (index) => setState(() {
                        _currentStep = index + 1;
                        _lastTapped = index;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _lastTapped == null
                        ? 'Tap any step to jump to it'
                        : 'Tapped step ${_lastTapped! + 1}',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Connector length slider ───────────────────────────────
            _SectionCard(
              title: 'Connector Length  (${_connectorLength.round()}px)',
              child: Column(
                children: [
                  _HScroll(
                    child: StepProgressBar(
                      totalSteps: 4,
                      currentStep: _currentStep,
                      theme: const StepProgressBarTheme()
                          .copyWith(connectorLength: _connectorLength),
                      labels: const ['Cart', 'Address', 'Payment', 'Done'],
                    ),
                  ),
                  Slider(
                    value: _connectorLength,
                    min: 10,
                    max: 120,
                    divisions: 22,
                    label: '${_connectorLength.round()}px',
                    onChanged: (v) =>
                        setState(() => _connectorLength = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Per-step custom color ─────────────────────────────────
            _SectionCard(
              title: 'Per-Step Custom Color',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  labels: const ['Red', 'Orange', 'Blue', 'Green'],
                  customColor: (index, state) {
                    if (state == StepStatus.inactive) return null;
                    return [
                      Colors.red,
                      Colors.orange,
                      Colors.blue,
                      Colors.green,
                    ][index];
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Custom theme: orange ──────────────────────────────────
            _SectionCard(
              title: 'Custom Theme — Orange',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 5,
                  currentStep: _currentStep.clamp(0, 5),
                  theme: StepProgressBarTheme(
                    activeColor: Colors.deepOrange,
                    completedColor: Colors.deepOrange,
                    inactiveColor: Colors.orange.shade100,
                  ),
                  labels: const ['One', 'Two', 'Three', 'Four', 'Five'],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Custom theme: rounded square + custom icon ────────────
            _SectionCard(
              title: 'Rounded Square + Custom Icon',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  theme: StepProgressBarTheme(
                    activeColor: Colors.teal,
                    completedColor: Colors.teal,
                    inactiveColor: Colors.teal.shade50,
                    inactiveBorderColor: Colors.teal.shade200,
                    borderRadius: BorderRadius.circular(8),
                    completedIcon: Icons.done_all,
                    stepSize: 38,
                    lineThickness: 4,
                  ),
                  labels: const ['Start', 'Build', 'Review', 'Ship'],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Custom theme: label styles ────────────────────────────
            _SectionCard(
              title: 'Custom Label Styles',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  theme: StepProgressBarTheme(
                    activeColor: const Color(0xFF6C63FF),
                    completedColor: const Color(0xFF6C63FF),
                    labelStyle: const TextStyle(fontSize: 10),
                    activeLabelStyle: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontStyle: FontStyle.italic,
                    ),
                    completedLabelStyle:
                        const TextStyle(decoration: TextDecoration.lineThrough),
                    inactiveLabelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                  labels: const ['Cart', 'Address', 'Payment', 'Done'],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Vertical axis ─────────────────────────────────────────
            _SectionCard(
              title: 'Vertical Axis',
              child: StepProgressBar(
                totalSteps: 4,
                currentStep: _currentStep,
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

            const SizedBox(height: 20),

            // ── Segmented style ───────────────────────────────────────
            _SectionCard(
              title: 'Segmented Bar (default)',
              child: StepProgressBar(
                totalSteps: 6,
                currentStep: _currentStep.clamp(0, 6),
                style: StepProgressBarStyle.segmented,
              ),
            ),

            const SizedBox(height: 12),

            _SectionCard(
              title: 'Segmented — Red  (like health declaration)',
              child: StepProgressBar(
                totalSteps: 6,
                currentStep: _currentStep.clamp(0, 6),
                style: StepProgressBarStyle.segmented,
                theme: StepProgressBarTheme(
                  completedColor: const Color(0xFFE8193C),
                  activeColor: const Color(0xFFE8193C),
                  inactiveColor: const Color(0xFFFFCDD2),
                  segmentHeight: 6,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _SectionCard(
              title: 'Segmented — Taller + Custom Gap',
              child: StepProgressBar(
                totalSteps: 5,
                currentStep: _currentStep.clamp(0, 5),
                style: StepProgressBarStyle.segmented,
                theme: const StepProgressBarTheme(
                  activeColor: Color(0xFF6C63FF),
                  completedColor: Color(0xFF6C63FF),
                  segmentHeight: 12,
                  connectorSpacing: 6,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _SectionCard(
              title: 'Segmented — Tappable',
              child: StepProgressBar(
                totalSteps: 5,
                currentStep: _currentStep.clamp(0, 5),
                style: StepProgressBarStyle.segmented,
                onStepTapped: (index) =>
                    setState(() => _currentStep = index + 1),
              ),
            ),

            const SizedBox(height: 20),

            // ── Custom step builder ───────────────────────────────────
            _SectionCard(
              title: 'Custom Step Builder',
              child: _HScroll(
                child: StepProgressBar(
                  totalSteps: 4,
                  currentStep: _currentStep,
                  stepBuilder: (index, state) {
                    final colors = {
                      StepStatus.completed: Colors.green,
                      StepStatus.active: const Color(0xFF6C63FF),
                      StepStatus.inactive: Colors.grey.shade300,
                    };
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colors[state],
                      ),
                      child: Center(
                        child: state == StepStatus.completed
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: state == StepStatus.inactive
                                      ? Colors.grey.shade500
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _HScroll extends StatelessWidget {
  const _HScroll({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    );
  }
}

// ── Segmented page ────────────────────────────────────────────────────────────

class _SegmentedPage extends StatefulWidget {
  const _SegmentedPage();

  @override
  State<_SegmentedPage> createState() => _SegmentedPageState();
}

class _SegmentedPageState extends State<_SegmentedPage> {
  int _step = 1;
  static const _total = 5;

  static const _steps = [
    (
      icon: Icons.person_outline,
      title: 'Personal Info',
      subtitle: 'Tell us a bit about yourself',
    ),
    (
      icon: Icons.location_on_outlined,
      title: 'Address',
      subtitle: 'Where are you located?',
    ),
    (
      icon: Icons.tune_outlined,
      title: 'Preferences',
      subtitle: 'Customize your experience',
    ),
    (
      icon: Icons.description_outlined,
      title: 'Documents',
      subtitle: 'Upload required files',
    ),
    (
      icon: Icons.check_circle_outline,
      title: 'Review',
      subtitle: 'Confirm and submit',
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
        title: Text(step.title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Segmented bar — full width, no side padding ──
          StepProgressBar(
            totalSteps: _total,
            currentStep: _step,
            style: StepProgressBarStyle.segmented,
            theme: const StepProgressBarTheme(
              completedColor: Color(0xFF6C63FF),
              activeColor: Color(0xFF6C63FF),
              inactiveColor: Color(0xFFE8E8FF),
              segmentHeight: 5,
              connectorSpacing: 3,
            ),
          ),

          // ── Step content ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Step $_step of $_total',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(step.subtitle,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEFF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(step.icon,
                          size: 40, color: const Color(0xFF6C63FF)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ..._buildStepContent(_step),
                ],
              ),
            ),
          ),

          // ── Navigation ───────────────────────────────────
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
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_step < _total ? 'Continue' : 'Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepContent(int step) {
    switch (step) {
      case 1:
        return [
          _Field(label: 'Full Name', hint: 'John Doe'),
          const SizedBox(height: 16),
          _Field(label: 'Email', hint: 'john@example.com'),
          const SizedBox(height: 16),
          _Field(label: 'Phone', hint: '+1 234 567 890'),
        ];
      case 2:
        return [
          _Field(label: 'Street Address', hint: '123 Main St'),
          const SizedBox(height: 16),
          _Field(label: 'City', hint: 'New York'),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: _Field(label: 'State', hint: 'NY')),
              const SizedBox(width: 12),
              Expanded(
                  child: _Field(label: 'ZIP Code', hint: '10001')),
            ],
          ),
        ];
      case 3:
        return [
          _CheckTile(label: 'Email notifications'),
          _CheckTile(label: 'SMS alerts'),
          _CheckTile(label: 'Weekly digest'),
          _CheckTile(label: 'Product updates'),
        ];
      case 4:
        return [
          _UploadTile(label: 'ID Proof', icon: Icons.badge_outlined),
          const SizedBox(height: 12),
          _UploadTile(label: 'Address Proof', icon: Icons.home_outlined),
          const SizedBox(height: 12),
          _UploadTile(
              label: 'Photograph', icon: Icons.camera_alt_outlined),
        ];
      case 5:
        return [
          _ReviewRow(label: 'Name', value: 'John Doe'),
          _ReviewRow(label: 'Email', value: 'john@example.com'),
          _ReviewRow(label: 'City', value: 'New York'),
          _ReviewRow(label: 'Notifications', value: 'Enabled'),
          _ReviewRow(label: 'Documents', value: '3 uploaded'),
        ];
      default:
        return [];
    }
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.hint});
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
      ),
    );
  }
}

class _CheckTile extends StatefulWidget {
  const _CheckTile({required this.label});
  final String label;

  @override
  State<_CheckTile> createState() => _CheckTileState();
}

class _CheckTileState extends State<_CheckTile> {
  bool _checked = true;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _checked,
      onChanged: (v) => setState(() => _checked = v ?? false),
      title: Text(widget.label),
      activeColor: const Color(0xFF6C63FF),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF8F7FF),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6C63FF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.upload_outlined,
              color: Color(0xFF6C63FF), size: 20),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 13)),
          ),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
