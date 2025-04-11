import 'package:dash_logistics/screens.dart/account_screen.dart';
import 'package:dash_logistics/screens.dart/cleint_feed_back_screen.dart';
import 'package:dash_logistics/screens.dart/notification_screen.dart';
import 'package:dash_logistics/screens.dart/order_form.dart';
import 'package:dash_logistics/screens.dart/pickUp_list.dart';
import 'package:dash_logistics/screens.dart/product_price_list.dart';
import 'package:dash_logistics/screens.dart/rates.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dash_logistics/screens.dart/orders.dart';
import 'package:dash_logistics/screens.dart/order_detail.dart'; // Added import for OrderDetailsScreen
import 'package:dash_logistics/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:dash_logistics/repositories/order_repositries.dart';
import 'package:dash_logistics/models/order_search_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    OrdersScreen(),
    OrderFormScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        backgroundColor: AppColors.whiteCol,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.whiteCol,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Icon(
                  Icons.exit_to_app,
                  size: 40,
                  color: AppColors.grey.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to exit the app?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dashBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whiteCol,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      SystemNavigator.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whiteCol,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _showExitDialog(context),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "Notifications"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.grey,
          backgroundColor: AppColors.white,
          elevation: 4,
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderFormScreen()),
              );
            } else {
              _onItemTapped(index);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderFormScreen()),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedGraph = 0;
  final OrderRepository _repository = OrderRepository();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final Map<String, dynamic> dashboardData = {
    'totalOrders': 86,
    'totalCOD': 265919,
    'totalRTV': 0,
    'deliveryCharge': 8375,
    'pendingCOD': 237544,
    'lastCODPayment': 500,
    'todaysOrders': 8,
    'todaysDelivered': 5,
    'todaysRescheduled': 2,
    'todaysCancellation': 1,
    'openTickets': 0,
    'dailyOrderStatus': [
      {'date': '3-21', 'value': 5},
      {'date': '3-22', 'value': 9},
      {'date': '3-23', 'value': 10},
      {'date': '3-24', 'value': 5},
      {'date': '3-25', 'value': 2},
      {'date': '3-26', 'value': 7},
      {'date': '3-27', 'value': 4},
    ],
    'ordersDelivered': [
      {'date': '3-16', 'value': 2},
      {'date': '3-17', 'value': 5},
      {'date': '3-18', 'value': 9},
      {'date': '3-19', 'value': 4},
      {'date': '3-20', 'value': 1},
      {'date': '3-21', 'value': 8},
      {'date': '3-22', 'value': 6},
    ],
    'stationOrderStatus': {'insideValley': 71.33, 'outsideValley': 28.67},
  };

  Future<void> _searchOrder(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      // Validate query
      if (RegExp(r'^\d{10}$').hasMatch(query)) {
        // Phone number: 10 digits
        final response = await _repository.searchOrder(query);
        if (response.details.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersScreen(query: query),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'No results found for "$query"');
        }
      } else if (RegExp(r'^[A-Za-z0-9]{14}$').hasMatch(query)) {
        // Tracking code: 14 alphanumeric characters
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(trackingCode: query),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "Invalid query: Phone must be 10 digits, Tracking must be 14 characters.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Search failed: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Let's track your package",
                            style: TextStyle(
                              color: AppColors.whiteCol,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Tracking / Phone',
                                    prefixIcon: _isSearching
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: AppColors.grey,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.search),
                                    filled: true,
                                    fillColor: AppColors.whiteCol,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onSubmitted: (value) => _searchOrder(value.trim()),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.whiteCol,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.qr_code_scanner,
                                      color: AppColors.redColor),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: ActionCards(),
                      ),
                    ),
                    _buildDashboardData(context, dashboardData),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardData(BuildContext context, Map<String, dynamic> data) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 16, 2, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "COD",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dashBlue,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            "Total Orders",
                            "${data['totalOrders']}",
                            AppColors.black,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersScreen()));
                            },
                          ),
                          _buildStatCard("TOTAL COD", "${data['totalCOD']}",
                              AppColors.black, onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListScreen()));
                          }),
                          _buildStatCard("TOTAL RTV", "${data['totalRTV']}",
                              AppColors.black, onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListScreen()));
                          }),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              "DELIVERY CHARGE",
                              "${data['deliveryCharge']}",
                              AppColors.black, onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListScreen()));
                          }),
                          _buildStatCard("PENDING COD", "${data['pendingCOD']}",
                              AppColors.black, onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListScreen()));
                          }),
                          _buildStatCard(
                              "LAST COD PAYMENT",
                              "${data['lastCODPayment']}",
                              AppColors.black, onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListScreen()));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 16, 2, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Orders",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dashBlue,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard("Today's Orders",
                              "${data['todaysOrders']}", AppColors.black),
                          _buildStatCard("Today's Delivered",
                              "${data['todaysDelivered']}", AppColors.black),
                          _buildStatCard("Today's Rescheduled",
                              "${data['todaysRescheduled']}", AppColors.black),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              "Today's Cancellation",
                              "${data['todaysCancellation']}",
                              AppColors.black),
                          _buildStatCard(
                              "Open Tickets", "${data['openTickets']}", AppColors.black),
                          const SizedBox(width: 95),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGraph = 0;
                              });
                            },
                            child: Text(
                              "Daily Order",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedGraph == 0
                                    ? AppColors.dashBlue
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGraph = 1;
                              });
                            },
                            child: Text(
                              "Order Delivered",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedGraph == 1
                                    ? AppColors.dashBlue
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final dataKey = _selectedGraph == 0
                                        ? 'dailyOrderStatus'
                                        : 'ordersDelivered';
                                    final dates = data[dataKey]
                                        .map((e) => e['date'])
                                        .toList();
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < dates.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          dates[value.toInt()],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.black,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  data[_selectedGraph == 0
                                          ? 'dailyOrderStatus'
                                          : 'ordersDelivered']
                                      .length,
                                  (index) => FlSpot(
                                    index.toDouble(),
                                    data[_selectedGraph == 0
                                            ? 'dailyOrderStatus'
                                            : 'ordersDelivered'][index]['value']
                                        .toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: AppColors.blueAccent,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                                dashArray: [2, 2],
                              ),
                            ],
                            minY: 0,
                            maxY: 25,
                            backgroundColor: AppColors.grey[100],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Orders Delivered",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dashBlue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final dates = data['ordersDelivered']
                                        .map((e) => e['date'])
                                        .toList();
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < dates.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          dates[value.toInt()],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.black,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(
                              data['ordersDelivered'].length,
                              (index) => BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: data['ordersDelivered'][index]['value']
                                        .toDouble(),
                                    color: AppColors.blueAccent,
                                    width: 8,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                            ),
                            minY: 0,
                            maxY: 20,
                            backgroundColor: AppColors.grey[100],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          "Station Order Status (%)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dashBlue,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.pinkRedGra,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text("inside valley"),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.blueGra,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text("outside valley"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: data['stationOrderStatus']
                                    ['insideValley'],
                                title:
                                    "${data['stationOrderStatus']['insideValley']}%",
                                color: AppColors.blueGra,
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteCol,
                                ),
                              ),
                              PieChartSectionData(
                                value: data['stationOrderStatus']
                                    ['outsideValley'],
                                title:
                                    "${data['stationOrderStatus']['outsideValley']}%",
                                color: AppColors.pinkRedGra,
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteCol,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 40,
                            sectionsSpace: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 370,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.greenC,
                    AppColors.darkGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Special Offers',
                          style: TextStyle(
                            color: AppColors.whiteCol,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '50% Off On First\nOnline Payment',
                          style: TextStyle(
                            color: AppColors.whiteCol,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Until the end of January 2025',
                          style: TextStyle(
                            color: AppColors.whiteCol.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.redColor,
                        ),
                        child: Center(
                          child: Text(
                            '50%',
                            style: TextStyle(
                              color: AppColors.whiteCol,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCards extends StatelessWidget {
  const ActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionCard(
          Icons.attach_money,
          "Rates",
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryRateScreen()),
            );
          },
        ),
        _buildActionCard(
          Icons.local_shipping,
          "Pick Up",
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PickupScreen()),
            );
          },
        ),
        _buildActionCard(
          Icons.calendar_month,
          "Date",
          () async {
            final DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              print("Date range selected: ${picked.start} - ${picked.end}");
            }
          },
        ),
        _buildActionCard(
          Icons.feedback,
          "Feed",
          () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ClientFeedbackScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String label, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.primaryColor.withOpacity(0.4),
        highlightColor: AppColors.grey.withOpacity(0.2),
        child: Container(
          width: 70,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.black54, size: 30),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}