import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/sub_category.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../../../utility/responsive.dart';
import 'add_sub_category_form.dart';

class SubCategoryListSection extends StatelessWidget {
  final bool isMobile;

  const SubCategoryListSection({Key? key, this.isMobile = false}) : super(key: key);

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
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All SubCategories",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isMobile ? 14 : 16,
                ),
          ),
          Gap(defaultPadding * 0.5),
          Consumer<DataProvider>(builder: (context, dataProvider, child){
             if (dataProvider.isLoading) {
                return _buildShimmerEffect(isMobile: isMobile, context: context);
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
          },)
        ],
      ),
    );
  }

   Widget _buildShimmerEffect({required bool isMobile, required BuildContext context}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final columnSpacing = isMobile ? defaultPadding * 0.5 : defaultPadding;
  
  // Calculate column widths as percentages of screen width
  final mainColumnWidth = screenWidth * (isMobile ? 0.25 : 0.2);
  final actionColumnWidth = screenWidth * (isMobile ? 0.1 : 0.08);
  final totalTableWidth = (mainColumnWidth * 3) + (actionColumnWidth * 2) + (columnSpacing * 4);

  return Shimmer.fromColors(
    baseColor: Colors.grey.shade800,
    highlightColor: Colors.grey.shade700,
    child: SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalTableWidth, // Set total width based on calculated columns
          child: DataTable(
            columnSpacing: columnSpacing,
            dataRowMinHeight: isMobile ? 40 : 48,
            dataRowMaxHeight: isMobile ? 48 : 56,
            columns: [
              DataColumn(label: _buildShimmerCell(mainColumnWidth)),
              DataColumn(label: _buildShimmerCell(mainColumnWidth)),
              DataColumn(label: _buildShimmerCell(mainColumnWidth)),
              DataColumn(label: _buildShimmerCell(actionColumnWidth)),
              DataColumn(label: _buildShimmerCell(actionColumnWidth)),
            ],
            rows: List.generate(
              5,
              (index) => DataRow(
                cells: [
                  DataCell(_buildShimmerCell(mainColumnWidth, height: isMobile ? 16 : 24)),
                  DataCell(_buildShimmerCell(mainColumnWidth, height: isMobile ? 16 : 24)),
                  DataCell(_buildShimmerCell(mainColumnWidth, height: isMobile ? 16 : 24)),
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
            : 700; // Minimum width for subcategory columns

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
            columns: [
              DataColumn(label: Text("SubCategory", style: TextStyle(fontSize: isMobile ? 12 : 14))),
              DataColumn(label: Text("Category", style: TextStyle(fontSize: isMobile ? 12 : 14))),
              DataColumn(label: Text("Added Date", style: TextStyle(fontSize: isMobile ? 12 : 14))),
              DataColumn(label: Text("Edit", style: TextStyle(fontSize: isMobile ? 12 : 14))),
              DataColumn(label: Text("Delete", style: TextStyle(fontSize: isMobile ? 12 : 14))),
            ],
            rows: List.generate(
              dataProvider.subCategories.length,
              (index) => subCategoryDataRow(
                dataProvider.subCategories[index],
                index + 1,
                edit: () {
                  showAddSubCategoryForm(context, dataProvider.subCategories[index]);
                },
                delete: () {
                  deleteSubCategoryDialoge(context, dataProvider.subCategories[index]);
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

DataRow subCategoryDataRow(
  SubCategory subCatInfo,
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
                subCatInfo.name ?? '-',
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
          subCatInfo.categoryId?.name ?? '-',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          subCatInfo.createdAt ?? '-',
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
              Icons.edit,
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