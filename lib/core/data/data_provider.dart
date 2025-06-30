import 'dart:convert';

import '../../models/api_response.dart';
import '../../models/coupon.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/variant_type.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';
import '../../models/brand.dart';
import '../../models/sub_category.dart';
import '../../models/variant.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<VariantType> _allVariantTypes = [];
  List<VariantType> _filteredVariantTypes = [];
  List<VariantType> get variantTypes => _filteredVariantTypes;

  List<Variant> _allVariants = [];
  List<Variant> _filteredVariants = [];
  List<Variant> get variants => _filteredVariants;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];
  List<Coupon> get coupons => _filteredCoupons;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];
  List<MyNotification> get notifications => _filteredNotifications;



  DataProvider() {
    // getAllProduct();
    // getAllCategory();
    // getAllSubCategory();
    // getAllBrands();
    // getAllVariantType();
    // getAllVariant();
    // getAllPosters();
    // getAllCoupons();
    getAllOrders();
    // getAllNotifications();
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      _isLoading = true;
      Response response = await service.getItems(endpointUrl: 'categories');

      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(_allCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'failed to load category: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }

  void filterCategories(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredCategories = _allCategories
          .where((category) =>
              (category.name ?? '').toLowerCase().contains(lowerKeyboard))
          .toList();
    }
    notifyListeners();
  }

  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'subCategory');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => SubCategory.fromJson(item)).toList(),
        );
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'failed to fetch sub-category : ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      // print(e);
      print(e);
      SnackBarHelper.showErrorSnackBar('failed to fetch sub-category :${e}');
      rethrow;
    }

    return _filteredSubCategories;
  }

  void filterSubCategories(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredSubCategories = _allSubCategories
          .where((subCategory) =>
              (subCategory.name ?? '').toLowerCase().contains(lowerKeyboard))
          .toList();
    }
    notifyListeners();
  }

  Future<List<Brand>> getAllBrands({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'brand');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse = ApiResponse.fromJson(
            response.body,
            (json) =>
                (json as List).map((item) => Brand.fromJson(item)).toList());
        _allBrands = apiResponse.data ?? [];
        _filteredBrands = List.from(_allBrands);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'failed to load brand ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load brand ${e}');
      rethrow;
    }
    return _filteredBrands;
  }

  void filterBrands(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredBrands = _allBrands
          .where((brand) =>
              (brand.name ?? '').toLowerCase().contains(lowerKeyboard))
          .toList();
    }
    notifyListeners();
  }

  Future<List<VariantType>> getAllVariantType({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'variantTypes');
      if (response.isOk) {
        ApiResponse<List<VariantType>> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => VariantType.fromJson(item)).toList(),
        );
        _allVariantTypes = apiResponse.data ?? [];
        _filteredVariantTypes = List.from(_allVariantTypes);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load variant types: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load variant types: $e');
      rethrow;
    }
    return _filteredVariantTypes;
  }

  void filterVariantTypes(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredVariantTypes = List.from(_allVariantTypes);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredVariantTypes = _allVariantTypes
          .where((variantType) =>
              (variantType.name ?? '').toLowerCase().contains(lowerKeyboard))
          .toList();
    }
    notifyListeners();
  }

  Future<List<Variant>> getAllVariant({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'variants');
      if (response.isOk) {
        ApiResponse<List<Variant>> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Variant.fromJson(item)).toList(),
        );
        _allVariants = apiResponse.data ?? [];
        _filteredVariants = List.from(_allVariants);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load variants: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load variants: $e');
      rethrow;
    }
    return _filteredVariants;
  }

  void filterVariants(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredVariants = List.from(_allVariants);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredVariants = _allVariants
          .where((variant) =>
              (variant.name ?? '').toLowerCase().contains(lowerKeyboard))
          .toList();
    }
    notifyListeners();
  }

  getAllProduct({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'products');
      if (response.isOk) {
        ApiResponse<List<Product>> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Product.fromJson(item)).toList(),
        );
        _allProducts = apiResponse.data ?? [];
        _filteredProducts = List.from(_allProducts);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load products: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load products: $e');
      rethrow;
    }
  }

  void filterProducts(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword =
            (product.name ?? '').toLowerCase().contains(lowerKeyboard);
        final categoryNameContainsKeyword = product.proCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyboard) ??
            false;
        final subCategoryNameContainsKeyword = product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyboard) ??
            false;
        return productNameContainsKeyword ||
            categoryNameContainsKeyword ||
            subCategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

getAllCoupons({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'couponCodes');
      if (response.isOk) {
        ApiResponse<List<Coupon>> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Coupon.fromJson(item)).toList(),
        );
        _allCoupons = apiResponse.data ?? [];
        _filteredCoupons = List.from(_allCoupons);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load coupons: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load coupons: $e');
      rethrow;
    }
  }

  void filterCoupons(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredCoupons = List.from(_allCoupons);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredCoupons = _allCoupons.where((coupon) {
        return (coupon.couponCode ?? '')
            .toLowerCase()
            .contains(lowerKeyboard);
      }).toList();
    }
    notifyListeners();
  }


getAllPosters({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Poster.fromJson(item)).toList(),
        );
        _allPosters = apiResponse.data ?? [];
        _filteredPosters = List.from(_allPosters);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load posters: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      print(e);
      SnackBarHelper.showErrorSnackBar('Failed to load posters: $e');
      rethrow;
    }
  }

  void filterPosters(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredPosters = List.from(_allPosters);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? '')
            .toLowerCase()
            .contains(lowerKeyboard);
      }).toList();
    }
    notifyListeners();
  }



  Future<List<Order>> getAllOrders({bool showSnack = false})async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'orders');
      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse = ApiResponse<List<Order>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Order.fromJson(item)).toList(),
        );
        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load orders: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load orders: $e');
      rethrow;
    }
    return _filteredOrders;
    
  }

  filterOrders(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredOrders = List.from(_allOrders);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
     _filteredOrders = _allOrders.where((order) {
        bool nameMatches = (order.userID?.name ?? '')
            .toLowerCase()
            .contains(lowerKeyboard);
        final statusMatches = (order.orderStatus ?? '')
            .toLowerCase()
            .contains(keyboard.toLowerCase());
        return nameMatches || statusMatches;
      }).toList();
    }
    notifyListeners();
  }

int calculateOrdersWithStatus({String? status}){
    int totalOrders = 0;
    if (status == null) {
      totalOrders = _allOrders.length;
    } else {
      for (Order order in _allOrders) {
        if (order.orderStatus?.toLowerCase() == status.toLowerCase()) {
          totalOrders++;
        }
      }
    }
    return totalOrders;
  }

  
  Future<List<MyNotification>> getAllNotifications({bool showSnack = false}) async {
    try {
      _isLoading = true;
      final response = await service.getItems(endpointUrl: 'notification/all-notification');
      if (response.isOk) {
        ApiResponse<List<MyNotification>> apiResponse = ApiResponse<List<MyNotification>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => MyNotification.fromJson(item)).toList(),
        );
        _allNotifications = apiResponse.data ?? [];
        _filteredNotifications = List.from(_allNotifications);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to load notifications: ${response.body?['message'] ?? response.statusText}');
      }
      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
      SnackBarHelper.showErrorSnackBar('Failed to load notifications: $e');
      rethrow;
    }
    return _filteredNotifications;
  }



  void filterNotifications(String keyboard) {
    if (keyboard.isEmpty) {
      _filteredNotifications = List.from(_allNotifications);
    } else {
      final lowerKeyboard = keyboard.toLowerCase();
      _filteredNotifications = _allNotifications.where((notification) {
        return (notification.title ?? '')
            .toLowerCase()
            .contains(lowerKeyboard);
      }).toList();
    }
    notifyListeners();
  }

  filterProductsByQuantity(String? productQntType) {
    if (productQntType == 'All Product') {
      _filteredProducts = List.from(_allProducts);
    } else if (productQntType == 'Out of Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 0;
      }).toList();
    } else if (productQntType == 'Limited Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 1;
      }).toList();
    } else if (productQntType == 'Other Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null &&
            product.quantity != 0 &&
            product.quantity != 1;
      }).toList();
    } else {
      _filteredProducts = List.from(_allProducts);
    }
    notifyListeners();
  }

  int calculateProductWithQuantity({int? quantity}) {
    int totalProduct = 0;
    if (quantity == null) {
      totalProduct = _allProducts.length;
    } else {
      for (Product product in _allProducts) {
        if (product.quantity != null && product.quantity == quantity) {
          totalProduct++;
        }
      }
    }

    return totalProduct;
  }
}
