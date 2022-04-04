import 'package:flutter/material.dart';
import 'package:supabase_quickstart/components/auth_state.dart';
import 'package:supabase_quickstart/pages/tab_screens/account_page.dart';
import 'package:supabase_quickstart/pages/tab_screens/home_page.dart';
import 'package:supabase_quickstart/pages/tab_screens/my_order_page.dart';
import 'package:supabase_quickstart/utils/colors.dart';

class TabLayout extends StatefulWidget {
  const TabLayout({Key? key}) : super(key: key);

  @override
  State<TabLayout> createState() => _TabLayoutState();
}

class _TabLayoutState extends AuthState<TabLayout> {
  late PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: <Widget>[
              HomePage(),
              MyOrderPage(),
              AccountPage(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 7.0),
              barIcon(icon: Icons.home, page: 0),
              barIcon(icon: Icons.list_alt, page: 1),
              barIcon(icon: Icons.person, page: 2),
              SizedBox(width: 7.0),
              ],
          ),
          color: Theme.of(context).colorScheme.surface,
          ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  Widget barIcon(
      {IconData icon = Icons.home, int page = 0, bool badge = false}) {
    return IconButton(
      icon: Icon(icon, size: 24.0),
      color:
      _page == page ? Color(0xFF90A4AE) : Theme.of(context).colorScheme.onSurface,
      onPressed: () => _pageController.jumpToPage(page),
    );
  }
}
