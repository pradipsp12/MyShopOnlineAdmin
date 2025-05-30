import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant_type.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsTypeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addVariantsTypeFormKey = GlobalKey<FormState>();
  TextEditingController variantNameCtrl = TextEditingController();
  TextEditingController variantTypeCtrl = TextEditingController();

  VariantType? variantTypeForUpdate;



  VariantsTypeProvider(this._dataProvider);



  addVariantType()async{
    try {
      Map<String, dynamic> formDataMap = {
      'name': variantNameCtrl.text,
      'type': variantTypeCtrl.text,
    };
    final response = await service.addItem(endpointUrl: 'variantTypes', itemData: formDataMap);
    if(response.isOk){
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
      if(apiResponse.success == true){
        clearFields();
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        _dataProvider.getAllVariantType();
      }
    }else{
      SnackBarHelper.showErrorSnackBar('Failed to add variant type ${response.body?['message'] ?? response.statusText }');
    }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to add varient type ${e}');
      rethrow;
    }
  }


  updateVariantType()async{
    try {
      Map<String, dynamic> formDataMap = {
        'name': variantNameCtrl.text,
        'type': variantTypeCtrl.text,
      };
      final response = await service.updateItem(endpointUrl: 'variantTypes', itemData: formDataMap, itemId: variantTypeForUpdate?.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllVariantType();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to update variant type ${response.body?['message'] ?? response.statusText }');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to update varient type ${e}');
      rethrow;
    }
  }


  submitVariantType() {
    if (variantTypeForUpdate != null) {
      updateVariantType();
    } else {
      addVariantType();
    }
  }

deleteVariantType(VariantType variantType)async{
    try {
      final response = await service.deleteItem(endpointUrl: 'variantTypes', itemId: variantType.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllVariantType();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to delete variant type ${response.body?['message'] ?? response.statusText }');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to delete varient type ${e}');
      rethrow;
    }
  }


  setDataForUpdateVariantTYpe(VariantType? variantType) {
    if (variantType != null) {
      variantTypeForUpdate = variantType;
      variantNameCtrl.text = variantType.name ?? '';
      variantTypeCtrl.text = variantType.type ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantNameCtrl.clear();
    variantTypeCtrl.clear();
    variantTypeForUpdate = null;
  }
}
