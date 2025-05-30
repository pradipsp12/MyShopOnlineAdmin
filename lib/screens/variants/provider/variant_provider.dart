import '../../../models/variant_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addVariantsFormKey = GlobalKey<FormState>();
  TextEditingController variantCtrl = TextEditingController();
  VariantType? selectedVariantType;
  Variant? variantForUpdate;




  VariantsProvider(this._dataProvider);


  addVariant()async{
    try {
      Map<String, dynamic> formDataMap = {
        'name': variantCtrl.text,
        'variantTypeId': selectedVariantType?.sId,
      };
      final response = await service.addItem(endpointUrl: 'variants', itemData: formDataMap);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllVariant();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to add variant ${response.body?['message'] ?? response.statusText }');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to add varient ${e}');
      rethrow;
    }
  }


updateVariant()async{
    try {
      Map<String, dynamic> formDataMap = {
        'name': variantCtrl.text,
        'variantTypeId': selectedVariantType?.sId,
      };
      final response = await service.updateItem(endpointUrl: 'variants', itemData: formDataMap, itemId: variantForUpdate?.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllVariant();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to update variant ${response.body?['message'] ?? response.statusText }');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to update varient ${e}');
      rethrow;
    }
  }
  submitVariant() {
    if (variantForUpdate != null) {
      updateVariant();
    } else {
      addVariant();
    }
  }

  deleteVariant(Variant variant )async{
    try {
      final response = await service.deleteItem(endpointUrl: 'variants', itemId: variant.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllVariant();
        }else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to delete variant ${response.body?['message'] ?? response.statusText }');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to delete varient ${e}');
      rethrow;
    }
  }




  setDataForUpdateVariant(Variant? variant) {
    if (variant != null) {
      variantForUpdate = variant;
      variantCtrl.text = variant.name ?? '';
      selectedVariantType =
          _dataProvider.variantTypes.firstWhereOrNull((element) => element.sId == variant.variantTypeId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantCtrl.clear();
    selectedVariantType = null;
    variantForUpdate = null;
  }

  void updateUI() {
    notifyListeners();
  }
}
