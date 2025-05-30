import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/poster.dart';
import '../../../utility/constants.dart';
import 'add_poster_form.dart';

class PosterListSection extends StatelessWidget {
  final bool isMobile;

  const PosterListSection({Key? key, this.isMobile = false}) : super(key: key);

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
            "All Posters",
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
                      label: Text("Poster Name", style: TextStyle(fontSize: isMobile ? 12 : 14)),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow posterDataRow(Poster poster, {Function? edit, Function? delete, bool isMobile = false}) {
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
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
            ),
          ],
        ),
      ),
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