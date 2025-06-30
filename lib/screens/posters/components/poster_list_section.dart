import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/poster.dart';
import '../../../utility/constants.dart';
import '../../../utility/responsive.dart';
import 'add_poster_form.dart';

class PosterListSection extends StatelessWidget {
  final bool isMobile;

  const PosterListSection({Key? key, this.isMobile = false}) : super(key: key);

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
            "All Posters",
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
  final posterColumnWidth = screenWidth * (isMobile ? 0.35 : 0.3);
  final dateColumnWidth = screenWidth * (isMobile ? 0.2 : 0.15);
  final actionColumnWidth = screenWidth * (isMobile ? 0.1 : 0.08);
  final totalTableWidth = posterColumnWidth + dateColumnWidth + 
                        (actionColumnWidth * 2) + (columnSpacing * 3);

  return ClipRRect(
    borderRadius: BorderRadius.circular(10), // Match your container's border radius
    child: Shimmer.fromColors(
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
                DataColumn(label: _buildShimmerCell(posterColumnWidth)),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: isMobile ? 24 : 30,
                            height: isMobile ? 24 : 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: columnSpacing),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: _buildShimmerCell(
                            posterColumnWidth - (isMobile ? 24 : 30) - columnSpacing, 
                            height: 16
                          ),
                        ),
                      ],
                    )),
                    DataCell(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: _buildShimmerCell(dateColumnWidth, height: 16),
                      ),
                    ),
                    DataCell(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildShimmerCell(actionColumnWidth, height: isMobile ? 30 : 40),
                      ),
                    ),
                    DataCell(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildShimmerCell(actionColumnWidth, height: isMobile ? 30 : 40),
                      ),
                    ),
                  ],
                ),
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
            : 500;

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
          DataColumn(
            label: Text("Poster Name", style: TextStyle(fontSize: isMobile ? 12 : 14)),
          ),
          DataColumn(
            label: Text("Added Date", style: TextStyle(fontSize: isMobile ? 12 : 14)),
          ),
          DataColumn(
            label: Text("Edit", style: TextStyle(fontSize: isMobile ? 12 : 14)),
          ),
          DataColumn(
            label: Text("Delete", style: TextStyle(fontSize: isMobile ? 12 : 14)),
          ),
        ],
        rows: List.generate(
          dataProvider.posters.length,
          (index) => posterDataRow(
            dataProvider.posters[index],
            delete: () {
              deletePosterDialoge(context, dataProvider.posters[index]);
            },
            edit: () {
              showAddPosterForm(context, dataProvider.posters[index]);
            },
            isMobile: isMobile,
          ),
        ),
      ),
    );
  }
}

DataRow posterDataRow(Poster poster, {Function? edit, Function? delete, bool isMobile = false}) {
  final isTablet = !isMobile && MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width < 1000;
  
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Image.network(
              poster.imageUrl ?? '',
              height: isMobile ? 24 : 30,
              width: isMobile ? 24 : 30,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Icon(Icons.error, size: isMobile ? 20 : 24);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding),
              child: Text(
                poster.posterName ?? '',
                style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          poster.createdAt != null ? poster.createdAt!.toString().split(' ')[0] : '-',
          style: TextStyle(fontSize: isMobile ? 12 : isTablet ? 13 : 14),
        ),
      ),
      DataCell(
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: edit as void Function()?,
          icon: Icon(
            Icons.edit,
            color: Colors.blue.shade300,
            size: isMobile ? 18 : 24,
          ),
        ),
      ),
      DataCell(
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: delete as void Function()?,
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade300,
            size: isMobile ? 18 : 24,
          ),
        ),
      ),
    ],
  );
}