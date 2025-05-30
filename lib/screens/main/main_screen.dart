import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility/responsive.dart';
import 'components/side_menu.dart';
import 'provider/main_screen_provider.dart';
import '../../utility/extensions.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure the provider is accessible
    context.dataProvider; // Assuming this initializes or accesses the provider

    return Responsive(
      // Mobile layout with Drawer and hamburger menu
      mobile: _buildMobileLayout(context),
      // Tablet layout (optional, can fall back to mobile if null)
      tablet: _buildDesktopLayout(context),
      // Desktop layout with fixed sidebar
      desktop: _buildDesktopLayout(context),
    );
  }

  // Mobile layout with Drawer
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: SideMenu(), // Use SideMenu as the content of the Drawer
      ),
      body: SafeArea(
        child: Consumer<MainScreenProvider>(
          builder: (context, provider, child) {
            return provider.selectedScreen; // Display the selected screen
          },
        ),
      ),
    );
  }

  // Tablet/Desktop layout with fixed sidebar
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SideMenu(), // Fixed sidebar
            ),
            Expanded(
              flex: 5,
              child: Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  return provider.selectedScreen; // Display the selected screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}