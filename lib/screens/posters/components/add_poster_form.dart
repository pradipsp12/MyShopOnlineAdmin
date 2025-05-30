import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../models/poster.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../utility/responsive.dart';
import '../provider/poster_provider.dart';
import '../../../widgets/category_image_card.dart';
import '../../../widgets/custom_text_field.dart';

class PosterSubmitForm extends StatelessWidget {
  final Poster? poster;

  const PosterSubmitForm({super.key, this.poster});

  @override
  Widget build(BuildContext context) {
    context.posterProvider.setDataForUpdatePoster(poster);
    var size = MediaQuery.of(context).size;

    // Adjust width based on screen size
    double formWidth = Responsive.isMobile(context)
        ? size.width * 0.9 // Almost full width on mobile
        : Responsive.isTablet(context)
            ? size.width * 0.5 // Medium width on tablet
            : size.width * 0.4; // Narrower on desktop

    return SingleChildScrollView(
      child: Form(
        key: context.posterProvider.addPosterFormKey,
        child: Container(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
          width: formWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              Consumer<PosterProvider>(
                builder: (context, posterProvider, child) {
                  return CategoryImageCard(
                    labelText: "Poster",
                    imageFile: posterProvider.selectedImage,
                    imageUrlForUpdateImage: poster?.imageUrl,
                    onTap: () {
                      posterProvider.pickImage();
                    },
                 
                  );
                },
              ),
              Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
              CustomTextField(
                controller: context.posterProvider.posterNameCtrl,
                labelText: 'Poster Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a poster name';
                  }
                  return null;
                },
              ),
              Gap(Responsive.isMobile(context) ? defaultPadding : defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: secondaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
                      ),
                    ),
                  ),
                  Gap(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
                        ),
                      ),
                      onPressed: () {
                        if (context.posterProvider.addPosterFormKey.currentState!.validate()) {
                          context.posterProvider.addPosterFormKey.currentState!.save();
                          context.posterProvider.submitPoster();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
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

void showAddPosterForm(BuildContext context, Poster? poster) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Add Poster'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: PosterSubmitForm(poster: poster),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
      );
    },
  );
}

void deletePosterDialoge(BuildContext context, Poster poster) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            'Delete Poster?'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: Responsive.isMobile(context) ? 16 : 20,
            ),
          ),
        ),
        content: Text(
          'Do you want to delete this poster?',
          style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
        ),
        contentPadding: EdgeInsets.all(Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? defaultPadding * 0.5 : defaultPadding,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.posterProvider.deletePoster(poster);
            },
            child: Text(
              'Delete',
              style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 14),
            ),
          ),
        ],
      );
    },
  );
}