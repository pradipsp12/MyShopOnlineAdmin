import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../utility/responsive.dart';
import '../provider/order_provider.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class OrderSubmitForm extends StatelessWidget {
  final Order? order;

  const OrderSubmitForm({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.orderProvider.trackingUrlCtrl.text = order?.trackingUrl ?? '';
    context.orderProvider.orderForUpdate = order;
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.6 // Wider on tablet
            : size.width * 0.5; // Original width on desktop

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
        width: formWidth,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Form(
          key: Provider.of<OrderProvider>(context, listen: false).orderFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        formRow(context, 'Name:', Text(order?.userID?.name ?? 'N/A', style: TextStyle(fontSize: 14))),
                        Gap(defaultPadding * 0.5),
                        formRow(context, 'Order Id:', Text(order?.sId ?? 'N/A', style: TextStyle(fontSize: 12))),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: formRow(context, 'Name:', Text(order?.userID?.name ?? 'N/A', style: TextStyle(fontSize: 16))),
                        ),
                        Expanded(
                          child: formRow(context, 'Order Id:', Text(order?.sId ?? 'N/A', style: TextStyle(fontSize: 12))),
                        ),
                      ],
                    ),
              itemsSection(context),
              addressSection(context),
              Gap(Responsive.isMobile(context) ? 8 : 10),
              paymentDetailsSection(context),
              formRow(
                context,
                'Order Status:',
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return CustomDropdown(
                      hintText: 'Status',
                      initialValue: orderProvider.selectedOrderStatus,
                      items: ['pending', 'processing', 'shipped', 'delivered', 'cancelled'],
                      displayItem: (val) => val,
                      onChanged: (newValue) {
                        orderProvider.selectedOrderStatus = newValue ?? 'pending';
                        orderProvider.updateUI();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select status';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
              formRow(
                context,
                'Tracking URL:',
                CustomTextField(
                  labelText: 'Tracking Url',
                  onSave: (val) {},
                  controller: context.orderProvider.trackingUrlCtrl,
                ),
              ),
              Gap(Responsive.isMobile(context) ? defaultPadding : defaultPadding * 2),
              actionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget formRow(BuildContext context, String label, Widget dataWidget) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.isMobile(context) ? 14 : 16,
              ),
            ),
          ),
          Expanded(flex: 2, child: dataWidget),
        ],
      ),
    );
  }

  Widget addressSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Responsive.isMobile(context) ? 10 : 20),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8),
            child: Text(
              'Shipping Address',
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          formRow(context, 'Phone:', Text(order?.shippingAddress?.phone ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'Street:', Text(order?.shippingAddress?.street ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'City:', Text(order?.shippingAddress?.city ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'Postal Code:', Text(order?.shippingAddress?.postalCode ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'Country:', Text(order?.shippingAddress?.country ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
        ],
      ),
    );
  }

  Widget paymentDetailsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Responsive.isMobile(context) ? 10 : 20),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Colors.blueAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8),
            child: Text(
              'Payment Details',
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          formRow(context, 'Payment Method:', Text(order?.paymentMethod ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'Coupon Code:', Text(order?.couponCode?.couponCode ?? 'N/A', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'Order Sub Total:', Text('\$${order?.orderTotal?.subtotal?.toStringAsFixed(2) ?? 'N/A'}', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16))),
          formRow(context, 'Discount:', Text('\$${order?.orderTotal?.discount?.toStringAsFixed(2) ?? 'N/A'}', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16, color: Colors.red))),
          formRow(context, 'Grand Total:', Text('\$${order?.orderTotal?.total?.toStringAsFixed(2) ?? 'N/A'}', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget itemsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Responsive.isMobile(context) ? 10 : 20),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Colors.blueAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8),
            child: Text(
              'Items',
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          _buildItemsList(context),
          SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
          formRow(
            context,
            'Total Price:',
            Text('\$${order?.totalPrice?.toStringAsFixed(2) ?? 'N/A'}',
                style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16, color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    if (order?.items == null || order!.items!.isEmpty) {
      return Text('No items', style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: order!.items!.length,
      itemBuilder: (context, index) {
        final item = order!.items![index];
        return Padding(
          padding: EdgeInsets.only(bottom: Responsive.isMobile(context) ? 2 : 4),
          child: Text(
            '${item.productName}: ${item.quantity} x \$${item.price?.toStringAsFixed(2)}',
            style: TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16),
          ),
        );
      },
    );
  }

  Widget actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
          ),
        ),
        Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
            ),
          ),
          onPressed: () {
            if (Provider.of<OrderProvider>(context, listen: false).orderFormKey.currentState!.validate()) {
              Provider.of<OrderProvider>(context, listen: false).orderFormKey.currentState!.save();
              context.orderProvider.updateOrder();
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'Submit',
            style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
          ),
        ),
      ],
    );
  }
}

void showOrderForm(BuildContext context, Order? order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Order Details'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: OrderSubmitForm(order: order),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteOrderDialoge(BuildContext context, Order order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Order?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete Order?',
          style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
        ),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.orderProvider.deleteOrder(order);
            },
            child: Text(
              'Delete',
              style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
            ),
          ),
        ],
      );
    },
  );
}