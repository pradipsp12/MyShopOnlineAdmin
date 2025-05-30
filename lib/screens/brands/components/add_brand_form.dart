import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../models/sub_category.dart';
import '../../../models/brand.dart';
import '../../../utility/responsive.dart';
import '../provider/brand_provider.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class BrandSubmitForm extends StatelessWidget {
  final Brand? brand;

  const BrandSubmitForm({super.key, this.brand});

  @override
  Widget build(BuildContext context) {
    context.brandProvider.setDataForUpdateBrand(brand);
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.5 // Original width on tablet
            : size.width * 0.4; // Narrower on desktop

    return SingleChildScrollView(
      child: Form(
        key: context.brandProvider.addBrandFormKey,
        child: Container(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
          width: formWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        Consumer<BrandProvider>(
                          builder: (context, brandProvider, child) {
                            return CustomDropdown(
                              initialValue: brandProvider.selectedSubCategory,
                              items: context.dataProvider.subCategories,
                              hintText: brandProvider.selectedSubCategory?.name ?? 'Select Sub Category',
                              displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                              onChanged: (newValue) {
                                brandProvider.selectedSubCategory = newValue;
                                brandProvider.updateUI();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a Sub Category';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        Gap(defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.brandProvider.brandNameCtrl,
                          labelText: 'Brand Name',
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a brand name';
                            }
                            return null;
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Consumer<BrandProvider>(
                            builder: (context, brandProvider, child) {
                              return CustomDropdown(
                                initialValue: brandProvider.selectedSubCategory,
                                items: context.dataProvider.subCategories,
                                hintText: brandProvider.selectedSubCategory?.name ?? 'Select Sub Category',
                                displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                                onChanged: (newValue) {
                                  brandProvider.selectedSubCategory = newValue;
                                  brandProvider.updateUI();
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a Sub Category';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: context.brandProvider.brandNameCtrl,
                            labelText: 'Brand Name',
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a brand name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
              Gap(Responsive.isMobile(context) ? defaultPadding : defaultPadding * 2),
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
                  Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
                      ),
                    ),
                    onPressed: () {
                      if (context.brandProvider.addBrandFormKey.currentState!.validate()) {
                        context.brandProvider.addBrandFormKey.currentState!.save();
                        context.brandProvider.submitBrand();
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

void showBrandForm(BuildContext context, Brand? brand) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Brand'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: BrandSubmitForm(brand: brand),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteBrandDialoge(BuildContext context, Brand brand) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Brand?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete Brand?',
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
              context.brandProvider.deleteBrand(brand);
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