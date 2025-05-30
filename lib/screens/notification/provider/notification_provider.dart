import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/models/my_notification.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../models/notification_result.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../services/http_services.dart';


class NotificationProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final sendNotificationFormKey = GlobalKey<FormState>();

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController imageUrlCtrl = TextEditingController();

  NotificationResult? notificationResult;

  NotificationProvider(this._dataProvider);



  sendNotification()async{
    try {
      Map<String, dynamic> notification = {
        'title': titleCtrl.text,
        'description': descriptionCtrl.text,
        'imageUrl': imageUrlCtrl.text,
      };
      final response = await service.addItem(endpointUrl: 'notification/send-notification', itemData: notification);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllNotifications();
          log('Notification sent successfully');
        }else{
          SnackBarHelper.showErrorSnackBar('Sending failed ${apiResponse.message}');
        }
        
      }else{
        SnackBarHelper.showErrorSnackBar('Sending failed ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred while sending notification $e');
      rethrow;
    }
  }


  deleteNotification(MyNotification notification) async{
    try {
      final response = await service.deleteItem(endpointUrl: 'notification/delete-notification', itemId: notification.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllNotifications();
          log('Notification deleted successfully');
        }else{
          SnackBarHelper.showErrorSnackBar('Deletion failed ${apiResponse.message}');
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Deletion failed ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred while deleting notification $e');
      rethrow;
    }
  }

 
  getNotificationInfo(MyNotification? notification) async {
    try {
      if(notification == null) {
        SnackBarHelper.showErrorSnackBar('Notification not found');
        return;
      }
      final response = await service.getItems(endpointUrl: 'notification/track-notification/${notification.notificationId}', );
      if(response.isOk) {
        ApiResponse<NotificationResult> apiResponse = ApiResponse<NotificationResult>.fromJson(response.body, 
        (json)=> NotificationResult.fromJson(json as Map<String, dynamic>),
        );
        if(apiResponse.success == true) {
        NotificationResult?  myNotificationResult = apiResponse.data;
        notificationResult = myNotificationResult;
        print(notificationResult?.platform);
          log('Notification info retrieved successfully');
          notifyListeners();
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar('Retrieving failed ${apiResponse.message}');
          return 'Retrieving failed ${apiResponse.message}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Retrieving failed ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred while retrieving notification info $e');
      rethrow;
    }
  }

  clearFields() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    imageUrlCtrl.clear();
  }

  updateUI() {
    notifyListeners();
  }
}
