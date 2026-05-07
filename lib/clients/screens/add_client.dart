import 'package:flutter/material.dart';

// -- الألوان المعتمدة في التصميم --
const kBackgroundColor = Color(0xFF0F171E);
const kCardColor = Color(0xFF192229);
const kAccentColor = Color(0xFF007AFF);
const kFieldFillColor = Color(0xFF1E272E); // لون خلفية الحقول
const kTextPrimary = Colors.white;
const kTextSecondary = Color(0xFF8E99A3);
const kDividerColor = Color(0xFF2C363F);

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: kTextSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Header Section ---
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kAccentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add_alt_1, color: kAccentColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Add New Client',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- Form Fields ---
              _buildLabel("Full Name", isRequired: true),
              _buildTextField(hint: "John Doe"),
              
              const SizedBox(height: 24),
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
                  const SizedBox(width: 20),
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

              const SizedBox(height: 24),
              _buildLabel("Address"),
              _buildTextField(hint: "123 Main Street, City, State", icon: Icons.location_on_outlined),

              const SizedBox(height: 24),
              _buildLabel("Notes"),
              _buildTextField(
                hint: "Additional information about the client...",
                icon: Icons.description_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 40),

              // --- Buttons Section ---
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
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

  // ويدجت لبناء العناوين الصغيرة فوق الحقول
  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
          if (isRequired)
            const Text(" *", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
        ],
      ),
    );
  }

  // ويدجت موحد للحقول (TextField)
  Widget _buildTextField({required String hint, IconData? icon, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextSecondary, fontSize: 15),
        prefixIcon: icon != null ? Icon(icon, color: kTextSecondary, size: 20) : null,
        filled: true,
        fillColor: kFieldFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccentColor, width: 1.5),
        ),
      ),
    );
  }
}