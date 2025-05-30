import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';


class SubCategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addSubCategoryFormKey = GlobalKey<FormState>();
  TextEditingController subCategoryNameCtrl = TextEditingController();
  Category? selectedCategory;
  SubCategory? subCategoryForUpdate;




  SubCategoryProvider(this._dataProvider);


  //TODO-Done: should complete addSubCategory
  addSubCategory()async{
    try {
      Map<String, dynamic> subCategory ={
        'name' : subCategoryNameCtrl.text, 
        'categoryId' : selectedCategory?.sId,
      };

      final response = await service.addItem(endpointUrl: 'subCategory', itemData: subCategory);

      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
            clearFields();
            _dataProvider.getAllSubCategory();
            SnackBarHelper.showSuccessSnackBar(apiResponse.message);
            log('Sub Category added');
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to add sub-category ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to add sub-category ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e); 
    }
  }

  //TODO-Done: should complete updateSubCategory
  updateSubCategory()async{
    try {
      Map<String, dynamic> formDataMap = {
      'name': subCategoryNameCtrl.text,
      'categoryId': selectedCategory ?? '',
    };
    final response = await service.updateItem(endpointUrl: 'subCategory', itemId: subCategoryForUpdate?.sId ?? '', itemData: formDataMap);
    if(response.isOk){
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Sub-Category Updated');
          _dataProvider.getAllSubCategory();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
    }else{
      SnackBarHelper.showErrorSnackBar('failed to update sub-category ${response.body?['message'] ?? response.statusText}');
    }

    } catch (e) {
      print(e); 
      SnackBarHelper.showErrorSnackBar('failed to update ${e}');
      rethrow;
    }
  }


  //TODO-Done: should complete submitSubCategory

  submitSubCategory(){
    if(subCategoryForUpdate != null){
      updateSubCategory();
    }else{
      addSubCategory();
    }
  }

  //TODO-Done: should complete deleteSubCategory
  deleteSubCategory(SubCategory sub_category)async{
    try {
      final response = await service.deleteItem(endpointUrl: 'subCategory', itemId:sub_category.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllSubCategory();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Sub-category delete failed ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e); 
      SnackBarHelper.showErrorSnackBar('Sub-Category Delete failed ${e}');
      rethrow;
    }
  }


  setDataForUpdateCategory(SubCategory? subCategory) {
    if (subCategory != null) {
      subCategoryForUpdate = subCategory;
      subCategoryNameCtrl.text = subCategory.name ?? '';
      selectedCategory = _dataProvider.categories.firstWhereOrNull((element) => element.sId == subCategory.categoryId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    subCategoryNameCtrl.clear();
    selectedCategory = null;
    subCategoryForUpdate = null;
  }

  updateUi(){
    notifyListeners();
  }
}
