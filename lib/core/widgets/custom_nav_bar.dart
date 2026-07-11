import 'package:flutter/material.dart';
import 'package:gymbook/core/widgets/custom_bottom_navbar.dart';
import 'package:gymbook/core/widgets/customer_nav_data.dart';
import 'package:gymbook/core/widgets/navigation_state.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/admin_nav_data.dart';
import 'package:gymbook/features/gator/presentation/widgets/gator_nav_data.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/services/user_role_service.dart';
import 'package:gymbook/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:gymbook/core/services/signalr_service.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  // ignore: library_private_types_in_public_api
  static _CustomNavBarState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomNavBarState>();

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late NavigationState _navState;
  late List<Map<String, dynamic>> _navItems;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _navState = NavigationState();
    _initializeNavigation();

    // For Customer role, initNotifications is handled by CustomerHomeScreenBody
    // (it waits for the location permission sheet to dismiss first, then requests
    // notification permission, so both dialogs never appear simultaneously).
    // For all other roles (admin, gator, owner), init here immediately.
    final role = sl<UserRoleService>().getCurrentRole();
    if (role != AppUserRole.customer) {
      sl<NotificationsCubit>().initNotifications();
    }
  }

  void _initializeNavigation() {
    final roleService = sl<UserRoleService>();
    final role = roleService.getCurrentRole();

    switch (role) {
      case AppUserRole.owner:
        _navItems = AdminNavData.items;
        _screens = AdminNavData.screens;
        break;
      case AppUserRole.branchAdmin:
        _navItems = AdminNavData.branchAdminItems;
        _screens = AdminNavData.branchAdminScreens;
        break;
      case AppUserRole.gator:
        _navItems = GatorNavData.items;
        _screens = GatorNavData.screens;
        break;
      case AppUserRole.customer:
        _navItems = CustomerNavData.items;
        _screens = CustomerNavData.screens;
        break;
    }

    if (role == AppUserRole.owner) {
      sl<SignalRService>().connect();
    }
  }

  void goBack() {
    setState(() {
      if (_navState.navigationStack.length > 1) {
        _navState.navigationStack.removeLast();
        _navState.selectedIndex = _navState.navigationStack.last;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _navState.navigationStack.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _navState.handleBackPress(() => setState(() {}));
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fa),
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _screens[_navState.selectedIndex],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          navItems: _navItems,
          navState: _navState,
          onItemTapped: (index) {
            setState(() {
              _navState.selectedIndex = index;
              _navState.navigationStack.add(index);
            });
          },
        ),
      ),
    );
  }
}
