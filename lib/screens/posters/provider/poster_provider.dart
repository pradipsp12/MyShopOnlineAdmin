import 'dart:developer';
import 'dart:io';
import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/poster.dart';

class PosterProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addPosterFormKey = GlobalKey<FormState>();
  TextEditingController posterNameCtrl = TextEditingController();
  Poster? posterForUpdate;


  File? selectedImage;
  XFile? imgXFile;


  PosterProvider(this._dataProvider);

  addPoster()async{
    
    try {
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
        'posterName': posterNameCtrl.text,
      };
      FormData formData = await createFormData(imgXFile: imgXFile, formData: formDataMap);
      final response = await service.addItem(endpointUrl: 'posters', itemData: formData);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('Poster added successfully');
          log('Poster added');
         _dataProvider.getAllPosters();
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to add poster: ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to add poster ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to add poster $e');
      rethrow;
    }
  }


  updatePoster()async{
    try {
      Map<String, dynamic> formDataMap = {
        'posterName': posterNameCtrl.text,
        'imageUrl':posterForUpdate?.imageUrl ?? '',
      };
      FormData formData = await createFormData(imgXFile: imgXFile, formData: formDataMap);
      final response = await service.updateItem(endpointUrl: 'posters', itemData: formData, itemId: posterForUpdate?.sId ??'');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('Poster updated successfully');
          log('Poster updated');
          _dataProvider.getAllPosters();
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to update poster: ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Failed to update poster ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to update poster $e');
      rethrow;
    }
  }


  submitPoster() {
    if (posterForUpdate != null) {
      updatePoster();
    } else {
      addPoster();
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


deletePoster(Poster poster) async {
    try {
      final response = await service.deleteItem(endpointUrl: 'posters', itemId: poster.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Poster deleted successfully');
          log('Poster deleted');
          _dataProvider.getAllPosters();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to delete poster: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to delete poster ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to delete poster $e');
      rethrow;
    }
  }


  setDataForUpdatePoster(Poster? poster) {
    if (poster != null) {
      clearFields();
      posterForUpdate = poster;
      posterNameCtrl.text = poster.posterName ?? '';
    } else {
      clearFields();
    }
  }

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

  clearFields() {
    posterNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    posterForUpdate = null;
  }
}
