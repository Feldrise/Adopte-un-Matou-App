import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmTextInput extends StatefulWidget {
  const AmTextInput({
    Key? key,
    this.formKey,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    required this.controller,
    required this.validator,
    required this.labelText,
    this.suffixIcon,
    this.hintText,
    this.maxLines = 1,
    this.onSaved,
    this.onChanged,
    this.readOnly = false,
  }) : super(key: key);

  final Key? formKey;

  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String)? validator;
  final Function(String)? onSaved;
  final Function(String?)? onChanged;

  final IconData? suffixIcon;
  final String? hintText;
  final String labelText;

  final TextInputType inputType;
  final int maxLines;

  final bool readOnly;

  @override 
  _AmTextInput createState() => _AmTextInput();
}

class _AmTextInput extends State<AmTextInput> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AmTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.labelText, style: GoogleFonts.raleway(fontSize: 12),),
        const SizedBox(height: 10.0,),
        TextFormField(
          readOnly: widget.readOnly,
          enabled: !widget.readOnly,
          key: widget.formKey,
          obscureText: _obscureText,
          controller: widget.controller,
          keyboardType: widget.inputType,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            fillColor: widget.readOnly ? Theme.of(context).disabledColor : Theme.of(context).cardColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor,),
              borderRadius: BorderRadius.circular(6.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor,),
              borderRadius: BorderRadius.circular(6.0),
            ),
            suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : !widget.obscureText ? null : InkWell(
              onTap: _textVisibilityUpdated,
              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            )
          ),
          validator: widget.validator == null ? null : (value) => widget.validator!(value ?? ""),
          onSaved: widget.onSaved != null ? (value) => widget.onSaved!(value ?? "") : null,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          }
        ),
      ],
    );
  }

  void _textVisibilityUpdated() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}