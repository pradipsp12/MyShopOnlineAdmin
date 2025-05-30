import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../utility/constants.dart';
import 'package:admin/utility/extensions.dart';

import '../../../utility/responsive.dart';

class NotificationHeader extends StatelessWidget {
  final bool isMobile;

  const NotificationHeader({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notifications",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              Gap(defaultPadding * 0.5),
              SearchField(
                onChange: (val) {
                  context.dataProvider.filterNotifications(val);
                },
              ),
              Gap(defaultPadding * 0.5),
              ProfileCard(isMobile: true),
            ],
          )
        : Row(
            children: [
              Text(
                "Notifications",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(flex: 2),
              Expanded(
                child: SearchField(
                  onChange: (val) {
                    context.dataProvider.filterNotifications(val);
                  },
                ),
              ),
              ProfileCard(),
            ],
          );
  }
}

class ProfileCard extends StatelessWidget {
  final bool isMobile;

  const ProfileCard({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isMobile ? 0 : defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding,
        vertical: isMobile ? defaultPadding * 0.25 : defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: isMobile ? 28 : 38,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 28),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.25 : defaultPadding / 2),
            child: Text(
              context.authServiceProvider.getLoginUsr()?.name ?? "Admin",
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, size: isMobile ? 16 : 20),
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'logout') {
                context.authServiceProvider.logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 18),
                    Gap(defaultPadding * 0.5),
                    const Text('Logout', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final Function(String) onChange;

  const SearchField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(fontSize: isMobile ? 12 : 14),
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.25 : defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: isMobile ? 16 : 20,
              width: isMobile ? 16 : 20,
            ),
          ),
        ),
      ),
      style: TextStyle(fontSize: isMobile ? 12 : 14),
      onChanged: onChange,
    );
  }
}