import 'package:flutter/material.dart';

// -- الألوان المعتمدة في التصميم --
const kBackgroundColor = Color(0xFF0F171E);
const kCardColor = Color(0xFF192229);
const kAccentColor = Color(0xFF007AFF);
const kFieldFillColor = Color(0xFF1E272E); 
const kTextPrimary = Colors.white;
const kTextSecondary = Color(0xFF8E99A3);
const kDividerColor = Color(0xFF2C363F);

class AddClientPopup extends StatelessWidget {
  const AddClientPopup({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا Dialog ليعطينا مظهر النافذة المنبثقة
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        // تحديد عرض النافذة المنبثقة (مثلاً 600 بكسل كحد أقصى للـ Web)
        width: MediaQuery.of(context).size.width > 700 ? 650 : double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kDividerColor),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // مهم جداً لجعل الـ Popup يأخذ حجم المحتوى
            children: [
              // --- Header Section ---
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
                      const Text(
                        'Add New Client',
                        style: TextStyle(
                          color: kTextPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: kTextSecondary),
                  )
                ],
              ),
              const SizedBox(height: 32),

              // --- Form Fields ---
              _buildLabel("Full Name", isRequired: true),
              _buildTextField(hint: "John Doe"),
              
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Phone Number", isRequired: true),
                        _buildTextField(hint: "+1 234 567 890", icon: Icons.phone_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Email (Optional)"),
                        _buildTextField(hint: "john@example.com"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildLabel("Address"),
              _buildTextField(hint: "123 Main Street, City, State", icon: Icons.location_on_outlined),

              const SizedBox(height: 20),
              _buildLabel("Notes"),
              _buildTextField(
                hint: "Additional information...",
                icon: Icons.description_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // --- Buttons Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: kTextSecondary, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: kAccentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
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
          if (isRequired)
            const Text(" *", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, IconData? icon, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: kTextPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextSecondary, fontSize: 14),
        prefixIcon: icon != null ? Icon(icon, color: kTextSecondary, size: 18) : null,
        filled: true,
        fillColor: kFieldFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kAccentColor, width: 1.2),
        ),
      ),
    );
  }
}