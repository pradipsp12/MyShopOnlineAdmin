import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../utility/responsive.dart';
import '../provider/sub_category_provider.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class SubCategorySubmitForm extends StatelessWidget {
  final SubCategory? subCategory;

  const SubCategorySubmitForm({super.key, this.subCategory});

  @override
  Widget build(BuildContext context) {
    context.subCategoryProvider.setDataForUpdateCategory(subCategory);
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.5 // Original width on tablet
            : size.width * 0.4; // Narrower on desktop

    return SingleChildScrollView(
      child: Form(
        key: context.subCategoryProvider.addSubCategoryFormKey,
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
                        Consumer<SubCategoryProvider>(
                          builder: (context, subCatProvider, child) {
                            return CustomDropdown(
                              initialValue: subCatProvider.selectedCategory,
                              hintText: subCatProvider.selectedCategory?.name ?? 'Select category',
                              items: context.dataProvider.categories,
                              displayItem: (Category? category) => category?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  subCatProvider.selectedCategory = newValue;
                                  subCatProvider.updateUi();
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
                        Gap(defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.subCategoryProvider.subCategoryNameCtrl,
                          labelText: 'Sub Category Name',
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a sub category name';
                            }
                            return null;
                          },
                         
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Consumer<SubCategoryProvider>(
                            builder: (context, subCatProvider, child) {
                              return CustomDropdown(
                                initialValue: subCatProvider.selectedCategory,
                                hintText: subCatProvider.selectedCategory?.name ?? 'Select category',
                                items: context.dataProvider.categories,
                                displayItem: (Category? category) => category?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    subCatProvider.selectedCategory = newValue;
                                    subCatProvider.updateUi();
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
                          child: CustomTextField(
                            controller: context.subCategoryProvider.subCategoryNameCtrl,
                            labelText: 'Sub Category Name',
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a sub category name';
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
                      if (context.subCategoryProvider.addSubCategoryFormKey.currentState!.validate()) {
                        context.subCategoryProvider.addSubCategoryFormKey.currentState!.save();
                        context.subCategoryProvider.submitSubCategory();
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

void showAddSubCategoryForm(BuildContext context, SubCategory? subCategory) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Sub Category'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: SubCategorySubmitForm(subCategory: subCategory),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteSubCategoryDialoge(BuildContext context, SubCategory subCategory) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Sub-Category?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete Sub-category?',
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
              context.subCategoryProvider.deleteSubCategory(subCategory);
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