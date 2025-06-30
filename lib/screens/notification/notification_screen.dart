import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import '../../utility/responsive.dart';
import 'components/notification_header.dart';
import 'components/notification_list_section.dart';
import 'package:admin/utility/extensions.dart';

import 'components/send_notification_form.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.dataProvider.getAllNotifications();
    return Responsive(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationHeader(isMobile: true),
            Gap(defaultPadding * 0.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Notifications",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 0.75,
                              vertical: defaultPadding * 0.5,
                            ),
                          ),
                          onPressed: () {
                            sendNotificationForm(context);
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text("Send", style: TextStyle(fontSize: 12)),
                        ),
                        Gap(8),
                        IconButton(
                          onPressed: () {
                            context.dataProvider.getAllNotifications(showSnack: true);
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(defaultPadding * 0.5),
                NotificationListSection(isMobile: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding * 0.75),
        child: Column(
          children: [
            NotificationHeader(),
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "My Notifications",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.25,
                                vertical: defaultPadding * 0.75,
                              ),
                            ),
                            onPressed: () {
                              sendNotificationForm(context);
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text("Send New", style: TextStyle(fontSize: 14)),
                          ),
                          Gap(12),
                          IconButton(
                            onPressed: () {
                              context.dataProvider.getAllNotifications(showSnack: true);
                            },
                            icon: const Icon(Icons.refresh, size: 22),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      NotificationListSection(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            NotificationHeader(),
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "My Notifications",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              sendNotificationForm(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Send New"),
                          ),
                          Gap(16),
                          IconButton(
                            onPressed: () {
                              context.dataProvider.getAllNotifications(showSnack: true);
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      NotificationListSection(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}