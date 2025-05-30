import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/order.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import 'view_order_form.dart';

class OrderListSection extends StatelessWidget {
  final bool isMobile;

  const OrderListSection({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            "All Orders",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isMobile ? 14 : 16,
                ),
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DataTable(
                  columnSpacing: isMobile ? defaultPadding * 0.5 : defaultPadding,
                  columns: [
                    DataColumn(
                      label: Text("Customer", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                    DataColumn(
                      label: Text("Amount", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                    DataColumn(
                      label: Text("Payment", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                    DataColumn(
                      label: Text("Status", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                    DataColumn(
                      label: Text("Date", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                    DataColumn(
                      label: Text("Edit", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                    DataColumn(
                      label: Text("Delete", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                    ),
                  ],
                  rows: List.generate(
                    dataProvider.orders.length,
                    (index) => orderDataRow(
                      dataProvider.orders[index],
                      index + 1,
                      delete: () {
                        deleteOrderDialoge(context, dataProvider.orders[index]);
                      },
                      edit: () {
                        showOrderForm(context, dataProvider.orders[index]);
                      },
                      isMobile: isMobile,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow orderDataRow(Order orderInfo, int index, {Function? edit, Function? delete, bool isMobile = false}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: isMobile ? 20 : 24,
              width: isMobile ? 20 : 24,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(
                index.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding),
              child: Text(
                orderInfo.userID?.name ?? '',
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text('${orderInfo.orderTotal?.total}', style: TextStyle(fontSize: isMobile ? 12 : 14))),
      DataCell(Text(orderInfo.paymentMethod ?? '', style: TextStyle(fontSize: isMobile ? 12 : 14))),
      DataCell(Text(orderInfo.orderStatus ?? '', style: TextStyle(fontSize: isMobile ? 12 : 14))),
      DataCell(Text(orderInfo.orderDate ?? '', style: TextStyle(fontSize: isMobile ? 12 : 14))),
      DataCell(IconButton(
        onPressed: () {
          if (edit != null) edit();
        },
        icon: Icon(
          Icons.edit,
          color: Colors.white,
          size: isMobile ? 18 : 24,
        ),
      )),
      DataCell(IconButton(
        onPressed: () {
          if (delete != null) delete();
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
          size: isMobile ? 18 : 24,
        ),
      )),
    ],
  );
}