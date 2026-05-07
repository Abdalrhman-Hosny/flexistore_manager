import 'package:flutter/material.dart';

// -- 1. الألوان المطابقة للتصميم الاحترافي --
const kBackgroundColor = Color(0xFF0F171E);
const kCardColor = Color(0xFF192229);
const kAccentColor = Color(0xFF007AFF);
const kTextPrimary = Colors.white;
const kTextSecondary = Color(0xFF8E99A3);
const kDividerColor = Color(0xFF2C363F);

// ألوان الحالات (Badges)
const kGreenBg = Color(0xFF0B251E);
const kGreenText = Color(0xFF2ECC71);
const kOrangeBg = Color(0xFF2E2417);
const kOrangeText = Color(0xFFF39C12);
const kRedBg = Color(0xFF2C1A1D);
const kRedText = Color(0xFFE74C3C);



// -- 2. الموديل --
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

// -- 3. الشاشة الأساسية --
class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<Client> filteredClients = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredClients = _mockClients;
  }

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
    // حساب الإحصائيات الفعلي
    int totalCount = filteredClients.length;
    int activeCount = filteredClients.where((c) => c.status == 'Active').length;
    int debtCount = filteredClients.where((c) => c.pendingDebt > 0).length;
    double sumDebt = filteredClients.fold(0, (sum, c) => sum + c.pendingDebt);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ClientsHeaderWidget(),
            const SizedBox(height: 30),
            ClientsStatsCardsWidget(
              total: totalCount,
              active: activeCount,
              withDebt: debtCount,
              totalDebt: sumDebt,
            ),
            const SizedBox(height: 30),
            SearchBarWidget(
              controller: _searchController,
              onChanged: _filterClients,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ClientsTableWidget(clients: filteredClients),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ويدجت الهيدر ---
class ClientsHeaderWidget extends StatelessWidget {
  const ClientsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Management',
                style: TextStyle(color: kTextPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Manage your customers and track their purchases',
                style: TextStyle(color: kTextSecondary, fontSize: 16)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
          label: const Text('Add New Client'),
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor,
            foregroundColor: kTextPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

// --- ويدجت الكروت ---
class ClientsStatsCardsWidget extends StatelessWidget {
  final int total;
  final int active;
  final int withDebt;
  final double totalDebt;

  const ClientsStatsCardsWidget({super.key, required this.total, required this.active, required this.withDebt, required this.totalDebt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(Icons.person_add_outlined, kAccentColor, 'Total Clients', total.toString()),
        const SizedBox(width: 20),
        _buildStatCard(Icons.check_circle_outline, kGreenText, 'Active', active.toString()),
        const SizedBox(width: 20),
        _buildStatCard(Icons.error_outline, kOrangeText, 'With Debt', withDebt.toString()),
        const SizedBox(width: 20),
        _buildStatCard(Icons.attach_money, kRedText, 'Total Debt', '\$${(totalDebt / 1000).toStringAsFixed(1)}K'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, Color color, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kCardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDividerColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kBackgroundColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: kTextSecondary, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- ويدجت البحث ---
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  const SearchBarWidget({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: kDividerColor)),
      child: Row(
        children: [
          const Icon(Icons.search, color: kTextSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(hintText: 'Search by name or email...', hintStyle: TextStyle(color: kTextSecondary), border: InputBorder.none),
            ),
          ),
          const Icon(Icons.tune, color: kTextSecondary, size: 20),
          const SizedBox(width: 8),
          const Text('Filters', style: TextStyle(color: kTextSecondary)),
        ],
      ),
    );
  }
}

// --- الجدول والصفوف ---
class ClientsTableWidget extends StatelessWidget {
  final List<Client> clients;
  const ClientsTableWidget({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: const [
              Expanded(flex: 3, child: Text('Client', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 3, child: Text('Contact', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Total Purchases', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Pending Debt', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Installments', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Status', style: TextStyle(color: kTextSecondary))),
              SizedBox(width: 40, child: Center(child: Text('Actions', style: TextStyle(color: kTextSecondary)))),
            ],
          ),
        ),
        const Divider(color: kDividerColor, height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) => ClientRowWidget(client: clients[index]),
          ),
        ),
      ],
    );
  }
}

class ClientRowWidget extends StatelessWidget {
  final Client client;
  const ClientRowWidget({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kDividerColor, width: 0.5))),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Client
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: client.initialColor, radius: 18, child: Text(client.initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(client.location, style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          // Contact
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.email, style: const TextStyle(fontSize: 13)),
                Text(client.phone, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
              ],
            ),
          ),
          // Purchases
          Expanded(flex: 2, child: Text('\$${client.totalPurchases.toInt()}')),
          // Debt
          Expanded(
            flex: 2,
            child: Text('\$${client.pendingDebt.toInt()}', style: TextStyle(color: client.pendingDebt > 0 ? kOrangeText : kGreenText, fontWeight: FontWeight.bold)),
          ),
          // --- ضبط الـ Padding للمسافات المطلوبة ---
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2E3D),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kAccentColor.withOpacity(0.3)),
                ),
                child: Text('${client.installments} active', style: const TextStyle(color: Color(0xFF5EADFF), fontSize: 12)),
              ),
            ),
          ),
          const SizedBox(width: 8), // مسافة ثابتة بين الحقلين
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: _buildStatusBadge(client.status),
            ),
          ),
          const SizedBox(width: 40, child: Icon(Icons.more_vert, color: kTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = kGreenBg; Color text = kGreenText; IconData icon = Icons.check_circle;
    if (status == 'Has Debt') { bg = kOrangeBg; text = kOrangeText; icon = Icons.info_outline; }
    if (status == 'Overdue') { bg = kRedBg; text = kRedText; icon = Icons.error_outline; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 6),
          Text(status, style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// -- بيانات تجريبية --
final List<Client> _mockClients = [
  Client(initial: 'J', initialColor: Colors.blue, name: 'John Doe', location: 'New York', email: 'john@email.com', phone: '+1 234', totalPurchases: 12450, pendingDebt: 0, installments: 0, status: 'Active'),
  Client(initial: 'S', initialColor: Colors.purple, name: 'Sarah Smith', location: 'Los Angeles', email: 'sarah@email.com', phone: '+1 567', totalPurchases: 8900, pendingDebt: 1200, installments: 2, status: 'Has Debt'),
];