import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              if (dataProvider.isLoading) {
                return _buildShimmerEffect(
                  isMobile: isMobile,
                  isTablet: isTablet,
                  context: context,
                );
              }
              return LayoutBuilder(
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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect({
    required bool isMobile,
    required bool isTablet,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnSpacing = isMobile ? defaultPadding * 0.5 : defaultPadding;
    
    // Calculate column widths as percentages of screen width
    final titleColumnWidth = screenWidth * (isMobile ? 0.25 : 0.2);
    final descColumnWidth = screenWidth * (isMobile ? 0.3 : 0.25);
    final dateColumnWidth = screenWidth * (isMobile ? 0.2 : 0.15);
    final actionColumnWidth = screenWidth * (isMobile ? 0.1 : 0.08);
    final totalTableWidth = titleColumnWidth + descColumnWidth + 
                          dateColumnWidth + (actionColumnWidth * 2) + 
                          (columnSpacing * 4);

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalTableWidth,
            child: DataTable(
              columnSpacing: columnSpacing,
              dataRowMinHeight: isMobile ? 40 : isTablet ? 44 : 48,
              dataRowMaxHeight: isMobile ? 48 : isTablet ? 52 : 56,
              headingTextStyle: TextStyle(
                fontSize: isMobile ? 12 : isTablet ? 13 : 14,
                color: Colors.white70,
              ),
              columns: [
                DataColumn(label: _buildShimmerCell(titleColumnWidth)),
                DataColumn(label: _buildShimmerCell(descColumnWidth)),
                DataColumn(label: _buildShimmerCell(dateColumnWidth)),
                DataColumn(label: _buildShimmerCell(actionColumnWidth)),
                DataColumn(label: _buildShimmerCell(actionColumnWidth)),
              ],
              rows: List.generate(
                5,
                (index) => DataRow(
                  cells: [
                    DataCell(Row(
                      children: [
                        Container(
                          width: isMobile ? 18 : 24,
                          height: isMobile ? 18 : 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: columnSpacing),
                        _buildShimmerCell(titleColumnWidth - 24 - columnSpacing, height: 16),
                      ],
                    )),
                    DataCell(_buildShimmerCell(descColumnWidth, height: 16)),
                    DataCell(_buildShimmerCell(dateColumnWidth, height: 16)),
                    DataCell(_buildShimmerCell(actionColumnWidth, height: isMobile ? 30 : 40)),
                    DataCell(_buildShimmerCell(actionColumnWidth, height: isMobile ? 30 : 40)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCell(double width, {double height = 16}) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
    );
  }

  Widget _buildDataTable(BuildContext context, BoxConstraints constraints, double columnSpacing) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final double minTableWidth = isDesktop
        ? constraints.maxWidth
        : isTablet
            ? constraints.maxWidth * 0.9
            : 600;

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