import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import '../../../utility/constants.dart';
import '../../../utility/threeWords.dart';
import 'add_product_form.dart';

class ProductListSection extends StatelessWidget {
  final bool isMobile;

  const ProductListSection({Key? key, this.isMobile = false}) : super(key: key);

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
            "All Products",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isMobile ? 14 : 16,
                ),
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DataTable(
                  columnSpacing: isMobile ? defaultPadding * 0.2 : defaultPadding,
                  columns: [
                    DataColumn(
                      label: Text("Product Name", style: TextStyle(fontSize: isMobile ? 11 : 14)),
                    ),
                    DataColumn(
                      label: Text("Category", style: TextStyle(fontSize: isMobile ? 11 : 14)),
                    ),
                    DataColumn(
                      label: Text("SubCateg", style: TextStyle(fontSize: isMobile ? 11 : 14, overflow: TextOverflow.ellipsis)),
                    ),
                    DataColumn(
                      label: Text("Price", style: TextStyle(fontSize: isMobile ? 11 : 14)),
                    ),
                    DataColumn(
                      label: Text("Action", textAlign: TextAlign.center, style: TextStyle(fontSize: isMobile ? 11 : 14)),
                    ),
                    
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

DataRow productDataRow(Product productInfo, {Function? edit, Function? delete, bool isMobile = false}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Image.network(
              productInfo.images?.first.url ?? '',
              height: isMobile ? 24 : 30,
              width: isMobile ? 24 : 30,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Icon(Icons.error, size: isMobile ? 20 : 24);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? defaultPadding * 0.2 : defaultPadding),
              child: Text(
                softWrap: true,
                truncateToThreeWords(productInfo.name ?? ''),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: isMobile ? 11 : 14),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(productInfo.proCategoryId?.name ?? '', style: TextStyle(fontSize: isMobile ? 11 : 14))),
      DataCell(Text(productInfo.proSubCategoryId?.name ?? '', style: TextStyle(fontSize: isMobile ? 11 : 14))),
      DataCell(Text('${productInfo.price}', style: TextStyle(fontSize: isMobile ? 11 : 14))),
      DataCell(
        Row(
          children: [
            IconButton(
            onPressed: () {
              if (edit != null) edit();
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
              size: isMobile ? 18 : 24,
            ),
                  ),
                  IconButton(
        onPressed: () {
          if (delete != null) delete();
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
          size: isMobile ? 18 : 24,
        ),
      )

          ],
        )
      ),
      // DataCell(IconButton(
      //   onPressed: () {
      //     if (delete != null) delete();
      //   },
      //   icon: Icon(
      //     Icons.delete,
      //     color: Colors.red,
      //     size: isMobile ? 18 : 24,
      //   ),
      // )),
    ],
  );
}