import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../models/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';


class BrandProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addBrandFormKey = GlobalKey<FormState>();
  TextEditingController brandNameCtrl = TextEditingController();
  SubCategory? selectedSubCategory;
  Brand? brandForUpdate;




  BrandProvider(this._dataProvider);




  addBrand()async{
    try {
      Map<String, dynamic> formDataMap = {
        'name': brandNameCtrl.text,
        'subcategoryId' : selectedSubCategory?.sId,
      };
      final response = await service.addItem(endpointUrl: 'brand', itemData: formDataMap);
      if(response.isOk){
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if(apiResponse.success == true){
            clearFields();
            log('Brand Added');
            SnackBarHelper.showSuccessSnackBar(apiResponse.message);
            _dataProvider.getAllBrands();
          }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to add brand ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e); 
      SnackBarHelper.showErrorSnackBar('Failed to add brand ${e}');
    }
  }


 
  updateBrand()async{
    try {
      Map<String, dynamic> formDataMap = {
        'name': brandNameCtrl.text,
        'subcategoryId': selectedSubCategory?.sId
      }; 
      final response = await service.updateItem(endpointUrl: 'brand', itemId: brandForUpdate?.sId ?? '', itemData: formDataMap);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          log('Brand update');
          _dataProvider.getAllBrands();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to update brand ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to update brand ${e}');
      rethrow; 
    }
  }


  
  submitBrand(){
    if(brandForUpdate != null){
      updateBrand();
    }else{
      addBrand();
    }
  }



  deleteBrand(Brand brand)async{
    try {
      final response = await service.deleteItem(endpointUrl: 'brand', itemId: brand.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllBrands();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to delete Brand ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e); 
      SnackBarHelper.showErrorSnackBar('Failed to delete brand ${e}');
      rethrow;
    }
  }

  //? set data for update on editing
  setDataForUpdateBrand(Brand? brand) {
    if (brand != null) {
      brandForUpdate = brand;
      brandNameCtrl.text = brand.name ?? '';
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == brand.subcategoryId?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update brand
  clearFields() {
    brandNameCtrl.clear();
    selectedSubCategory = null;
    brandForUpdate = null;
  }

  updateUI(){
    notifyListeners();
  }

}
