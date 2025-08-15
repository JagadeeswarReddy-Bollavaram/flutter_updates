import 'package:flutter/material.dart';

class AppDropDown extends StatefulWidget {
  List<String> items;
  String? label;
  String? selectedItem;
  FormFieldValidator<String>? validator;
  Function(String? item)? onChanged;
  AppDropDown({
    super.key,
    required this.items,
    this.label,
    this.validator,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  State<AppDropDown> createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
        ],
        DropdownButtonFormField<String>(
          value: widget.selectedItem,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey),
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
          ),
          validator: widget.validator,
          items: widget.items
              .map((element) => DropdownMenuItem(
                    value: element,
                    child: Text(element),
                  ))
              .toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
