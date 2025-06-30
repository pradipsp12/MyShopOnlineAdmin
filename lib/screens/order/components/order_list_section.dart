import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/order.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../../../utility/responsive.dart';
import 'view_order_form.dart';

class OrderListSection extends StatelessWidget {
  final bool isMobile;

  const OrderListSection({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final double columnSpacing = isMobile
        ? defaultPadding * 0.5
        : isTablet
            ? defaultPadding * 0.8
            : defaultPadding;

    return Container(
      padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Orders",
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
                            child: _buildDataTable(context, constraints, columnSpacing, dataProvider),
                          )
                        : _buildDataTable(context, constraints, columnSpacing, dataProvider),
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
    final customerColumnWidth = screenWidth * (isMobile ? 0.25 : 0.2);
    final amountColumnWidth = screenWidth * (isMobile ? 0.15 : 0.1);
    final paymentColumnWidth = screenWidth * (isMobile ? 0.15 : 0.1);
    final statusColumnWidth = screenWidth * (isMobile ? 0.15 : 0.1);
    final dateColumnWidth = screenWidth * (isMobile ? 0.15 : 0.1);
    final actionColumnWidth = screenWidth * (isMobile ? 0.1 : 0.08);
    final totalTableWidth = customerColumnWidth + amountColumnWidth + 
                          paymentColumnWidth + statusColumnWidth + 
                          dateColumnWidth + (actionColumnWidth * 2) + 
                          (columnSpacing * 6);

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
                DataColumn(label: _buildShimmerCell(customerColumnWidth)),
                DataColumn(label: _buildShimmerCell(amountColumnWidth)),
                DataColumn(label: _buildShimmerCell(paymentColumnWidth)),
                DataColumn(label: _buildShimmerCell(statusColumnWidth)),
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
                          width: isMobile ? 20 : 24,
                          height: isMobile ? 20 : 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: columnSpacing),
                        _buildShimmerCell(customerColumnWidth - 24 - columnSpacing, height: 16),
                      ],
                    )),
                    DataCell(_buildShimmerCell(amountColumnWidth, height: 16)),
                    DataCell(_buildShimmerCell(paymentColumnWidth, height: 16)),
                    DataCell(_buildShimmerCell(statusColumnWidth, height: 16)),
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

  Widget _buildDataTable(BuildContext context, BoxConstraints constraints, double columnSpacing, DataProvider dataProvider) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final double minTableWidth = isDesktop
        ? constraints.maxWidth
        : isTablet
            ? constraints.maxWidth * 0.9
            : 900; // Wider minimum width for orders table

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minTableWidth),
      child: DataTable(
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
        columns: [
          DataColumn(label: Text("Customer", style: TextStyle(fontSize: isMobile ? 12 : 14))),
          DataColumn(label: Text("Amount", style: TextStyle(fontSize: isMobile ? 12 : 14))),
          DataColumn(label: Text("Payment", style: TextStyle(fontSize: isMobile ? 12 : 14))),
          DataColumn(label: Text("Status", style: TextStyle(fontSize: isMobile ? 12 : 14))),
          DataColumn(label: Text("Date", style: TextStyle(fontSize: isMobile ? 12 : 14))),
          DataColumn(label: Text("View", style: TextStyle(fontSize: isMobile ? 12 : 14))),
          DataColumn(label: Text("Delete", style: TextStyle(fontSize: isMobile ? 12 : 14))),
        ],
        rows: List.generate(
          dataProvider.orders.length,
          (index) => orderDataRow(
            dataProvider.orders[index],
            index + 1,
            edit: () {
              showOrderForm(context, dataProvider.orders[index]);
            },
            delete: () {
              deleteOrderDialoge(context, dataProvider.orders[index]);
            },
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ),
      ),
    );
  }
}

DataRow orderDataRow(
  Order orderInfo,
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
              height: isMobile ? 20 : isTablet ? 22 : 24,
              width: isMobile ? 20 : isTablet ? 22 : 24,
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding),
              child: Text(
                orderInfo.userID?.name ?? '-',
                style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          '\$${orderInfo.orderTotal?.total ?? '0'}',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
        ),
      ),
      DataCell(
        Text(
          orderInfo.paymentMethod ?? '-',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          orderInfo.orderStatus ?? '-',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          orderInfo.orderDate ?? '-',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: edit as void Function()?,
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.blue.shade300,
              size: isMobile ? 16 : isTablet ? 18 : 20,
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: delete as void Function()?,
            icon: Icon(
              Icons.delete,
              color: Colors.red.shade300,
              size: isMobile ? 16 : isTablet ? 18 : 20,
            ),
          ),
        ),
      ),
    ],
  );
}