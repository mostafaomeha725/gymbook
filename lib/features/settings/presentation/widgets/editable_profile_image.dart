import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/customer_home/presentation/widgets/image_source_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

class EditableProfileImage extends StatefulWidget {
  final String image;
  final double size;

  const EditableProfileImage({super.key, required this.image, this.size = 120});

  @override
  State<EditableProfileImage> createState() => _EditableProfileImageState();
}

class _EditableProfileImageState extends State<EditableProfileImage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 70);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          /// Profile Image
          Container(
            width: widget.size.w,
            height: widget.size.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.r,
                  spreadRadius: 2.r,
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _selectedImage != null
                    ? FileImage(_selectedImage!) as ImageProvider
                    : AssetImage(widget.image),
              ),
            ),
          ),

          /// Camera Button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                ImageSourceBottomSheet.show(
                  context,
                  onCameraTap: () => _pickImage(ImageSource.camera),
                  onGalleryTap: () => _pickImage(ImageSource.gallery),
                );
              },
              child: Container(
                height: 36.h,
                width: 36.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF134FA2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
