import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../utility/constants.dart';
import 'chart.dart';
import 'order_info_card.dart';

class OrderDetailsSection extends StatelessWidget {
  final bool isMobile;

  const OrderDetailsSection({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        int totalOrder = context.dataProvider.calculateOrdersWithStatus();
        int pendingOrder = context.dataProvider.calculateOrdersWithStatus(status: 'pending');
        int processingOrder = context.dataProvider.calculateOrdersWithStatus(status: 'processing');
        int cancelledOrder = context.dataProvider.calculateOrdersWithStatus(status: 'cancelled');
        int shippedOrder = context.dataProvider.calculateOrdersWithStatus(status: 'shipped');
        int deliveredOrder = context.dataProvider.calculateOrdersWithStatus(status: 'delivered');

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
                "Orders Details",
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: isMobile ? defaultPadding * 0.5 : defaultPadding),
              Chart(isMobile: isMobile),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery1.svg",
                title: "All Orders",
                totalOrder: totalOrder,
                isMobile: isMobile,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery5.svg",
                title: "Pending Orders",
                totalOrder: pendingOrder,
                isMobile: isMobile,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery6.svg",
                title: "Processed Orders",
                totalOrder: processingOrder,
                isMobile: isMobile,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery2.svg",
                title: "Cancelled Orders",
                totalOrder: cancelledOrder,
                isMobile: isMobile,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery4.svg",
                title: "Shipped Orders",
                totalOrder: shippedOrder,
                isMobile: isMobile,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery3.svg",
                title: "Delivered Orders",
                totalOrder: deliveredOrder,
                isMobile: isMobile,
              ),
            ],
          ),
        );
      },
    );
  }
}

class Chart extends StatelessWidget {
  final bool isMobile;

  const Chart({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isMobile ? 150 : 200, // Smaller height on mobile
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: isMobile ? 50 : 70, // Smaller radius on mobile
              startDegreeOffset: -90,
              sections: _buildPieChartSelectionData(context),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isMobile ? defaultPadding * 0.5 : defaultPadding),
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    return Text(
                      '${context.dataProvider.calculateOrdersWithStatus()}',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 0.5,
                            fontSize: isMobile ? 20 : 24,
                          ),
                    );
                  },
                ),
                SizedBox(height: isMobile ? defaultPadding * 0.5 : defaultPadding),
                Text(
                  "Order",
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSelectionData(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);

    int totalOrder = context.dataProvider.calculateOrdersWithStatus();
    int pendingOrder = context.dataProvider.calculateOrdersWithStatus(status: 'pending');
    int processingOrder = context.dataProvider.calculateOrdersWithStatus(status: 'processing');
    int cancelledOrder = context.dataProvider.calculateOrdersWithStatus(status: 'cancelled');
    int shippedOrder = context.dataProvider.calculateOrdersWithStatus(status: 'shipped');
    int deliveredOrder = context.dataProvider.calculateOrdersWithStatus(status: 'delivered');

    List<PieChartSectionData> pieChartSelectionData = [
      PieChartSectionData(
        color: Color(0xFFFFCF26),
        value: pendingOrder.toDouble(),
        showTitle: false,
        radius: isMobile ? 15 : 20, // Smaller radius on mobile
      ),
      PieChartSectionData(
        color: Color(0xFFEE2727),
        value: cancelledOrder.toDouble(),
        showTitle: false,
        radius: isMobile ? 15 : 20,
      ),
      PieChartSectionData(
        color: Color(0xFF2697FF),
        value: shippedOrder.toDouble(),
        showTitle: false,
        radius: isMobile ? 15 : 20,
      ),
      PieChartSectionData(
        color: Color(0xFF26FF31),
        value: deliveredOrder.toDouble(),
        showTitle: false,
        radius: isMobile ? 15 : 20,
      ),
      PieChartSectionData(
        color: Colors.white,
        value: processingOrder.toDouble(),
        showTitle: false,
        radius: isMobile ? 15 : 20,
      ),
    ];

    return pieChartSelectionData;
  }
}

class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.totalOrder,
    this.isMobile = false,
  }) : super(key: key);

  final String title, svgSrc;
  final int totalOrder;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: isMobile ? defaultPadding * 0.5 : defaultPadding),
      padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
      child: Row(
        children: [
          SizedBox(
            height: isMobile ? 16 : 20,
            width: isMobile ? 16 : 20,
            child: SvgPicture.asset(svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                  Text(
                    "$totalOrder Files",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white70,
                          fontSize: isMobile ? 10 : 12,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}