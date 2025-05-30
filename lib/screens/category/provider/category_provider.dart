import 'dart:developer';
import 'dart:io';
import 'package:admin/models/api_response.dart';

import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../utility/snack_bar_helper.dart';

class CategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController categoryNameCtrl = TextEditingController();
  Category? categoryForUpdate;


  File? selectedImage;
  XFile? imgXFile;


  CategoryProvider(this._dataProvider);

  addCategory()async{
    try{
      if (imgXFile == null) {
        SnackBarHelper.showErrorSnackBar('Please choose an image!');
        return;
      }

      // Validate file type before sending
      if (!['image/jpeg', 'image/jpg', 'image/png'].contains(imgXFile?.mimeType?.toLowerCase())) {
        SnackBarHelper.showErrorSnackBar('Only JPEG or PNG images are allowed!');
        return;
      }
      Map<String, dynamic> formDataMap = {
        "name": categoryNameCtrl.text,
      };
      final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.addItem(endpointUrl: 'categories', itemData: form);

      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllCategory();
          log('category added');
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to add category: ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message']?? response.statusText}');
      } 
    }catch(e){
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  updateCategory() async{
    try{
      Map<String, dynamic> formDataMap = {
          'name': categoryNameCtrl.text,
          'image': categoryForUpdate?.image ?? '',
      };
    final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);
    final response = await service.updateItem(endpointUrl: 'categories', itemData: form, itemId: categoryForUpdate?.sId ??'');

    if(response.isOk){
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
      if(apiResponse.success == true){
        clearFields();
        SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
        log('Category Updated');
        _dataProvider.getAllCategory();
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to update Category : ${apiResponse.message}');
      }
    }else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message']?? response.statusText}');
    }
    }catch(e){
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  submitCategory(){
    if(categoryForUpdate != null){
      updateCategory();
    }else{
      addCategory();
    }
  }


  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Validate file type
      if (['image/jpeg', 'image/jpg', 'image/png'].contains(image.mimeType?.toLowerCase())) {
        selectedImage = File(image.path);
        imgXFile = image;
        notifyListeners();
      } else {
        SnackBarHelper.showErrorSnackBar('Please select a JPEG or PNG image.');
      }
    }
  }

 
  deleteCategory( Category category)async{
    try {
      final response = await service.deleteItem(endpointUrl: 'categories', itemId: category.sId ?? ''); 
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllCategory();
        }else{
          SnackBarHelper.showErrorSnackBar('Category delete failed ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Category delete failed ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error occured ${e}');
    }
  }



  //? to create form data for sending image with body
  Future<FormData> createFormData({required XFile? imgXFile, required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      MultipartFile multipartFile;
      if (kIsWeb) {
        String fileName = imgXFile.name;
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = MultipartFile(byteImg, filename: fileName, contentType: 'image/${fileName.split('.').last}');
      } else {
        String fileName = imgXFile.path.split('/').last;
         multipartFile = MultipartFile(imgXFile.path, filename: fileName, contentType: 'image/${fileName.split('.').last}');
      }
      formData['img'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  //? set data for update on editing
  setDataForUpdateCategory(Category? category) {
    if (category != null) {
      clearFields();
      categoryForUpdate = category;
      categoryNameCtrl.text = category.name ?? '';
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update category
  clearFields() {
    categoryNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    categoryForUpdate = null;
  }
}
