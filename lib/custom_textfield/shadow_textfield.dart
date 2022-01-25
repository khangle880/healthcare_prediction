import 'dart:async';

import 'package:flutter/material.dart';

import '../colors.dart';
import 'configs/decoration_config.dart';
import 'configs/textfield_config.dart';
import 'custom_textfield.dart';

class ShadowTextField extends StatefulWidget {
  const ShadowTextField(
      {Key? key,
      required this.textFieldType,
      this.textFieldKey,
      this.textFieldConfig = const TextFieldConfig(),
      this.decorationConfig = const TextFieldDecorationConfig(),
      this.validator,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.onChanged,
      this.showCursor,
      this.onTap,
      this.borderRadius,
      this.isShadowFocus = true})
      : super(key: key);

  final bool? showCursor;
  final TextFieldType textFieldType;
  final GlobalKey<EditableTextState>? textFieldKey;
  final TextFieldConfig textFieldConfig;
  final TextFieldDecorationConfig decorationConfig;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final double? borderRadius;
  final bool isShadowFocus;

  @override
  _ShadowTextFieldState createState() => _ShadowTextFieldState();
}

class _ShadowTextFieldState extends State<ShadowTextField> {
  late final FocusNode _focusNode;
  StreamController<String?> errorStream = StreamController<String?>();
  bool _isUsedToChange = false;
  late TextEditingController controller;

  @override
  void initState() {
    _focusNode = widget.textFieldConfig.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    controller = widget.textFieldConfig.controller ?? TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    errorStream.close();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BoxShadow> lightThemeAndNotErrorFocused = [
      const BoxShadow(
        color: AppColors.tfLightNotError,
        spreadRadius: 4,
      ),
      BoxShadow(
        color: AppColors.greyWarning.withOpacity(0.2),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];
    List<BoxShadow> lightThemeAndErrorFocused = [
      const BoxShadow(
        color: AppColors.errorBG,
        spreadRadius: 4,
      ),
      BoxShadow(
        color: AppColors.greyWarning.withOpacity(0.2),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];

    return StreamBuilder<String?>(
        stream: errorStream.stream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 4),
                    boxShadow: widget.isShadowFocus
                        ? _focusNode.hasFocus
                            ? snapshot.hasData
                                ? lightThemeAndErrorFocused
                                : lightThemeAndNotErrorFocused
                            : null
                        : null),
                alignment: Alignment.center,
                child: CustomTextField(
                  textFieldType: widget.textFieldType,
                  textFieldConfig: TextFieldConfig(
                      readOnly: widget.textFieldConfig.readOnly,
                      focusNode: widget.textFieldConfig.focusNode ?? _focusNode,
                      controller: controller,
                      maxLines: widget.textFieldConfig.maxLines,
                      style: widget.textFieldConfig.style ??
                          Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(fontWeight: FontWeight.w400)),
                  validator: _isUsedToChange
                      ? (value) {
                          String? error = widget.validator?.call(value);
                          errorStream.add(error);
                          return error;
                        }
                      : null,
                  onEditingComplete: widget.onEditingComplete,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  onSaved: widget.onSaved,
                  onChanged: (value) {
                    if (!_isUsedToChange) {
                      _isUsedToChange = true;
                      setState(() {});
                    }
                    widget.onChanged?.call(value);
                  },
                  showCursor: widget.showCursor,
                  decorationConfig: TextFieldDecorationConfig(
                      labelText: widget.decorationConfig.labelText,
                      labelStyle: widget.decorationConfig.labelStyle,
                      suffixBtnSplashColor: AppColors.trans24,
                      suffixBtnHighlightColor: AppColors.trans24,
                      isCollapsed: widget.decorationConfig.isCollapsed ?? true,
                      contentPadding: widget.decorationConfig.contentPadding ??
                          const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                      hintText: widget.decorationConfig.hintText,
                      hintStyle: widget.decorationConfig.hintStyle ??
                          Theme.of(context).textTheme.caption?.copyWith(
                              color: Theme.of(context).unselectedWidgetColor,
                              fontWeight: FontWeight.w400),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 4.0)),
                        borderSide: const BorderSide(
                            color: (AppColors.borderColor), width: 1),
                      ),
                      focusedErrorBorder:
                          _getTextFieldBorder(isErrorType: true),
                      errorBorder: _getTextFieldBorder(isErrorType: true),
                      enabled: true,
                      enabledBorder: _getTextFieldBorder(isErrorType: false),
                      fillColor: AppColors.white,
                      filled: true,
                      errorStyle:
                          const TextStyle(height: 0, color: Colors.transparent),
                      suffixIcon: widget.decorationConfig.suffixIcon,
                      suffixIconConstraints:
                          widget.decorationConfig.suffixIconConstraints,
                      prefixIcon: widget.decorationConfig.prefixIcon,
                      prefixIconConstraints:
                          widget.decorationConfig.prefixIconConstraints),
                ),
              ),
              if (snapshot.hasData) ...[
                const SizedBox(height: 6),
                Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.redErrorBase,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ],
          );
        });
  }

  OutlineInputBorder _getTextFieldBorder({bool isErrorType = false}) {
    var defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(widget.borderRadius ?? 4.0),
      ),
      borderSide: BorderSide(
          color: isErrorType
              ? Theme.of(context).colorScheme.onError
              : AppColors.borderColor,
          width: 1),
    );

    return defaultBorder;
  }
}
