import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymbook/features/auth/presentation/widgets/gymbook_card.dart';
import 'package:gymbook/features/customer_qrcode/presentation/cubits/entry_qrcode_cubit/entry_qrcode_cubit.dart';
import 'package:gymbook/features/customer_qrcode/presentation/widgets/brightness_hint_card.dart';
import 'package:gymbook/features/customer_qrcode/presentation/widgets/qrcode_scanner.dart';

class EntryQrcodeGymScreenBody extends StatelessWidget {
  const EntryQrcodeGymScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EntryQrcodeCubit, EntryQrcodeState>(
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.trim().isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
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
                      title: 'Your QR Code',
                      subtitle: 'Show this code at the entrance',
                      height: 250.h,
                      height1: 20.h,
                      showAppBar: true,
                      appbarText: 'Entry QR Code',
                    ),

                    Positioned(
                      top: 190.h,
                      left: 40.w,
                      right: 40.w,
                      child: QrcodeScanner(
                        userId: state.userId,
                        code: state.code,
                        qrData: state.qrPayload,
                        secondsRemaining: state.secondsRemaining,
                        isLoading: state.isLoading,
                        onRefreshTap: () {
                          context.read<EntryQrcodeCubit>().refreshNow();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 28.h, right: 56.w, left: 56.w),
                child: const BrightnessHintCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}
