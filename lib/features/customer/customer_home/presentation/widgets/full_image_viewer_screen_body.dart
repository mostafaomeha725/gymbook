import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/widgets/app_asset.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/appbar_icon_back.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/arrow_button.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_galary.dart';

class FullImageViewerScreenBody extends StatefulWidget {
  final List<String> images;
  final String initialImage;

  const FullImageViewerScreenBody({
    super.key,
    required this.images,
    required this.initialImage,
  });

  @override
  State<FullImageViewerScreenBody> createState() =>
      _FullImageViewerScreenBodyState();
}

class _FullImageViewerScreenBodyState extends State<FullImageViewerScreenBody>
    with SingleTickerProviderStateMixin {
  late String selectedImage;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.initialImage;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  void _nextImage() {
    int index = widget.images.indexOf(selectedImage);
    if (index < widget.images.length - 1) {
      setState(() => selectedImage = widget.images[index + 1]);
    }
  }

  void _prevImage() {
    int index = widget.images.indexOf(selectedImage);
    if (index > 0) {
      setState(() => selectedImage = widget.images[index - 1]);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 2. طبقة سوداء شفافة فقط بدون بلور
        Positioned.fill(
          child: GestureDetector(
            onTap: () => context.pop(), // يقفل الشاشة لو ضغطت على الخلفية
            child: Container(
              // يمكنك التحكم في درجة الشفافية من الـ 0.7 (كلما قل الرقم زادت الشفافية)
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),

        // 3. عرض الصورة
        Positioned.fill(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: AppAsset(
                key: ValueKey(selectedImage),
                assetName: selectedImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // الأسهم (أزرار التنقل)
        Positioned(
          left: 16.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: ArrowButton(
              icon: Icons.arrow_back_ios_new,
              onTap: _prevImage,
            ),
          ),
        ),
        Positioned(
          right: 16.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: ArrowButton(
              icon: Icons.arrow_forward_ios,
              onTap: _nextImage,
            ),
          ),
        ),

        // زر الرجوع العلوي
        Positioned(
          top: 50.h,
          left: 16.w,
          child: AppbarIconBack(
            isgalary: false,
            icon: Icons.arrow_back_ios_new,
            color: Colors.white,
            onTap: () => context.pop(),
          ),
        ),

        // شريط الصور المصغرة بالأسفل
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _offsetAnimation,
            child: GymGallery(
              allImages: widget.images,
              selectedImage: selectedImage,
              onImageTap: (img) => setState(() => selectedImage = img),
            ),
          ),
        ),
      ],
    );
  }
}
