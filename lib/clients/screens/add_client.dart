import 'package:flutter/material.dart';
import '../data/clients_ffi.dart'; // تأكد من اسم ملف الـ FFI الخاص بك

// -- الألوان المعتمدة في التصميم --
const kBackgroundColor = Color(0xFF0F171E);
const kAccentColor = Color(0xFF007AFF);
const kFieldFillColor = Color(0xFF1E272E); 
const kTextPrimary = Colors.white;
const kTextSecondary = Color(0xFF8E99A3);
const kDividerColor = Color(0xFF2C363F);

class AddClientPopup extends StatefulWidget {
  const AddClientPopup({super.key});

  @override
  State<AddClientPopup> createState() => _AddClientPopupState();
}

class _AddClientPopupState extends State<AddClientPopup> {
  // 1. تعريف الـ Controllers لسحب البيانات من الحقول
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // 2. تهيئة كلاس الـ FFI
  final ClientsFFI ffi = ClientsFFI();

  // 3. دالة الحفظ والربط مع C++
  void _saveClient() {
    // التحقق من الحقول الإجبارية أولاً
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      _showSnackBar("Please fill required fields (Name & Phone)", Colors.orange);
      return;
    }

    // استدعاء الدالة من C++ عبر FFI
    final result = ffi.addClient(
      userId: 1, // معرف المستخدم الحالي
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      notes: notesController.text,
    );

    // معالجة النتيجة بناءً على ffi_types.h
    if (result == 0) { // SUCCESS
      Navigator.pop(context); // إغلاق النافذة
      _showSnackBar("Client added successfully!", Colors.green);
    } else if (result == -102) { // ERR_INVALID_INPUT
      _showSnackBar("Invalid data provided!", Colors.red);
    } else {
      _showSnackBar("Error occurred (Code: $result)", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    // تنظيف الذاكرة عند إغلاق النافذة
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: MediaQuery.of(context).size.width > 700 ? 650 : double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kDividerColor),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kAccentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person_add_alt_1, color: kAccentColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Text('Add New Client', style: TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: kTextSecondary)),
                ],
              ),
              const SizedBox(height: 32),

              // --- Form Fields مع ربط الـ Controllers ---
              _buildLabel("Full Name", isRequired: true),
              _buildTextField(hint: "John Doe", controller: nameController),
              
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Phone Number", isRequired: true),
                        _buildTextField(hint: "+1 234 567 890", icon: Icons.phone_outlined, controller: phoneController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Email (Optional)"),
                        _buildTextField(hint: "john@example.com", controller: emailController),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildLabel("Address"),
              _buildTextField(hint: "123 Main Street...", icon: Icons.location_on_outlined, controller: addressController),

              const SizedBox(height: 20),
              _buildLabel("Notes"),
              _buildTextField(hint: "Additional info...", icon: Icons.description_outlined, maxLines: 3, controller: notesController),

              const SizedBox(height: 32),

              // --- Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: kTextSecondary, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: _saveClient, // استدعاء دالة الحفظ
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: kAccentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add Client', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          if (isRequired) const Text(" *", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, IconData? icon, int maxLines = 1, required TextEditingController controller}) {
    return TextField(
      controller: controller, // ربط الحقل بالكونترولر
      maxLines: maxLines,
      style: const TextStyle(color: kTextPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextSecondary, fontSize: 14),
        prefixIcon: icon != null ? Icon(icon, color: kTextSecondary, size: 18) : null,
        filled: true,
        fillColor: kFieldFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kDividerColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kAccentColor, width: 1.2)),
      ),
    );
  }
}