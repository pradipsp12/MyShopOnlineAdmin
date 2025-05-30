import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import '../../utility/responsive.dart';
import 'components/order_header.dart';
import 'components/order_list_section.dart';
import 'package:admin/utility/extensions.dart';
import '../../widgets/custom_dropdown.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding * 0.5), // Reduced padding for mobile
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(isMobile: true),
            Gap(defaultPadding * 0.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Orders",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16, // Smaller font for mobile
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.dataProvider.getAllOrders(showSnack: true);
                      },
                      icon: Icon(Icons.refresh, size: 20),
                    ),
                  ],
                ),
                Gap(defaultPadding * 0.5),
                CustomDropdown(
                  hintText: 'Filter Order By status',
                  initialValue: 'All order',
                  items: ['All order', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'],
                  displayItem: (val) => val,
                  onChanged: (newValue) {
                    if (newValue?.toLowerCase() == 'all order') {
                      context.dataProvider.filterOrders('');
                    } else {
                      context.dataProvider.filterOrders(newValue?.toLowerCase() ?? '');
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select status';
                    }
                    return null;
                  },
                ),
                Gap(defaultPadding * 0.5),
                OrderListSection(isMobile: true),
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
        padding: EdgeInsets.all(defaultPadding * 0.75), // Slightly reduced padding
        child: Column(
          children: [
            OrderHeader(),
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Orders",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gap(20),
                          SizedBox(
                            width: 250,
                            child: CustomDropdown(
                              hintText: 'Filter Order By status',
                              initialValue: 'All order',
                              items: ['All order', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'],
                              displayItem: (val) => val,
                              onChanged: (newValue) {
                                if (newValue?.toLowerCase() == 'all order') {
                                  context.dataProvider.filterOrders('');
                                } else {
                                  context.dataProvider.filterOrders(newValue?.toLowerCase() ?? '');
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select status';
                                }
                                return null;
                              },
                            ),
                          ),
                          Gap(20),
                          IconButton(
                            onPressed: () {
                              context.dataProvider.getAllOrders(showSnack: true);
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      OrderListSection(),
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
            OrderHeader(),
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Orders",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gap(20),
                          SizedBox(
                            width: 280,
                            child: CustomDropdown(
                              hintText: 'Filter Order By status',
                              initialValue: 'All order',
                              items: ['All order', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'],
                              displayItem: (val) => val,
                              onChanged: (newValue) {
                                if (newValue?.toLowerCase() == 'all order') {
                                  context.dataProvider.filterOrders('');
                                } else {
                                  context.dataProvider.filterOrders(newValue?.toLowerCase() ?? '');
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select status';
                                }
                                return null;
                              },
                            ),
                          ),
                          Gap(40),
                          IconButton(
                            onPressed: () {
                              context.dataProvider.getAllOrders(showSnack: true);
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      OrderListSection(),
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