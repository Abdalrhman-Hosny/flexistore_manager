import 'package:flutter/material.dart';
import '../data/audit_ffi.dart'; // تأكد من المسار الصحيح للملف

class AuditTestScreen extends StatefulWidget {
  const AuditTestScreen({super.key});

  @override
  State<AuditTestScreen> createState() => _AuditTestScreenState();
}

class _AuditTestScreenState extends State<AuditTestScreen> {
  // نقوم بإنشاء نسخة من الخدمة
  final AuditFFI _auditService = AuditFFI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audit System Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text("Test Inventory Log"),
              onPressed: () {
                // تجربة تسجيل حركة مخزون
                _auditService.logInventoryChange(101, 1, "SELL_PRODUCT", -1);
                _showSnackbar("Inventory Logged!");
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_money),
              label: const Text("Test Transaction Log"),
              onPressed: () {
                // تجربة تسجيل حركة مالية
                _auditService.logTransaction(1, "PAYMENT_RECEIVED", 500.50);
                _showSnackbar("Transaction Logged!");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}