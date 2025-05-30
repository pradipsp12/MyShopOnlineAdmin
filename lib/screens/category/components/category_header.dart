import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';

class CategoryHeader extends StatelessWidget {
  final bool isMobile;

  const CategoryHeader({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18, // Smaller font for mobile
                    ),
              ),
              SizedBox(height: defaultPadding * 0.5),
              SearchField(
                onChange: (val) {
                  context.dataProvider.filterCategories(val);
                },
              ),
              SizedBox(height: defaultPadding * 0.5),
              ProfileCard(isMobile: true),
            ],
          )
        : Row(
            children: [
              Text(
                "Category",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Spacer(flex: 2),
              Expanded(child: SearchField(
                onChange: (val) {
                  context.dataProvider.filterCategories(val);
                },
              )),
              ProfileCard(),
            ],
          );
  }
}

class ProfileCard extends StatelessWidget {
  final bool isMobile;

  const ProfileCard({Key? key, this.isMobile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isMobile ? 0 : defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? defaultPadding * 0.5 : defaultPadding,
        vertical: isMobile ? defaultPadding * 0.25 : defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 38,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text(context.authServiceProvider.getLoginUsr()?.name ?? "Admin"),
          ),
          PopupMenuButton<String>(
          icon: const Icon(Icons.keyboard_arrow_down),
          offset: const Offset(0, 40),
          onSelected: (String value) {
            if (value == 'logout') {
              context.authServiceProvider.logout(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final Function(String) onChange;

  const SearchField({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}