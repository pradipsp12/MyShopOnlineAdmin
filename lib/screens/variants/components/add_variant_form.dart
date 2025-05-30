import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../models/variant.dart';
import '../../../models/variant_type.dart';
import '../../../utility/responsive.dart';
import '../provider/variant_provider.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class VariantSubmitForm extends StatelessWidget {
  final Variant? variant;

  const VariantSubmitForm({super.key, this.variant});

  @override
  Widget build(BuildContext context) {
    context.variantProvider.setDataForUpdateVariant(variant);
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.5 // Original width on tablet
            : size.width * 0.4; // Narrower on desktop

    return SingleChildScrollView(
      child: Form(
        key: context.variantProvider.addVariantsFormKey,
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
                        Consumer<VariantsProvider>(
                          builder: (context, variantProvider, child) {
                            return CustomDropdown(
                              initialValue: variantProvider.selectedVariantType,
                              items: context.dataProvider.variantTypes,
                              hintText: variantProvider.selectedVariantType?.name ?? 'Select Variant Type',
                              displayItem: (VariantType? variantType) => variantType?.name ?? '',
                              onChanged: (newValue) {
                                variantProvider.selectedVariantType = newValue;
                                variantProvider.updateUI();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a Variant Type';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        Gap(defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.variantProvider.variantCtrl,
                          labelText: 'Variant Name',
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a variant name';
                            }
                            return null;
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Consumer<VariantsProvider>(
                            builder: (context, variantProvider, child) {
                              return CustomDropdown(
                                initialValue: variantProvider.selectedVariantType,
                                items: context.dataProvider.variantTypes,
                                hintText: variantProvider.selectedVariantType?.name ?? 'Select Variant Type',
                                displayItem: (VariantType? variantType) => variantType?.name ?? '',
                                onChanged: (newValue) {
                                  variantProvider.selectedVariantType = newValue;
                                  variantProvider.updateUI();
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a Variant Type';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: context.variantProvider.variantCtrl,
                            labelText: 'Variant Name',
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a variant name';
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
                      if (context.variantProvider.addVariantsFormKey.currentState!.validate()) {
                        context.variantProvider.addVariantsFormKey.currentState!.save();
                        context.variantProvider.submitVariant();
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

void showAddVariantForm(BuildContext context, Variant? variant) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Variant'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: VariantSubmitForm(variant: variant),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteVariantDialoge(BuildContext context, Variant variant) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Variant?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete Variant?',
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
              context.variantProvider.deleteVariant(variant);
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