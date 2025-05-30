import 'package:flutter/material.dart';
import '../utility/responsive.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? initialValue;
  final List<T> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String hintText;
  final String Function(T) displayItem;
  final TextStyle? textStyle;

  const CustomDropdown({
    Key? key,
    this.initialValue,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hintText = 'Select an option',
    required this.displayItem,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropdownButtonFormField<T>(
            decoration: InputDecoration(
              labelText: hintText,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            value: initialValue,
            items: items.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Container(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth - 32), // Account for padding
                  child: Text(
                    displayItem(value),
                    style: textStyle ??
                        TextStyle(
                          fontSize: Responsive.isMobile(context) ? 12 : 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            isExpanded: true, // Ensures the dropdown button fills its parent width
            menuMaxHeight: 300, // Limits dropdown menu height
            dropdownColor: Theme.of(context).scaffoldBackgroundColor, // Consistent background
          );
        },
      ),
    );
  }
}