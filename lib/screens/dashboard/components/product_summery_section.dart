import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product_summery_info.dart';
import '../../../utility/constants.dart';
import 'product_summery_card.dart';

class ProductSummerySection extends StatelessWidget {
  final bool isMobile;

  const ProductSummerySection({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        int totalProduct = 1;
        totalProduct = context.dataProvider.calculateProductWithQuantity(quantity: null);
        int outOfStockProduct = context.dataProvider.calculateProductWithQuantity(quantity: 0);
        int limitedStockProduct = context.dataProvider.calculateProductWithQuantity(quantity: 1);
        int otherStockProduct = totalProduct - outOfStockProduct - limitedStockProduct;

        List<ProductSummeryInfo> productSummeryItems = [
          ProductSummeryInfo(
            title: "All Product",
            productsCount: totalProduct,
            svgSrc: "assets/icons/Product.svg",
            color: primaryColor,
            percentage: 100,
          ),
          ProductSummeryInfo(
            title: "Out of Stock",
            productsCount: outOfStockProduct,
            svgSrc: "assets/icons/Product2.svg",
            color: Color(0xFFEA3829),
            percentage: totalProduct != 0 ? (outOfStockProduct / totalProduct) * 100 : 0,
          ),
          ProductSummeryInfo(
            title: "Limited Stock",
            productsCount: limitedStockProduct,
            svgSrc: "assets/icons/Product3.svg",
            color: Color(0xFFECBE23),
            percentage: totalProduct != 0 ? (limitedStockProduct / totalProduct) * 100 : 0,
          ),
          ProductSummeryInfo(
            title: "Other Stock",
            productsCount: otherStockProduct,
            svgSrc: "assets/icons/Product4.svg",
            color: Color(0xFF47e228),
            percentage: totalProduct != 0 ? (otherStockProduct / totalProduct) * 100 : 0,
          ),
        ];

        return Column(
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: productSummeryItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 4 : 4, // 2 columns on mobile, 4 on tablet/desktop
                crossAxisSpacing: isMobile ? defaultPadding * 0.5 : defaultPadding,
                mainAxisSpacing: isMobile ? defaultPadding * 0.5 : defaultPadding,
                childAspectRatio: isMobile ? 1.0 : _size.width < 1400 ? 1.1 : 1.4,
              ),
              itemBuilder: (context, index) => ProductSummeryCard(
                info: productSummeryItems[index],
                isMobile: isMobile,
                onTap: (productType) {
                  context.dataProvider.filterProductsByQuantity(productType);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProductSummeryCard extends StatelessWidget {
  const ProductSummeryCard({
    Key? key,
    required this.info,
    required this.onTap,
    this.isMobile = false,
  }) : super(key: key);

  final ProductSummeryInfo info;
  final Function(String?) onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(info.title);
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding * 0.75),
                  height: isMobile ? 32 : 40,
                  width: isMobile ? 32 : 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    colorFilter: ColorFilter.mode(info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white54, size: isMobile ? 18 : 24),
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
            ProgressLine(
              color: info.color,
              percentage: info.percentage,
              isMobile: isMobile,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.productsCount} Product",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white70,
                        fontSize: isMobile ? 10 : 12,
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

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
    this.isMobile = false,
  }) : super(key: key);

  final Color? color;
  final double? percentage;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: isMobile ? 4 : 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: isMobile ? 4 : 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}