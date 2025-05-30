import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';
import '../../../models/category.dart';
import '../../../models/coupon.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../utility/responsive.dart';
import '../provider/coupon_code_provider.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class CouponSubmitForm extends StatelessWidget {
  final Coupon? coupon;

  const CouponSubmitForm({Key? key, this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.couponCodeProvider.setDataForUpdateCoupon(coupon);
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.7 // Original width on tablet
            : size.width * 0.6; // Narrower on desktop

    return SingleChildScrollView(
      child: Form(
        key: context.couponCodeProvider.addCouponFormKey,
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
                          controller: context.couponCodeProvider.couponCodeCtrl,
                          labelText: 'Coupon Code',
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter coupon code';
                            }
                            return null;
                          },
                        
                        ),
                        Gap(defaultPadding * 0.5),
                        CustomDropdown(
                          key: GlobalKey(),
                          hintText: 'Discount Type',
                          items: ['fixed', 'percentage'],
                          initialValue: context.couponCodeProvider.selectedDiscountType,
                          onChanged: (newValue) {
                            context.couponCodeProvider.selectedDiscountType = newValue ?? 'fixed';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a discount type';
                            }
                            return null;
                          },
                          displayItem: (val) => val,
                          
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: context.couponCodeProvider.couponCodeCtrl,
                            labelText: 'Coupon Code',
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter coupon code';
                              }
                              return null;
                            },
                          ),
                        ),
                        Gap(defaultPadding * 0.5),
                        Expanded(
                          child: CustomDropdown(
                            key: GlobalKey(),
                            hintText: 'Discount Type',
                            items: ['fixed', 'percentage'],
                            initialValue: context.couponCodeProvider.selectedDiscountType,
                            onChanged: (newValue) {
                              context.couponCodeProvider.selectedDiscountType = newValue ?? 'fixed';
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a discount type';
                              }
                              return null;
                            },
                            displayItem: (val) => val,
                          ),
                        ),
                      ],
                    ),
              Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        CustomTextField(
                          controller: context.couponCodeProvider.discountAmountCtrl,
                          labelText: 'Discount Amount',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter discount amount';
                            }
                            return null;
                          },
                        ),
                        Gap(defaultPadding * 0.5),
                        CustomTextField(
                          controller: context.couponCodeProvider.minimumPurchaseAmountCtrl,
                          labelText: 'Minimum Purchase Amount',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter minimum purchase amount';
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
                            controller: context.couponCodeProvider.discountAmountCtrl,
                            labelText: 'Discount Amount',
                            inputType: TextInputType.number,
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter discount amount';
                              }
                              return null;
                            },
                           
                          ),
                        ),
                        Gap(defaultPadding * 0.5),
                        Expanded(
                          child: CustomTextField(
                            controller: context.couponCodeProvider.minimumPurchaseAmountCtrl,
                            labelText: 'Minimum Purchase Amount',
                            inputType: TextInputType.number,
                            onSave: (val) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter minimum purchase amount';
                              }
                              return null;
                            },
                            
                          ),
                        ),
                      ],
                    ),
              Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        CustomDatePicker(
                          labelText: 'Select Date',
                          controller: context.couponCodeProvider.endDateCtrl,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onDateSelected: (DateTime date) {
                            print('Selected Date: $date');
                          },
                          
                        ),
                        Gap(defaultPadding * 0.5),
                        CustomDropdown(
                          key: GlobalKey(),
                          hintText: 'Status',
                          initialValue: context.couponCodeProvider.selectedCouponStatus,
                          items: ['active', 'inactive'],
                          displayItem: (val) => val,
                          onChanged: (newValue) {
                            context.couponCodeProvider.selectedCouponStatus = newValue ?? 'active';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select status';
                            }
                            return null;
                          },
                       
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: CustomDatePicker(
                            labelText: 'Select Date',
                            controller: context.couponCodeProvider.endDateCtrl,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            onDateSelected: (DateTime date) {
                              print('Selected Date: $date');
                            },
                            
                          ),
                        ),
                        Gap(defaultPadding * 0.5),
                        Expanded(
                          child: CustomDropdown(
                            key: GlobalKey(),
                            hintText: 'Status',
                            initialValue: context.couponCodeProvider.selectedCouponStatus,
                            items: ['active', 'inactive'],
                            displayItem: (val) => val,
                            onChanged: (newValue) {
                              context.couponCodeProvider.selectedCouponStatus = newValue ?? 'active';
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select status';
                              }
                              return null;
                            },
                            
                          ),
                        ),
                      ],
                    ),
              Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        Consumer<CouponCodeProvider>(
                          builder: (context, couponProvider, child) {
                            return CustomDropdown(
                              initialValue: couponProvider.selectedCategory,
                              items: context.dataProvider.categories,
                              hintText: 'Select category',
                              displayItem: (Category? category) => category?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  couponProvider.selectedSubCategory = null;
                                  couponProvider.selectedProduct = null;
                                  couponProvider.selectedCategory = newValue;
                                  couponProvider.updateUi();
                                }
                              },
                            
                            );
                          },
                        ),
                        Gap(defaultPadding * 0.5),
                        Consumer<CouponCodeProvider>(
                          builder: (context, couponProvider, child) {
                            return CustomDropdown(
                              initialValue: couponProvider.selectedSubCategory,
                              items: context.dataProvider.subCategories,
                              hintText: 'Select sub category',
                              displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  couponProvider.selectedCategory = null;
                                  couponProvider.selectedProduct = null;
                                  couponProvider.selectedSubCategory = newValue;
                                  couponProvider.updateUi();
                                }
                              },
                          
                            );
                          },
                        ),
                        Gap(defaultPadding * 0.5),
                        Consumer<CouponCodeProvider>(
                          builder: (context, couponProvider, child) {
                            return CustomDropdown(
                              initialValue: couponProvider.selectedProduct,
                              items: context.dataProvider.products,
                              hintText: 'Select product',
                              displayItem: (Product? product) => product?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  couponProvider.selectedCategory = null;
                                  couponProvider.selectedSubCategory = null;
                                  couponProvider.selectedProduct = newValue;
                                  couponProvider.updateUi();
                                }
                              },
                           
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Consumer<CouponCodeProvider>(
                            builder: (context, couponProvider, child) {
                              return CustomDropdown(
                                initialValue: couponProvider.selectedCategory,
                                items: context.dataProvider.categories,
                                hintText: couponProvider.selectedCategory?.name ?? 'Select category',
                                displayItem: (Category? category) => category?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    couponProvider.selectedSubCategory = null;
                                    couponProvider.selectedProduct = null;
                                    couponProvider.selectedCategory = newValue;
                                    couponProvider.updateUi();
                                  }
                                },
                               
                              );
                            },
                          ),
                        ),
                        Gap(defaultPadding * 0.5),
                        Expanded(
                          child: Consumer<CouponCodeProvider>(
                            builder: (context, couponProvider, child) {
                              return CustomDropdown(
                                initialValue: couponProvider.selectedSubCategory,
                                items: context.dataProvider.subCategories,
                                hintText: couponProvider.selectedSubCategory?.name ?? 'Select sub category',
                                displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    couponProvider.selectedCategory = null;
                                    couponProvider.selectedProduct = null;
                                    couponProvider.selectedSubCategory = newValue;
                                    couponProvider.updateUi();
                                  }
                                },
                        
                              );
                            },
                          ),
                        ),
                        Gap(defaultPadding * 0.5),
                        Expanded(
                          child: Consumer<CouponCodeProvider>(
                            builder: (context, couponProvider, child) {
                              return CustomDropdown(
                                initialValue: couponProvider.selectedProduct,
                                items: context.dataProvider.products,
                                hintText: couponProvider.selectedProduct?.name ?? 'Select product',
                                displayItem: (Product? product) => product?.name ?? '',
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    couponProvider.selectedCategory = null;
                                    couponProvider.selectedSubCategory = null;
                                    couponProvider.selectedProduct = newValue;
                                    couponProvider.updateUi();
                                  }
                                },
                               
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              Gap(Responsive.isMobile(context) ? defaultPadding : defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: secondaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
                      ),
                    ),
                  ),
                  Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
                        ),
                      ),
                      onPressed: () {
                        if (context.couponCodeProvider.addCouponFormKey.currentState!.validate()) {
                          context.couponCodeProvider.addCouponFormKey.currentState!.save();
                          context.couponCodeProvider.submitCoupon();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
                      ),
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

void showAddCouponForm(BuildContext context, Coupon? coupon) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Coupon'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: CouponSubmitForm(coupon: coupon),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deleteCouponDialoge(BuildContext context, Coupon coupon) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Coupon?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete this coupon?',
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
              context.couponCodeProvider.deleteCoupon(coupon);
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