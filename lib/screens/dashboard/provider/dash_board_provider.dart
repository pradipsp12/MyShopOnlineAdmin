import 'dart:developer';
import 'dart:io';
import '../../../models/api_response.dart';
import '../../../models/brand.dart';
import '../../../models/sub_category.dart';
import '../../../models/variant_type.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../services/http_services.dart';
import '../../../models/product.dart';
import '../../../utility/snack_bar_helper.dart';

class DashBoardProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addProductFormKey = GlobalKey<FormState>();

  //?text editing controllers in dashBoard screen
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescCtrl = TextEditingController();
  TextEditingController productQntCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  TextEditingController productOffPriceCtrl = TextEditingController();

  //? dropdown value
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Brand? selectedBrand;
  VariantType? selectedVariantType;
  List<String> selectedVariants = [];

  Product? productForUpdate;
  File? selectedMainImage, selectedSecondImage, selectedThirdImage, selectedFourthImage, selectedFifthImage;
  XFile? mainImgXFile, secondImgXFile, thirdImgXFile, fourthImgXFile, fifthImgXFile;

  List<SubCategory> subCategoriesByCategory = [];
  List<Brand> brandsBySubCategory = [];
  List<String> variantsByVariantType = [];


  DashBoardProvider(this._dataProvider);


addProduct()async{
    try {
      if(selectedMainImage == null){
      SnackBarHelper.showErrorSnackBar('Please select a main image');
      return;
      }
      Map<String, dynamic> formDataMap = {
        'name': productNameCtrl.text,
        'description': productDescCtrl.text,
        'proCategoryId':selectedCategory?.sId ?? '',
        'proSubCategoryId': selectedSubCategory?.sId ?? '',
        'proBrandId': selectedBrand?.sId ?? '',
        'proVariantTypeId': selectedVariantType?.sId ?? '',
        'proVariantId': selectedVariants,
        'price': productPriceCtrl.text,
        'offerPrice': productOffPriceCtrl.text.isEmpty ? productPriceCtrl.text : productOffPriceCtrl.text,
        'quantity': productQntCtrl.text,
      };
      final formData = await createFormDataForMultipleImage(
        imgXFiles: [
          {'image1': mainImgXFile},
          {'image2': secondImgXFile},
          {'image3': thirdImgXFile},
          {'image4': fourthImgXFile},
          {'image5': fifthImgXFile}
        ],
        formData: formDataMap,
      );
      if(productForUpdate != null){}
      final response = await service.addItem(endpointUrl: 'products', itemData: formData);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllProduct();
          log('product added');
          clearFields();
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to add product: ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      // Handle error
      SnackBarHelper.showErrorSnackBar( 'Failed to add product: $e');
      rethrow;
    }
  }

updateProduct()async{
    try {
      
      Map<String, dynamic> formDataMap = {
        'name': productNameCtrl.text,
        'description': productDescCtrl.text,
        'proCategoryId':selectedCategory?.sId ?? '',
        'proSubCategoryId': selectedSubCategory?.sId ?? '',
        'proBrandId': selectedBrand?.sId ?? '',
        'proVariantTypeId': selectedVariantType?.sId ?? '',
        'proVariantId': selectedVariants,
        'price': productPriceCtrl.text,
        'offerPrice': productOffPriceCtrl.text.isEmpty ? productPriceCtrl.text : productOffPriceCtrl.text,
        'quantity': productQntCtrl.text,
      };
      final formData = await createFormDataForMultipleImage(
        imgXFiles: [
          {'image1': mainImgXFile},
          {'image2': secondImgXFile},
          {'image3': thirdImgXFile},
          {'image4': fourthImgXFile},
          {'image5': fifthImgXFile}
        ],
        formData: formDataMap,
      );
      if(productForUpdate != null){}
      final response = await service.updateItem(endpointUrl: 'products', itemData: formData, itemId: '${productForUpdate?.sId}');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllProduct();
          log('product updated');
          clearFields();
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to update product: ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      // Handle error
      SnackBarHelper.showErrorSnackBar( 'Failed to update product: $e');
      rethrow;
    }
  }


submitProduct(){
  if(productForUpdate != null){
    updateProduct();
  }else{
    addProduct();
  }
 }


deleteProduct(Product product)async{
    try {
      final response = await service.deleteItem(endpointUrl: 'products', itemId: '${product.sId}');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllProduct();
          log('product deleted');
        }else{
          SnackBarHelper.showErrorSnackBar('Failed to delete product: ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      // Handle error
      SnackBarHelper.showErrorSnackBar( 'Failed to delete product: $e');
      rethrow;
    }
  }



void pickImage({required int imageCardNumber}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (imageCardNumber == 1) {
        selectedMainImage = File(image.path);
        mainImgXFile = image;
      } else if (imageCardNumber == 2) {
        selectedSecondImage = File(image.path);
        secondImgXFile = image;
      } else if (imageCardNumber == 3) {
        selectedThirdImage = File(image.path);
        thirdImgXFile = image;
      } else if (imageCardNumber == 4) {
        selectedFourthImage = File(image.path);
        fourthImgXFile = image;
      } else if (imageCardNumber == 5) {
        selectedFifthImage = File(image.path);
        fifthImgXFile = image;
      }
      notifyListeners();
    }
  }

Future<FormData> createFormDataForMultipleImage({
  required List<Map<String, XFile?>>? imgXFiles,
  required Map<String, dynamic> formData,
}) async {
  if (imgXFiles != null) {
    for (int i = 0; i < imgXFiles.length; i++) {
      XFile? imgXFile = imgXFiles[i]['image${i + 1}'];
      if (imgXFile != null) {
        // Validate file type
        if (!['image/jpeg', 'image/jpg', 'image/png'].contains(imgXFile.mimeType?.toLowerCase())) {
          throw Exception('Invalid file type for image${i + 1}. Only JPEG or PNG allowed.');
        }

        String fieldName = 'image${i + 1}';
        String fileName = kIsWeb ? imgXFile.name : imgXFile.path.split('/').last;
        String mimeType = 'image/${fileName.split('.').last.toLowerCase()}';

        MultipartFile multipartFile;
        if (kIsWeb) {
          Uint8List byteImg = await imgXFile.readAsBytes();
          multipartFile = MultipartFile(
            byteImg,
            filename: fileName,
            contentType: mimeType,
          );
        } else {
          multipartFile = MultipartFile(
            File(imgXFile.path),
            filename: fileName,
            contentType: mimeType,
          );
        }

        formData[fieldName] = multipartFile;
      }
    }
  }

  final FormData form = FormData(formData);
  return form;
}


filterSubcategory(Category category) {
    selectedSubCategory = null;
    selectedBrand = null;
    selectedCategory = category;
    subCategoriesByCategory.clear();
    final newList = _dataProvider.subCategories
        .where((subcategory) => subcategory.categoryId?.sId == category.sId)
        .toList();
    subCategoriesByCategory = newList;
    notifyListeners();
  }

filterBrand(SubCategory subCategory) {
    selectedBrand = null;
    selectedSubCategory = subCategory;
    brandsBySubCategory.clear();
    final newList = _dataProvider.brands
        .where((brand) => brand.subcategoryId?.sId == subCategory.sId)
        .toList();
    brandsBySubCategory = newList;
    notifyListeners();
  }


filterVariant(VariantType variantType) {
    selectedVariants = [];
    selectedVariantType = variantType;
    final newList = _dataProvider.variants
        .where((variant) => variant.variantTypeId?.sId == variantType.sId)
        .toList();
    final List<String> variantNames = newList.map((variant) => variant.name ?? '').toList();
    variantsByVariantType = variantNames;
    notifyListeners();
  }



setDataForUpdateProduct(Product? product) {
    if (product != null) {
      productForUpdate = product;

      productNameCtrl.text = product.name ?? '';
      productDescCtrl.text = product.description ?? '';
      productPriceCtrl.text = product.price.toString();
      productOffPriceCtrl.text = '${product.offerPrice}';
      productQntCtrl.text = '${product.quantity}';

      selectedCategory = _dataProvider.categories.firstWhereOrNull((element) => element.sId == product.proCategoryId?.sId);

      final newListCategory = _dataProvider.subCategories
          .where((subcategory) => subcategory.categoryId?.sId == product.proCategoryId?.sId)
          .toList();
      subCategoriesByCategory = newListCategory;
      selectedSubCategory =
          _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == product.proSubCategoryId?.sId);

      final newListBrand =
          _dataProvider.brands.where((brand) => brand.subcategoryId?.sId == product.proSubCategoryId?.sId).toList();
      brandsBySubCategory = newListBrand;
      selectedBrand = _dataProvider.brands.firstWhereOrNull((element) => element.sId == product.proBrandId?.sId);

      selectedVariantType =
          _dataProvider.variantTypes.firstWhereOrNull((element) => element.sId == product.proVariantTypeId?.sId);

      final newListVariant = _dataProvider.variants
          .where((variant) => variant.variantTypeId?.sId == product.proVariantTypeId?.sId)
          .toList();
      final List<String> variantNames = newListVariant.map((variant) => variant.name ?? '').toList();
      variantsByVariantType = variantNames;
      selectedVariants = product.proVariantId ?? [];
    } else {
      clearFields();
    }
  }

clearFields() {
    productNameCtrl.clear();
    productDescCtrl.clear();
    productPriceCtrl.clear();
    productOffPriceCtrl.clear();
    productQntCtrl.clear();

    selectedMainImage = null;
    selectedSecondImage = null;
    selectedThirdImage = null;
    selectedFourthImage = null;
    selectedFifthImage = null;

    mainImgXFile = null;
    secondImgXFile = null;
    thirdImgXFile = null;
    fourthImgXFile = null;
    fifthImgXFile = null;

    selectedCategory = null;
    selectedSubCategory = null;
    selectedBrand = null;
    selectedVariantType = null;
    selectedVariants = [];

    productForUpdate = null;

    subCategoriesByCategory = [];
    brandsBySubCategory = [];
    variantsByVariantType = [];
  }

updateUI() {
    notifyListeners();
  }
}

