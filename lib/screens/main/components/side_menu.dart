import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utility/responsive.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Dashboard');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Category",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Category');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Sub Category",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('SubCategory');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Brands",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Brands');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Variant Type",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('VariantType');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Variants",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Variants');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Orders",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Order');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Coupons",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Coupon');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Posters",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Poster');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
          DrawerListTile(
            title: "Notifications",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Notifications');
              if (Responsive.isMobile(context)) {
                Navigator.pop(context); // Close drawer on mobile
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
