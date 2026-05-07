import 'package:flutter/material.dart';

// -- الألوان المستخدمة في التصميم (داكن وأزرق وأصفر وأخضر) --
const kBackgroundColor = Color(0xFF101820); // الخلفية الداكنة جداً
const kCardColor = Color(0xFF1A222A); // لون الكروت والمناطق الداخلية
const kAccentColor = Color(0xFF007BFF); // الأزرق للبحث والزرار
const kTextPrimary = Colors.white; // النص الأبيض الأساسي
const kTextSecondary = Color(0xFF8B95A0); // النص الرمادي الفرعي
const kDividerColor = Color(0xFF2E3B46); // لون الفواصل
const kGreenText = Color(0xFF28A745); // الأخضر للنجاح/Active
const kAmberText = Color(0xFFDC9E0C); // الأصفر للتحذير/Debt
const kRedText = Color(0xFFDC3545); // الأحمر للخطر/Overdue

// -- الموديل (بيانات وهمية للعميل مطابقة للصورة) --
class Client {
  final String initial;
  final Color initialColor;
  final String name;
  final String location;
  final String email;
  final String phone;
  final double totalPurchases;
  final double pendingDebt;
  final int installments;
  final String status;

  Client({
    required this.initial,
    required this.initialColor,
    required this.name,
    required this.location,
    required this.email,
    required this.phone,
    required this.totalPurchases,
    required this.pendingDebt,
    required this.installments,
    required this.status,
  });
}

// -- الشاشة الأساسية --
class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  // القائمة الرئيسية التي سنعرضها (حالياً بيانات وهمية)
  List<Client> filteredClients = _mockClients;
  final TextEditingController _searchController = TextEditingController();

  // دالة البحث البسيطة
  void _filterClients(String query) {
    setState(() {
      filteredClients = _mockClients
          .where((client) =>
              client.name.toLowerCase().contains(query.toLowerCase()) ||
              client.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. العنوان والزرار العلوي
            const ClientsHeaderWidget(),
            const SizedBox(height: 24),

            // 2. كروت الإحصائيات الأربعة (Total, Active, etc.)
            const ClientsStatsCardsWidget(),
            const SizedBox(height: 24),

            // 3. شريط البحث والفلتر
            SearchBarWidget(
              controller: _searchController,
              onChanged: _filterClients,
            ),
            const SizedBox(height: 16),

            // 4. جدول العملاء الرئيسي
            Expanded(
              child: ClientsTableWidget(clients: filteredClients),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
//            القطع البرمجية الصغيرة (Widgets)
// ==========================================

// -- 1. العنوان وزرار الإضافة --
class ClientsHeaderWidget extends StatelessWidget {
  const ClientsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Client Management',
              style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your customers and track their purchases',
              style: TextStyle(color: kTextSecondary, fontSize: 16),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: فتح نافذ الحوار لإضافة عميل ( add_edit_client_dialog.dart )
          },
          icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
          label: const Text('Add New Client'),
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor,
            foregroundColor: kTextPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape:
                RoundedRectangleWithBorder(borderRadius: BorderRadius.circular(8)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// -- 2. كروت الإحصائيات الأربعة --
class ClientsStatsCardsWidget extends StatelessWidget {
  const ClientsStatsCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
            Icons.people_alt_outlined, kAccentColor, 'Total Clients', '1,284'),
        const SizedBox(width: 16),
        _buildStatCard(
            Icons.check_circle_outline, kGreenText, 'Active', '1,156'),
        const SizedBox(width: 16),
        _buildStatCard(
            Icons.error_outline, kAmberText, 'With Debt', '97'),
        const SizedBox(width: 16),
        _buildStatCard(
            Icons.attach_money_outlined, kRedText, 'Total Debt', '\$24.8K'),
      ],
    );
  }

  // كود بناء الكرت الواحد
  Widget _buildStatCard(
      IconData icon, Color iconColor, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kDividerColor, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(color: kTextSecondary, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        color: kTextPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -- 3. شريط البحث والفلتر --
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDividerColor, width: 0.5),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: kTextPrimary),
        decoration: InputDecoration(
          hintText: 'Search by name or email...',
          hintStyle: const TextStyle(color: kTextSecondary),
          prefixIcon: const Icon(Icons.search, color: kTextSecondary),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kDividerColor, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.filter_list, color: kTextSecondary, size: 18),
                const SizedBox(width: 8),
                const Text('Filters',
                    style: TextStyle(color: kTextSecondary, fontSize: 14)),
                const SizedBox(width: 12),
              ],
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// -- 4. جدول العملاء الرئيسي --
class ClientsTableWidget extends StatelessWidget {
  final List<Client> clients;

  const ClientsTableWidget({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    // استخدمنا ListView.separated بدلاً من DataTable ليكون التصميم مطابقاً تماماً
    return Column(
      children: [
        // هيدر الجدول
        _buildTableHeader(),
        // صفوف الجدول
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: clients.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ClientRowWidget(client: clients[index]);
            },
          ),
        ),
      ],
    );
  }

  // كود بناء هيدر الجدول
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Expanded(
              flex: 4,
              child: Text('Client', style: TextStyle(color: kTextSecondary))),
          Expanded(
              flex: 4,
              child: Text('Contact', style: TextStyle(color: kTextSecondary))),
          Expanded(
              flex: 3,
              child:
                  Text('Total Purchases', style: TextStyle(color: kTextSecondary))),
          Expanded(
              flex: 3,
              child: Text('Pending Debt', style: TextStyle(color: kTextSecondary))),
          Expanded(
              flex: 2,
              child:
                  Text('Installments', style: TextStyle(color: kTextSecondary))),
          Expanded(
              flex: 2,
              child: Text('Status', style: TextStyle(color: kTextSecondary))),
          SizedBox(width: 40, child: Text('Actions', style: TextStyle(color: kTextSecondary))),
        ],
      ),
    );
  }
}

// -- 4.1 صف العميل الواحد --
class ClientRowWidget extends StatelessWidget {
  final Client client;

  const ClientRowWidget({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kCardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kDividerColor, width: 0.3),
      ),
      child: Row(
        children: [
          // 1. عمود العميل (اللوجو والاسم والمدينة)
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: client.initialColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(client.initial,
                        style: const TextStyle(
                            color: kTextPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name,
                        style: const TextStyle(
                            color: kTextPrimary, fontWeight: FontWeight.w600)),
                    Text(client.location,
                        style:
                            const TextStyle(color: kTextSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // 2. عمود التواصل (الايميل والتليفون)
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactInfo(Icons.email_outlined, client.email),
                const SizedBox(height: 2),
                _buildContactInfo(Icons.phone_outlined, client.phone),
              ],
            ),
          ),

          // 3. إجمالي المشتريات
          Expanded(
            flex: 3,
            child: Text(
                '\$${client.totalPurchases.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: const TextStyle(color: kTextPrimary)),
          ),

          // 4. الديون المتبقية
          Expanded(
            flex: 3,
            child: Text('\$${client.pendingDebt.toStringAsFixed(0)}',
                style: TextStyle(
                    color: client.pendingDebt > 0 ? kAmberText : kGreenText,
                    fontWeight: FontWeight.w600)),
          ),

          // 5. الأقساط
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kAccentColor, width: 0.5),
              ),
              child: Text('${client.installments} active',
                  style: const TextStyle(color: kAccentColor, fontSize: 12)),
            ),
          ),

          // 6. الحالة
          Expanded(
            flex: 2,
            child: _buildStatusBadge(client.status),
          ),

          // 7. زرار الإجراءات
          SizedBox(
            width: 40,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: kTextSecondary),
              color: kCardColor,
              itemBuilder: (context) => [
                _buildPopupMenuItem('View Profile', Icons.person_outline),
                _buildPopupMenuItem('Edit Client', Icons.edit_outlined),
                _buildPopupMenuItem('Delete Client', Icons.delete_outline, color: kRedText),
              ],
              onSelected: (value) {
                // TODO: تنفيذ الإجراء بناءً على القيمة
              },
            ),
          ),
        ],
      ),
    );
  }

  // كود بناء ايقونة التواصل
  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kTextSecondary, size: 14),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(color: kTextSecondary, fontSize: 12)),
      ],
    );
  }

  // كود بناء شارة الحالة
  Widget _buildStatusBadge(String status) {
    Color textColor;
    switch (status.toLowerCase()) {
      case 'active':
        textColor = kGreenText;
        break;
      case 'has debt':
        textColor = kAmberText;
        break;
      case 'overdue':
        textColor = kRedText;
        break;
      default:
        textColor = kTextSecondary;
    }

    return Row(
      children: [
        Icon(Icons.check_circle, color: textColor, size: 12),
        const SizedBox(width: 4),
        Text(status, style: TextStyle(color: textColor, fontSize: 13)),
      ],
    );
  }

  // كود بناء عنصر القائمة المنبثقة
  PopupMenuItem<String> _buildPopupMenuItem(String title, IconData icon,
      {Color color = kTextPrimary}) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

// -- RoundedRectangleWithBorder مخصص --
class RoundedRectangleWithBorder extends RoundedRectangleBorder {
  const RoundedRectangleWithBorder({super.borderRadius, super.side});
}

// ==========================================
//          البيانات الوهمية (Mock Data)
// ==========================================
final List<Client> _mockClients = [
  Client(
    initial: 'J',
    initialColor: kAccentColor,
    name: 'John Doe',
    location: 'New York',
    email: 'john.doe@email.com',
    phone: '+1 234-567-8900',
    totalPurchases: 12450,
    pendingDebt: 0,
    installments: 0,
    status: 'Active',
  ),
  Client(
    initial: 'S',
    initialColor: Color(0xFF9C27B0),
    name: 'Sarah Smith',
    location: 'Los Angeles',
    email: 'sarah.smith@email.com',
    phone: '+1 234-567-8901',
    totalPurchases: 8900,
    pendingDebt: 1200,
    installments: 2,
    status: 'Has Debt',
  ),
  Client(
    initial: 'M',
    initialColor: Color(0xFF673AB7),
    name: 'Mike Johnson',
    location: 'Chicago',
    email: 'mike.j@email.com',
    phone: '+1 234-567-8902',
    totalPurchases: 15600,
    pendingDebt: 0,
    installments: 0,
    status: 'Active',
  ),
  Client(
    initial: 'E',
    initialColor: Color(0xFF009688),
    name: 'Emma Wilson',
    location: 'Houston',
    email: 'emma.w@email.com',
    phone: '+1 234-567-8903',
    totalPurchases: 5400,
    pendingDebt: 450,
    installments: 1,
    status: 'Has Debt',
  ),
  Client(
    initial: 'D',
    initialColor: Color(0xFFF44336),
    name: 'David Brown',
    location: 'Phoenix',
    email: 'david.b@email.com',
    phone: '+1 234-567-8904',
    totalPurchases: 23100,
    pendingDebt: 3200,
    installments: 3,
    status: 'Overdue',
  ),
];


// ==========================================
//      مكان الربط بـ C++ (للـ Dev A)
// ==========================================
// class ClientsViewModel with ChangeNotifier {
//   List<Client> _clients = [];
//   bool _isLoading = false;
//
//   // دالة لجلب البيانات من الـ DLL
//   Future<void> fetchClients() async {
//     _isLoading = true;
//     notifyListeners();
//
//     // 1. استدعاء دالة FFI المصدّرة من C++ ( clients_ffi.dart )
//     // 2. تحليل (Parse) الـ JSON الراجع من C++
//     // 3. تحويل JSON لـ List<ClientModel>
//
//     _isLoading = false;
//     notifyListeners();
//   }
// }