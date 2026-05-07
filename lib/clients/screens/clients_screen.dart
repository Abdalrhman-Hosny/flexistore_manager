import 'package:flutter/material.dart';

// -- الألوان --
const kBackgroundColor = Color(0xFF0F171E);
const kCardColor = Color(0xFF192229);
const kAccentColor = Color(0xFF007AFF);
const kTextPrimary = Colors.white;
const kTextSecondary = Color(0xFF8E99A3);
const kDividerColor = Color(0xFF2C363F);

const kGreenBg = Color(0xFF0B251E);
const kGreenText = Color(0xFF2ECC71);
const kOrangeBg = Color(0xFF2E2417);
const kOrangeText = Color(0xFFF39C12);
const kRedBg = Color(0xFF2C1A1D);
const kRedText = Color(0xFFE74C3C);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: kBackgroundColor),
      home: const ClientsScreen(),
    );
  }
}

// -- الموديل --
class Client {
  final String id; // معرف فريد للحذف
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
    required this.id,
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
  // القائمة الأصلية (مصدر البيانات الثابت للإحصائيات)
  final List<Client> _allClients = [
    Client(id: '1', initial: 'J', initialColor: Colors.blue, name: 'John Doe', location: 'New York', email: 'john@email.com', phone: '+1 234', totalPurchases: 12450, pendingDebt: 0, installments: 0, status: 'Active'),
    Client(id: '2', initial: 'S', initialColor: Colors.purple, name: 'Sarah Smith', location: 'Los Angeles', email: 'sarah@email.com', phone: '+1 567', totalPurchases: 8900, pendingDebt: 1200, installments: 2, status: 'Has Debt'),
    Client(id: '3', initial: 'M', initialColor: Colors.orange, name: 'Mike Ross', location: 'Chicago', email: 'mike@email.com', phone: '+1 888', totalPurchases: 5000, pendingDebt: 3000, installments: 5, status: 'Overdue'),
  ];

  List<Client> _filteredClients = [];
  String _searchQuery = "";
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _filteredClients = _allClients;
  }

  // تحديث البحث والفلترة معاً
  void _applyFilters() {
    setState(() {
      _filteredClients = _allClients.where((client) {
        final matchesSearch = client.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                             client.email.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesStatus = _selectedFilter == "All" || client.status == _selectedFilter;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _deleteClient(String id) {
    setState(() {
      _allClients.removeWhere((c) => c.id == id);
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    // حساب الإحصائيات من القائمة الكاملة (_allClients) لتبقى ثابتة
    int totalCount = _allClients.length;
    int activeCount = _allClients.where((c) => c.status == 'Active').length;
    int debtCount = _allClients.where((c) => c.pendingDebt > 0).length;
    double sumDebt = _allClients.fold(0, (sum, c) => sum + c.pendingDebt);

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
            // شريط البحث مع زر الفلترة
            SearchBarWidget(
              onSearchChanged: (val) {
                _searchQuery = val;
                _applyFilters();
              },
              onFilterChanged: (val) {
                _selectedFilter = val;
                _applyFilters();
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ClientsTableWidget(
                clients: _filteredClients,
                onDelete: _deleteClient,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ويدجت البحث والفلترة ---
class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;

  const SearchBarWidget({super.key, required this.onSearchChanged, required this.onFilterChanged});

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
              onChanged: onSearchChanged,
              decoration: const InputDecoration(hintText: 'Search by name or email...', hintStyle: TextStyle(color: kTextSecondary), border: InputBorder.none),
            ),
          ),
          // زر الفلترة الاحترافي
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune, color: kTextSecondary, size: 20),
            tooltip: "Filter Status",
            onSelected: onFilterChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "All", child: Text("All Clients")),
              const PopupMenuItem(value: "Active", child: Text("Active")),
              const PopupMenuItem(value: "Has Debt", child: Text("Has Debt")),
              const PopupMenuItem(value: "Overdue", child: Text("Overdue")),
            ],
          ),
          const Text('Filter', style: TextStyle(color: kTextSecondary)),
        ],
      ),
    );
  }
}

// --- الجدول ---
class ClientsTableWidget extends StatelessWidget {
  final List<Client> clients;
  final Function(String) onDelete;
  const ClientsTableWidget({super.key, required this.clients, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('Client', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 3, child: Text('Contact', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Total Purchases', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Pending Debt', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Installments', style: TextStyle(color: kTextSecondary))),
              Expanded(flex: 2, child: Text('Status', style: TextStyle(color: kTextSecondary))),
              SizedBox(width: 80, child: Center(child: Text('Actions', style: TextStyle(color: kTextSecondary)))),
            ],
          ),
        ),
        const Divider(color: kDividerColor, height: 1),
        Expanded(
          child: clients.isEmpty 
            ? const Center(child: Text("No clients found", style: TextStyle(color: kTextSecondary)))
            : ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) => ClientRowWidget(
                  client: clients[index],
                  onDelete: () => onDelete(clients[index].id),
                ),
              ),
        ),
      ],
    );
  }
}

class ClientRowWidget extends StatelessWidget {
  final Client client;
  final VoidCallback onDelete;
  const ClientRowWidget({super.key, required this.client, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kDividerColor, width: 0.5))),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Client Info
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
          // Contact Info
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
          Expanded(flex: 2, child: Text('\$${client.totalPurchases.toInt()}')),
          Expanded(
            flex: 2,
            child: Text('\$${client.pendingDebt.toInt()}', style: TextStyle(color: client.pendingDebt > 0 ? kOrangeText : kGreenText, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF1B2E3D), borderRadius: BorderRadius.circular(20)),
                child: Text('${client.installments} active', style: const TextStyle(color: Color(0xFF5EADFF), fontSize: 11)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: _buildStatusBadge(client.status),
            ),
          ),
          // Actions: تعديل وحذف
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: kAccentColor, size: 20),
                  onPressed: () { /* وظيفة التعديل هنا */ },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: kRedText, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = kGreenBg; Color text = kGreenText;
    if (status == 'Has Debt') { bg = kOrangeBg; text = kOrangeText; }
    if (status == 'Overdue') { bg = kRedBg; text = kRedText; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

// --- الهيدر (بدون تغيير كبير) ---
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
            Text('Client Management', style: TextStyle(color: kTextPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            Text('Manage your customers and track their data', style: TextStyle(color: kTextSecondary, fontSize: 16)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
          label: const Text('Add New Client'),
          style: ElevatedButton.styleFrom(backgroundColor: kAccentColor, foregroundColor: kTextPrimary, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
        ),
      ],
    );
  }
}

// --- كروت الإحصائيات ---
class ClientsStatsCardsWidget extends StatelessWidget {
  final int total; final int active; final int withDebt; final double totalDebt;
  const ClientsStatsCardsWidget({super.key, required this.total, required this.active, required this.withDebt, required this.totalDebt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(Icons.people_outline, kAccentColor, 'Total Clients', total.toString()),
        const SizedBox(width: 16),
        _buildStatCard(Icons.check_circle_outline, kGreenText, 'Active', active.toString()),
        const SizedBox(width: 16),
        _buildStatCard(Icons.warning_amber_rounded, kOrangeText, 'With Debt', withDebt.toString()),
        const SizedBox(width: 16),
        _buildStatCard(Icons.monetization_on_outlined, kRedText, 'Total Debt', '\$${(totalDebt / 1000).toStringAsFixed(1)}K'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, Color color, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: kCardColor.withOpacity(0.4), borderRadius: BorderRadius.circular(16), border: Border.all(color: kDividerColor)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                Text(value, style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}