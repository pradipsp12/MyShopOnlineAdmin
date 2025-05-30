import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../utility/constants.dart';
import '../../../utility/responsive.dart';

class NotificationCard extends StatelessWidget {
  final String text;
  final Color color;
  final int number;
  final double percentage;

  const NotificationCard({
    super.key,
    required this.text,
    required this.color,
    required this.number,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
      padding: EdgeInsets.all(isMobile ? defaultPadding * 0.5 : defaultPadding * 0.75),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? defaultPadding * 0.4 : defaultPadding * 0.6),
                height: isMobile ? 28 : 36,
                width: isMobile ? 28 : 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: SvgPicture.asset(
                  'assets/icons/notification.svg',
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ],
          ),
          Gap(isMobile ? 4 : 6),
          Text(
            "$number",
            style: TextStyle(fontSize: isMobile ? 12 : 14, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(isMobile ? 4 : 6),
          ProgressLine(
            color: color,
            percentage: percentage,
            isMobile: isMobile,
          ),
          Gap(isMobile ? 4 : 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: isMobile ? 10 : 12,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color = primaryColor,
    required this.percentage,
    this.isMobile = false,
  });

  final Color? color;
  final double percentage;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: isMobile ? 3 : 4,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: isMobile ? 3 : 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}