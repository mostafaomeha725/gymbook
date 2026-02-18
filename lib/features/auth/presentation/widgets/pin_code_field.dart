import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeField extends StatefulWidget {
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  const PinCodeField({super.key, this.onChanged, this.onCompleted});

  @override
  State<PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<PinCodeField> {
  final TextEditingController _controller = TextEditingController();
  late final StreamController<ErrorAnimationType> _errorController;

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>.broadcast();
  }

  @override
  void dispose() {
    _controller.dispose();
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: SizedBox(
          width: 340.w,
          child: PinCodeTextField(
            autoDisposeControllers: false,
            appContext: context,
            controller: _controller,
            length: 6,
            autoFocus: true,
            animationType: AnimationType.fade,
            hintCharacter: '-',
            enableActiveFill: true,
            showCursor: false,
            cursorColor: Colors.transparent,
            keyboardType: TextInputType.number,
            textStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12.r),
              fieldHeight: 50.h,
              fieldWidth: 45.w,
              borderWidth: 1.5,
              inactiveColor: Colors.grey[200]!,
              selectedColor: const Color(0xFF0EA5E9),
              activeColor: Colors.grey[200]!,
              inactiveFillColor: Colors.grey[200]!,
              selectedFillColor: Colors.grey[200]!,
              activeFillColor: Colors.grey[200]!,
            ),
            backgroundColor: const Color(0xFFF9F9FB),
            onChanged: (value) {
              if (!mounted) return;
              widget.onChanged?.call(value);
            },
            onCompleted: (value) {
              if (!mounted) return;
              widget.onCompleted?.call(value);
            },
          ),
        ),
      ),
    );
  }
}
