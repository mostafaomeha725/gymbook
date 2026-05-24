import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/route_paths.dart';
import 'package:gymbook/core/widgets/app_asset.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/appbar_icon_back.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/arrow_button.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/full_image_viewer_args.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/gym_galary.dart';

class ImageGymDetails extends StatefulWidget {
  final List<String> images; // استقبال القائمة من الخارج

  const ImageGymDetails({super.key, required this.images});

  @override
  State<ImageGymDetails> createState() => _ImageGymDetailsState();
}

class _ImageGymDetailsState extends State<ImageGymDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final double imageHeight = 360.h;
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    _initImage();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  void _initImage() {
    selectedImage = widget.images.isNotEmpty ? widget.images[0] : '';
  }

  // التقليب للصورة التالية
  void _nextImage() {
    int index = widget.images.indexOf(selectedImage);
    if (index < widget.images.length - 1) {
      setState(() => selectedImage = widget.images[index + 1]);
    }
  }

  // التقليب للصورة السابقة
  void _prevImage() {
    int index = widget.images.indexOf(selectedImage);
    if (index > 0) {
      setState(() => selectedImage = widget.images[index - 1]);
    }
  }

  // فتح عارض الصور الكامل
  void _openFullScreen() {
    context.push(
      Routes.fullImageViewerScreen,
      extra: FullImageViewerArgs(
        images: widget.images,
        initialImage: selectedImage,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ImageGymDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.images != oldWidget.images) {
      setState(() => _initImage());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: imageHeight,
      child: Stack(
        children: [
          // 1. الصورة الكبيرة الأساسية (قابلة للضغط)
          Positioned.fill(
            child: GestureDetector(
              onTap: _openFullScreen, // عند الضغط يفتح العرض الكامل
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: AppAsset(
                  key: ValueKey(selectedImage),
                  assetName: selectedImage,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. أسهم التنقل يمين ويسار فوق الصورة
          Positioned(
            left: 10.w,
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
            right: 10.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: ArrowButton(
                icon: Icons.arrow_forward_ios,
                onTap: _nextImage,
              ),
            ),
          ),

          // 3. معرض الصور السفلي (الصور المصغرة)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _offsetAnimation,
              child: GymGallery(
                allImages: widget.images,
                selectedImage: selectedImage,
                onImageTap: (img) => setState(() => selectedImage = img),
                isCompact: true,
              ),
            ),
          ),

          // 4. زر الرجوع
          Positioned(
            top: 50.h,
            left: 16.w,
            child: AppbarIconBack(
              icon: Icons.arrow_back_ios_new,
              color: Colors.white,
              onTap: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
