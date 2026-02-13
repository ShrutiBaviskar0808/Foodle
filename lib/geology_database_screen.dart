import 'package:flutter/material.dart';
import 'stones_tab.dart';
import 'minerals_tab.dart';

class GeologyDatabaseScreen extends StatefulWidget {
  const GeologyDatabaseScreen({super.key});

  @override
  State<GeologyDatabaseScreen> createState() => _GeologyDatabaseScreenState();
}

class _GeologyDatabaseScreenState extends State<GeologyDatabaseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Stone & Mineral Explorer', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.brown),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.brown,
          indicatorWeight: 3,
          labelColor: Colors.brown,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Stones'),
            Tab(text: 'Minerals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StonesTab(),
          MineralsTab(),
        ],
      ),
    );
  }
}
