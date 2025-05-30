import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/brand.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';
import '../../../models/variant_type.dart';
import '../../../utility/responsive.dart';
import '../provider/dash_board_provider.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/multi_select_drop_down.dart';
import '../../../widgets/product_image_card.dart';

class ProductSubmitForm extends StatelessWidget {
  final Product? product;

  const ProductSubmitForm({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.dashBoardProvider.setDataForUpdateProduct(product);

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.7 // Original width on tablet
            : size.width * 0.5; // Narrower on desktop

    // Adjust image card layout for mobile
    return SingleChildScrollView(
      child: Form(
        key: context.dashBoardProvider.addProductFormKey,
        child: Container(
          width: formWidth,
          padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      // Stack image cards vertically on mobile
                      children: [
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Main Image',
                              imageFile: dashProvider.selectedMainImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(0)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 1);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedMainImage = null;
                                dashProvider.updateUI();
                              },
                              
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Second Image',
                              imageFile: dashProvider.selectedSecondImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(1)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 2);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedSecondImage = null;
                                dashProvider.updateUI();
                              },
                             
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Third Image',
                              imageFile: dashProvider.selectedThirdImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(2)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 3);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedThirdImage = null;
                                dashProvider.updateUI();
                              },
                             
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Fourth Image',
                              imageFile: dashProvider.selectedFourthImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(3)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 4);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedFourthImage = null;
                                dashProvider.updateUI();
                              },
                              
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Fifth Image',
                              imageFile: dashProvider.selectedFifthImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(4)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 5);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedFifthImage = null;
                                dashProvider.updateUI();
                              },
                              
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      // Original row layout for tablet/desktop
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Main Image',
                              imageFile: dashProvider.selectedMainImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(0)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 1);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedMainImage = null;
                                dashProvider.updateUI();
                              },
                            );
                          },
                        ),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Second Image',
                              imageFile: dashProvider.selectedSecondImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(1)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 2);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedSecondImage = null;
                                dashProvider.updateUI();
                              },
                            );
                          },
                        ),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Third Image',
                              imageFile: dashProvider.selectedThirdImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(2)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 3);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedThirdImage = null;
                                dashProvider.updateUI();
                              },
                            );
                          },
                        ),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Fourth Image',
                              imageFile: dashProvider.selectedFourthImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(3)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 4);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedFourthImage = null;
                                dashProvider.updateUI();
                              },
                            );
                          },
                        ),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return ProductImageCard(
                              labelText: 'Fifth Image',
                              imageFile: dashProvider.selectedFifthImage,
                              imageUrlForUpdateImage: product?.images.safeElementAt(4)?.url,
                              onTap: () {
                                dashProvider.pickImage(imageCardNumber: 5);
                              },
                              onRemoveImage: () {
                                dashProvider.selectedFifthImage = null;
                                dashProvider.updateUI();
                              },
                            );
                          },
                        ),
                      ],
                    ),
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              CustomTextField(
                controller: context.dashBoardProvider.productNameCtrl,
                labelText: 'Product Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              CustomTextField(
                controller: context.dashBoardProvider.productDescCtrl,
                labelText: 'Product Description',
                lineNumber: 3,
                onSave: (val) {},
              ),
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return CustomDropdown(
                              key: ValueKey(dashProvider.selectedCategory?.sId),
                              initialValue: dashProvider.selectedCategory,
                              hintText: dashProvider.selectedCategory?.name ?? 'Select category',
                              items: context.dataProvider.categories,
                              displayItem: (Category? category) => category?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  context.dashBoardProvider.filterSubcategory(newValue);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return CustomDropdown(
                              key: ValueKey(dashProvider.selectedSubCategory?.sId),
                              hintText: dashProvider.selectedSubCategory?.name ?? 'Sub category',
                              items: dashProvider.subCategoriesByCategory,
                              initialValue: dashProvider.selectedSubCategory,
                              displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  context.dashBoardProvider.filterBrand(newValue);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select sub category';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return CustomDropdown(
                              key: ValueKey(dashProvider.selectedBrand?.sId),
                              initialValue: dashProvider.selectedBrand,
                              items: dashProvider.brandsBySubCategory,
                              hintText: dashProvider.selectedBrand?.name ?? 'Select Brand',
                              displayItem: (Brand? brand) => brand?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  dashProvider.selectedBrand = newValue;
                                  dashProvider.updateUI();
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select brand';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Consumer<DashBoardProvider>(
                            builder: (context, dashProvider, child) {
                              return CustomDropdown(
                                key: ValueKey(dashProvider.selectedCategory?.sId),
                                initialValue: dashProvider.selectedCategory,
                                hintText: dashProvider.selectedCategory?.name ?? 'Select category',
                                items: context.dataProvider.categories,
                                displayItem: (Category? category) => category?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    context.dashBoardProvider.filterSubcategory(newValue);
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Consumer<DashBoardProvider>(
                            builder: (context, dashProvider, child) {
                              return CustomDropdown(
                                key: ValueKey(dashProvider.selectedSubCategory?.sId),
                                hintText: dashProvider.selectedSubCategory?.name ?? 'Sub category',
                                items: dashProvider.subCategoriesByCategory,
                                initialValue: dashProvider.selectedSubCategory,
                                displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    context.dashBoardProvider.filterBrand(newValue);
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select sub category';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Consumer<DashBoardProvider>(
                            builder: (context, dashProvider, child) {
                              return CustomDropdown(
                                key: ValueKey(dashProvider.selectedBrand?.sId),
                                initialValue: dashProvider.selectedBrand,
                                items: dashProvider.brandsBySubCategory,
                                hintText: dashProvider.selectedBrand?.name ?? 'Select Brand',
                                displayItem: (Brand? brand) => brand?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    dashProvider.selectedBrand = newValue;
                                    dashProvider.updateUI();
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select brand';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        CustomTextField(
                          controller: context.dashBoardProvider.productPriceCtrl,
                          labelText: 'Price',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.dashBoardProvider.productOffPriceCtrl,
                          labelText: 'Offer price',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.dashBoardProvider.productQntCtrl,
                          labelText: 'Quantity',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter quantity';
                            }
                            return null;
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: context.dashBoardProvider.productPriceCtrl,
                            labelText: 'Price',
                            inputType: TextInputType.number,
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter price';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: context.dashBoardProvider.productOffPriceCtrl,
                            labelText: 'Offer price',
                            inputType: TextInputType.number,
                            onSave: (val) {},
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: context.dashBoardProvider.productQntCtrl,
                            labelText: 'Quantity',
                            inputType: TextInputType.number,
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter quantity';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return CustomDropdown(
                              key: ValueKey(dashProvider.selectedVariantType?.sId),
                              initialValue: dashProvider.selectedVariantType,
                              items: context.dataProvider.variantTypes,
                              displayItem: (VariantType? variantType) => variantType?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  context.dashBoardProvider.filterVariant(newValue);
                                }
                              },
                              hintText: 'Select Variant type',
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding * 0.5),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            final filteredSelectedItems =
                                dashProvider.selectedVariants.where((item) => dashProvider.variantsByVariantType.contains(item)).toList();
                            return MultiSelectDropDown(
                              items: dashProvider.variantsByVariantType,
                              onSelectionChanged: (newValue) {
                                dashProvider.selectedVariants = newValue;
                                dashProvider.updateUI();
                              },
                              displayItem: (String item) => item,
                              selectedItems: filteredSelectedItems,
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Consumer<DashBoardProvider>(
                            builder: (context, dashProvider, child) {
                              return CustomDropdown(
                                key: ValueKey(dashProvider.selectedVariantType?.sId),
                                initialValue: dashProvider.selectedVariantType,
                                items: context.dataProvider.variantTypes,
                                displayItem: (VariantType? variantType) => variantType?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    context.dashBoardProvider.filterVariant(newValue);
                                  }
                                },
                                hintText: 'Select Variant type',
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Consumer<DashBoardProvider>(
                            builder: (context, dashProvider, child) {
                              final filteredSelectedItems =
                                  dashProvider.selectedVariants.where((item) => dashProvider.variantsByVariantType.contains(item)).toList();
                              return MultiSelectDropDown(
                                items: dashProvider.variantsByVariantType,
                                onSelectionChanged: (newValue) {
                                  dashProvider.selectedVariants = newValue;
                                  dashProvider.updateUI();
                                },
                                displayItem: (String item) => item,
                                selectedItems: filteredSelectedItems,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
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
                  SizedBox(width: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
                      ),
                    ),
                    onPressed: () {
                      if (context.dashBoardProvider.addProductFormKey.currentState!.validate()) {
                        context.dashBoardProvider.addProductFormKey.currentState!.save();
                        context.dashBoardProvider.submitProduct();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddProductForm(BuildContext context, Product? product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Product'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: ProductSubmitForm(product: product),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteProductDialoge(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Product?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete Product?',
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
              context.dashBoardProvider.deleteProduct(product);
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

extension SafeList<T> on List<T>? {
  T? safeElementAt(int index) {
    if (this == null || index < 0 || index >= this!.length) {
      return null;
    }
    return this![index];
  }
}