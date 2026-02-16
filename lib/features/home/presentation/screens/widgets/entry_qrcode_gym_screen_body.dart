import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymbook/features/auth/presentation/screens/widgets/gymbook_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/brightness_hint_card.dart';
import 'package:gymbook/features/home/presentation/screens/widgets/qrcode_scanner.dart';

class EntryQrcodeGymScreenBody extends StatelessWidget {
  const EntryQrcodeGymScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GymbookCard(
                  title: 'PowerHouse Gym',
                  subtitle: 'Show this code at the entrance',
                  height: 250.h,
                  height1: 20.h,
                  showAppBar: true,
                  appbarText: 'Entry QR Code',
                ),

                Positioned(
                  top: 190.h,
                  left: 56.w,
                  right: 56.w,
                  child: const QrcodeScanner(),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 32.h, right: 56.w, left: 56.w),
            child: const BrightnessHintCard(),
          ),
        ],
      ),
    );
  }
}
