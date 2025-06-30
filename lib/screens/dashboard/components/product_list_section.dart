import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import '../../../utility/constants.dart';
import '../../../utility/responsive.dart';
import '../../../utility/threeWords.dart';
import 'add_product_form.dart';

class ProductListSection extends StatelessWidget {
  final bool isMobile;

  const ProductListSection({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final double columnSpacing = isMobile
        ? defaultPadding * 0.2
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
            "All Products",
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
    final columnSpacing = isMobile ? defaultPadding * 0.2 : defaultPadding;
    
    // Calculate column widths as percentages of screen width
    final productColumnWidth = screenWidth * (isMobile ? 0.3 : 0.25);
    final categoryColumnWidth = screenWidth * (isMobile ? 0.2 : 0.15);
    final actionColumnWidth = screenWidth * (isMobile ? 0.15 : 0.1);
    final totalTableWidth = productColumnWidth + 
                          (categoryColumnWidth * 2) + 
                          actionColumnWidth + 
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
                DataColumn(label: _buildShimmerCell(productColumnWidth)),
                DataColumn(label: _buildShimmerCell(categoryColumnWidth)),
                DataColumn(label: _buildShimmerCell(categoryColumnWidth)),
                DataColumn(label: _buildShimmerCell(categoryColumnWidth)),
                DataColumn(label: _buildShimmerCell(actionColumnWidth)),
              ],
              rows: List.generate(
                5,
                (index) => DataRow(
                  cells: [
                    DataCell(Row(
                      children: [
                        Container(
                          width: isMobile ? 24 : 30,
                          height: isMobile ? 24 : 30,
                          color: Colors.white,
                        ),
                        SizedBox(width: columnSpacing),
                        _buildShimmerCell(productColumnWidth - 30 - columnSpacing, height: 16),
                      ],
                    )),
                    DataCell(_buildShimmerCell(categoryColumnWidth, height: 16)),
                    DataCell(_buildShimmerCell(categoryColumnWidth, height: 16)),
                    DataCell(_buildShimmerCell(categoryColumnWidth, height: 16)),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildShimmerCell(30, height: 30),
                        SizedBox(width: isMobile ? 8 : 12),
                        _buildShimmerCell(30, height: 30),
                      ],
                    )),
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
            : 700;

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
          DataColumn(label: Text("Product", style: TextStyle(fontSize: isMobile ? 11 : 14))),
          DataColumn(label: Text("Category", style: TextStyle(fontSize: isMobile ? 11 : 14))),
          DataColumn(label: Text("SubCateg", style: TextStyle(fontSize: isMobile ? 11 : 14))),
          DataColumn(label: Text("Price", style: TextStyle(fontSize: isMobile ? 11 : 14))),
          DataColumn(label: Text("Actions", style: TextStyle(fontSize: isMobile ? 11 : 14))),
        ],
        rows: List.generate(
          dataProvider.products.length,
          (index) => productDataRow(
            dataProvider.products[index],
            edit: () {
              showAddProductForm(context, dataProvider.products[index]);
            },
            delete: () {
              deleteProductDialoge(context, dataProvider.products[index]);
            },
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ),
      ),
    );
  }
}

DataRow productDataRow(
  Product productInfo, {
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
              height: isMobile ? 24 : isTablet ? 28 : 30,
              width: isMobile ? 24 : isTablet ? 28 : 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade800,
              ),
              child: productInfo.images?.isNotEmpty ?? false
                  ? Image.network(
                      productInfo.images!.first.url ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        size: isMobile ? 16 : 20,
                        color: Colors.red,
                      ),
                    )
                  : Icon(
                      Icons.image_not_supported,
                      size: isMobile ? 16 : 20,
                      color: Colors.grey.shade600,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? defaultPadding * 0.2 : defaultPadding),
              child: Text(
                truncateToThreeWords(productInfo.name ?? ''),
                style: TextStyle(fontSize: isMobile ? 11 : 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          productInfo.proCategoryId?.name ?? '-',
          style: TextStyle(fontSize: isMobile ? 11 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          productInfo.proSubCategoryId?.name ?? '-',
          style: TextStyle(fontSize: isMobile ? 11 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          '\$${productInfo.price}',
          style: TextStyle(fontSize: isMobile ? 11 : 14),
        ),
      ),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: edit as void Function()?,
              icon: Icon(
                Icons.edit,
                color: Colors.blue.shade300,
                size: isMobile ? 16 : isTablet ? 18 : 20,
              ),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: delete as void Function()?,
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade300,
                size: isMobile ? 16 : isTablet ? 18 : 20,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}