import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../models/variant_type.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../utility/responsive.dart';
import '../../../widgets/custom_text_field.dart';

class VariantTypeSubmitForm extends StatelessWidget {
  final VariantType? variantType;

  const VariantTypeSubmitForm({super.key, this.variantType});

  @override
  Widget build(BuildContext context) {
    context.variantTypeProvider.setDataForUpdateVariantTYpe(variantType);
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.5 // Original width on tablet
            : size.width * 0.4; // Narrower on desktop

    return SingleChildScrollView(
      child: Form(
        key: context.variantTypeProvider.addVariantsTypeFormKey,
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
                        CustomTextField(
                          controller: context.variantTypeProvider.variantNameCtrl,
                          labelText: 'Variant Name',
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a variant name';
                            }
                            return null;
                          },
                       
                        ),
                        Gap(defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.variantTypeProvider.variantTypeCtrl,
                          labelText: 'Variant Type',
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a type name';
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
                            controller: context.variantTypeProvider.variantNameCtrl,
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
                        Expanded(
                          child: CustomTextField(
                            controller: context.variantTypeProvider.variantTypeCtrl,
                            labelText: 'Variant Type',
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a type name';
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
                      if (context.variantTypeProvider.addVariantsTypeFormKey.currentState!.validate()) {
                        context.variantTypeProvider.addVariantsTypeFormKey.currentState!.save();
                        context.variantTypeProvider.submitVariantType();
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

void showAddVariantsTypeForm(BuildContext context, VariantType? variantType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Variant Type'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: VariantTypeSubmitForm(variantType: variantType),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteVariantTypeDialoge(BuildContext context, VariantType variantType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Variant Type?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete Variant Type?',
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
              context.variantTypeProvider.deleteVariantType(variantType);
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