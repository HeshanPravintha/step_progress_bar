import 'package:flutter/material.dart';
import 'package:step_progress_bar/step_progress_bar.dart';

class VerticalDemoPage extends StatefulWidget {
  const VerticalDemoPage({super.key});

  @override
  State<VerticalDemoPage> createState() => _VerticalDemoPageState();
}

class _VerticalDemoPageState extends State<VerticalDemoPage> {
  int _step = 1;
  static const _total = 5;
  static const _accent = Color(0xFF009688);

  static const _labels = [
    'Order Placed',
    'Processing',
    'Shipped',
    'Out for Delivery',
    'Delivered',
  ];
  static const _icons = [
    Icons.shopping_bag_outlined,
    Icons.inventory_2_outlined,
    Icons.local_shipping_outlined,
    Icons.delivery_dining_outlined,
    Icons.check_circle_outline,
  ];
  static const _descriptions = [
    "We've received your order and are getting it ready.",
    'Your items are being picked and packed.',
    'Your package has left our warehouse.',
    'Your package is on its way to you.',
    'Delivered. Enjoy!',
  ];

  @override
  Widget build(BuildContext context) {
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
          'Order Tracking',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_rounded, color: _accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order #A1829',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _descriptions[_step - 1],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 16, 24, 16),
              child: StepProgressBar(
                totalSteps: _total,
                currentStep: _step,
                axis: Axis.vertical,
                labels: _labels,
                icons: _icons,
                theme: const StepProgressBarTheme(
                  activeColor: _accent,
                  completedColor: _accent,
                  connectorLength: 44,
                ),
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
                    child: Text(_step < _total ? 'Advance Status' : 'Done'),
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
