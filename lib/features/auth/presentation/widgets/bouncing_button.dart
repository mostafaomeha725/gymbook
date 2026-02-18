import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/app_svg.dart';

class BouncingButton extends StatefulWidget {
  const BouncingButton({
    super.key,
    required this.text,
    this.onTap,
    required this.assetName,
  });

  final String text;
  final void Function()? onTap;
  final String assetName;

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.95);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          height: 54.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffECECEC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFDADADA)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: SizedBox(
              width: 240.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28.w,
                    height: 28.h,
                    child: Center(
                      child: AppSVG(
                        assetName: widget.assetName,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Flexible(
                    child: Text(
                      widget.text,
                      style: font16w500.copyWith(
                        color: const Color(0xff8A8A8A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
