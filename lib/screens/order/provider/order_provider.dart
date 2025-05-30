import 'dart:developer';

import 'package:admin/models/api_response.dart';

import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../utility/snack_bar_helper.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);


  updateOrder()async{
    try {
      if(orderForUpdate !=null){
        Map<String, dynamic> order = {
          'trackingUrl': trackingUrlCtrl.text,
          'orderStatus': selectedOrderStatus,
        };
        final response = await service.updateItem(endpointUrl: 'orders', itemId: orderForUpdate?.sId ?? '', itemData: order);
        if(response.isOk){
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if(apiResponse.success == true) {
            SnackBarHelper.showSuccessSnackBar(apiResponse.message);
            log('Order updated successfully');
            _dataProvider.getAllOrders();
          } else {
            SnackBarHelper.showErrorSnackBar(apiResponse.message);
          }
        }else {
          SnackBarHelper.showErrorSnackBar('Failed to update order ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred while updating the order: $e');
      rethrow;
    }
  }
deleteOrder(Order order) async{
  try {
    final response = await service.deleteItem(endpointUrl: 'orders', itemId: order.sId ?? '');
    if (response.isOk) {
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
      if (apiResponse.success == true) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        log('Order deleted successfully');
        _dataProvider.getAllOrders();
      } else {
        SnackBarHelper.showErrorSnackBar(apiResponse.message);
      }
    } else {
      SnackBarHelper.showErrorSnackBar('Failed to delete order ${response.body?['message'] ?? response.statusText}');
    }
  } catch (e) {
    print(e);
    SnackBarHelper.showErrorSnackBar('An error occurred while deleting the order: $e');
    rethrow;
    
  }
}



  updateUI() {
    notifyListeners();
  }
}
