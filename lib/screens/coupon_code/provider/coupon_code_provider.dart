import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../models/coupon.dart';
import '../../../models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';

class CouponCodeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  Coupon? couponForUpdate;

  final addCouponFormKey = GlobalKey<FormState>();
  TextEditingController couponCodeCtrl = TextEditingController();
  TextEditingController discountAmountCtrl = TextEditingController();
  TextEditingController minimumPurchaseAmountCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  String selectedDiscountType = 'fixed';
  String selectedCouponStatus = 'active';
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Product? selectedProduct;

  CouponCodeProvider(this._dataProvider);

  addCoupon()async{
    try {
      Map<String, dynamic> formDataMap = {
        'couponCode': couponCodeCtrl.text,
        'discountType': selectedDiscountType,
        'discountAmount': discountAmountCtrl.text,
        'minimumPurchaseAmount': minimumPurchaseAmountCtrl.text,
        'endDate': endDateCtrl.text,
        'status': selectedCouponStatus,
        'applicableCategory': selectedCategory?.sId,
        'applicableSubCategory': selectedSubCategory?.sId,
        'applicableProduct': selectedProduct?.sId
      };
      final response = await service.addItem(endpointUrl: 'couponCodes', itemData: formDataMap);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('Coupon added successfully');
          _dataProvider.getAllCoupons();
          log('Cuponcode added');
        }else{
          SnackBarHelper.showErrorSnackBar('failed to add coupon ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('failed to add coupon ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('failed to add coupon $e');
    }
  }


updateCoupon()async{
    try {
      Map<String, dynamic> formDataMap = {
        'couponCode': couponCodeCtrl.text,
        'discountType': selectedDiscountType,
        'discountAmount': discountAmountCtrl.text,
        'minimumPurchaseAmount': minimumPurchaseAmountCtrl.text,
        'endDate': endDateCtrl.text,
        'status': selectedCouponStatus,
        'applicableCategory': selectedCategory?.sId,
        'applicableSubCategory': selectedSubCategory?.sId,
        'applicableProduct': selectedProduct?.sId
      };
      final response = await service.updateItem(endpointUrl: 'couponCodes', itemData: formDataMap, itemId: couponForUpdate?.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('Coupon updated successfully');
          _dataProvider.getAllCoupons();
          log('Cuponcode updated');
        }else{
          SnackBarHelper.showErrorSnackBar('failed to update coupon ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('failed to update coupon ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('failed to update coupon $e');
    }
  }


submitCoupon(){
  if(couponForUpdate == null) {
    addCoupon();
  } else {
    updateCoupon();
  }
}


deleteCoupon(Coupon coupon) async {
    try {
      final response = await service.deleteItem(endpointUrl: 'couponCodes', itemId: coupon.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Coupon deleted successfully');
          _dataProvider.getAllCoupons();
          log('Cuponcode deleted');
        } else {
          SnackBarHelper.showErrorSnackBar('failed to delete coupon ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('failed to delete coupon ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('failed to delete coupon $e');
    }
  }



  //? set data for update on editing
  setDataForUpdateCoupon(Coupon? coupon) {
    if (coupon != null) {
      couponForUpdate = coupon;
      couponCodeCtrl.text = coupon.couponCode ?? '';
      selectedDiscountType = coupon.discountType ?? 'fixed';
      discountAmountCtrl.text = '${coupon.discountAmount}';
      minimumPurchaseAmountCtrl.text = '${coupon.minimumPurchaseAmount}';
      endDateCtrl.text = '${coupon.endDate}';
      selectedCouponStatus = coupon.status ?? 'active';
      selectedCategory = _dataProvider.categories.firstWhereOrNull((element) => element.sId == coupon.applicableCategory?.sId);
      selectedSubCategory =
          _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == coupon.applicableSubCategory?.sId);
      selectedProduct = _dataProvider.products.firstWhereOrNull((element) => element.sId == coupon.applicableProduct?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update coupon
  clearFields() {
    couponForUpdate = null;
    selectedCategory = null;
    selectedSubCategory = null;
    selectedProduct = null;

    couponCodeCtrl.text = '';
    discountAmountCtrl.text = '';
    minimumPurchaseAmountCtrl.text = '';
    endDateCtrl.text = '';
  }

  updateUi() {
    notifyListeners();
  }
}
