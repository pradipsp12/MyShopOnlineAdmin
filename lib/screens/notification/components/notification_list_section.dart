import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/my_notification.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../../../utility/responsive.dart';
import 'send_notification_form.dart';
import 'view_notification_form.dart';

class NotificationListSection extends StatelessWidget {
  final bool isMobile;

  const NotificationListSection({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final double columnSpacing = isMobile
        ? defaultPadding * 0.5
        : isTablet
            ? defaultPadding * 1.25
            : defaultPadding * 1.5;

    return Container(
      padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Notifications",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isMobile ? 14 : 16,
                ),
          ),
          Gap(defaultPadding * 0.5),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: double.infinity,
                child: isMobile
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildDataTable(context, constraints, columnSpacing),
                      )
                    : _buildDataTable(context, constraints, columnSpacing),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, BoxConstraints constraints, double columnSpacing) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final double minTableWidth = isDesktop
        ? constraints.maxWidth
        : isTablet
            ? constraints.maxWidth * 0.9
            : 600; // Minimum width for mobile to ensure content fits

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minTableWidth),
      child: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          return DataTable(
            columnSpacing: columnSpacing,
            dataRowMinHeight: isMobile ? 40 : isTablet ? 44 : 48,
            dataRowMaxHeight: isMobile ? 48 : isTablet ? 52 : 56,
            headingTextStyle: TextStyle(
              fontSize: isMobile ? 12 : isTablet ? 13 : 14,
              color: Colors.white70,
            ),
            dataTextStyle: TextStyle(
              fontSize: isMobile ? 12 : isTablet ? 13 : 14,
              color: Colors.white,
            ),
            columns: const [
              DataColumn(label: Text("Title")),
              DataColumn(label: Text("Description")),
              DataColumn(label: Text("Send Date")),
              DataColumn(label: Text("View")),
              DataColumn(label: Text("Delete")),
            ],
            rows: List.generate(
              dataProvider.notifications.length,
              (index) => notificationDataRow(
                dataProvider.notifications[index],
                index + 1,
                edit: () {
                  viewNotificationStatics(context, dataProvider.notifications[index]);
                },
                delete: () {
                  deleteNotificationDialog(context, dataProvider.notifications[index]);
                },
                isMobile: isMobile,
                isTablet: isTablet,
              ),
            ),
          );
        },
      ),
    );
  }
}

DataRow notificationDataRow(
  MyNotification notificationInfo,
  int index, {
  Function? edit,
  Function? delete,
  bool isMobile = false,
  bool isTablet = false,
}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: isMobile ? 18 : isTablet ? 20 : 24,
              width: isMobile ? 18 : isTablet ? 20 : 24,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: TextStyle(
                    fontSize: isMobile ? 10 : isTablet ? 11 : 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding),
                child: Text(
                  notificationInfo.title ?? '',
                  style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          notificationInfo.description ?? '',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          notificationInfo.createdAt ?? '',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        IconButton(
          onPressed: edit as void Function()?,
          icon: Icon(
            Icons.remove_red_eye_sharp,
            color: Colors.white,
            size: isMobile ? 16 : isTablet ? 18 : 20,
          ),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: delete as void Function()?,
          icon: Icon(
            Icons.delete,
            color: Colors.red,
            size: isMobile ? 16 : isTablet ? 18 : 20,
          ),
        ),
      ),
    ],
  );
}