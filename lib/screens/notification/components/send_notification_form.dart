import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../models/my_notification.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../utility/responsive.dart';
import '../../../widgets/custom_text_field.dart';

class SendNotificationForm extends StatelessWidget {
  const SendNotificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final formWidth = isMobile
        ? MediaQuery.of(context).size.width * 0.9
        : Responsive.isTablet(context)
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.4;

    return SingleChildScrollView(
      child: Form(
        key: context.notificationProvider.sendNotificationFormKey,
        child: Container(
          padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding),
          width: formWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(isMobile ? defaultPadding * 0.5 : defaultPadding),
              CustomTextField(
                controller: context.notificationProvider.titleCtrl,
                labelText: 'Notification Title',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              Gap(isMobile ? defaultPadding * 0.5 : defaultPadding),
              CustomTextField(
                controller: context.notificationProvider.descriptionCtrl,
                labelText: 'Notification Description',
                lineNumber: 3,
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Gap(isMobile ? defaultPadding * 0.5 : defaultPadding),
              CustomTextField(
                controller: context.notificationProvider.imageUrlCtrl,
                labelText: 'Image URL (Optional)',
                onSave: (val) {},
              ),
              Gap(isMobile ? defaultPadding : defaultPadding * 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: secondaryColor,
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? defaultPadding * 0.5 : defaultPadding * 0.75,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                      ),
                    ),
                  ),
                  Gap(isMobile ? defaultPadding * 0.5 : defaultPadding),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? defaultPadding * 0.5 : defaultPadding * 0.75,
                        ),
                      ),
                      onPressed: () {
                        if (context.notificationProvider.sendNotificationFormKey.currentState!.validate()) {
                          context.notificationProvider.sendNotificationFormKey.currentState!.save();
                          context.notificationProvider.sendNotification();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void sendNotificationForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final isMobile = Responsive.isMobile(context);
      return AlertDialog(
        backgroundColor: bgColor,
        title: Text(
          'Send Notification',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryColor,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        content: SendNotificationForm(),
        contentPadding: EdgeInsets.all(isMobile ? 12 : 16),
      );
    },
  );
}

void deleteNotificationDialog(BuildContext context, MyNotification? notification) {
  final isMobile = Responsive.isMobile(context);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Text(
          'Delete Notification?',
          style: TextStyle(
            color: primaryColor,
            fontSize: isMobile ? 16 : 18,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Are you sure you want to delete this notification?',
          style: TextStyle(fontSize: isMobile ? 12 : 14),
        ),
        contentPadding: EdgeInsets.all(isMobile ? 12 : 16),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 10,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (notification != null) {
                context.notificationProvider.deleteNotification(notification);
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
        ],
      );
    },
  );
}