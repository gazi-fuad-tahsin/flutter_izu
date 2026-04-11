import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  // Using RxString to trigger Obx rebuilds if needed, or just FutureBuilder
  final RxString _userRole = ''.obs;
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    // _checkUserRole();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  // }

  // @override
  // void dispose() {
  //   routeObserver.unsubscribe(this);
  //   super.dispose();
  // }

  @override
  void didPopNext() {
    // Called when the top screen is popped off, and this screen is visible again.
    // Refresh the current tab's data.
    if (Get.isRegistered<BottomNavController>()) {
      final controller = Get.find<BottomNavController>();
      controller.refreshDataForIndex(controller.currentIndex.value);
      print('🔄 Auto-refresh triggered on DashboardScreen (Member)');
    }
  }

  // Future<void> _checkUserRole() async {
  //   final role = await _authStorage.getRole();
  //   if (role != null) {
  //     _userRole.value = role;
  //   }
  //   _isLoading.value = false;
  // }

  // Member Screens
  final List<Widget> _memberScreens = const [
    // MemberHomeScreen(),
    // BarbershopScreen(),
    // BeardContestMemberScreen(),
    // ShopScreen(),
    // UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_isLoading.value) {
        return Scaffold(
          backgroundColor: const Color(0xFF0B090A),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 60),
                // const ShimmerWidget.rectangular(height: 30, width: 200),
                // const SizedBox(height: 10),
                // const ShimmerWidget.rectangular(height: 15, width: 150),
                // const SizedBox(height: 40),
                // Expanded(
                //   child: ListView.builder(
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: 6,
                //     itemBuilder: (context, index) => const Padding(
                //       padding: EdgeInsets.only(bottom: 20),
                //       child: ShimmerCard(),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }

      // If user is an Admin, show Admin Main Screen with bottom navigation
      if (_userRole.value == 'admin') {
        // // Initialize AdminDashboardBinding and AdminBottomNavController if not already registered
        // if (!Get.isRegistered<AdminDashboardController>()) {
        //   AdminDashboardBinding().dependencies();
        // }
        // if (!Get.isRegistered<AdminBottomNavController>()) {
        //   Get.put(AdminBottomNavController());
        // }
        // return const AdminMainScreen();
      }

      // If user is a Barber, show Barbershop Main Screen
      // Checking for 'berber' (API value) or 'barber' just in case
      if (_userRole.value == 'berber' || _userRole.value == 'barber') {
        // return const BarbershopMainScreen();
      }

      // Default: Member Dashboard
      // Ensure controller is registered for Member flow
      final BottomNavController navController =
          Get.isRegistered<BottomNavController>()
          ? Get.find<BottomNavController>()
          : Get.put(BottomNavController());

      return Scaffold(
        body: Obx(() => _memberScreens[navController.currentIndex.value]),
        // bottomNavigationBar: CustomBottomNavBar(),
      );
    });
  }
}
