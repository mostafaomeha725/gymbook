import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/utils/easy_loading.dart';

import 'package:gymbook/features/auth/presentation/widgets/gymbook_card.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/cubits/entry_qrcode_cubit/entry_qrcode_cubit.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/cubits/entry_qrcode_cubit/entry_qrcode_state.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/widgets/brightness_hint_card.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/widgets/qrcode_scanner.dart';

class EntryQrcodeGymScreenBody extends StatelessWidget {
  const EntryQrcodeGymScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EntryQrcodeCubit, EntryQrcodeState>(
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.trim().isNotEmpty) {
          showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GymbookCard(
                    title: 'Your QR Code',
                    subtitle: 'Show this code at the entrance',
                    height: 250.h,
                    height1: 20.h,
                    showAppBar: true,
                    appbarText: 'Entry QR Code',
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 190.h,
                      left: 40.w,
                      right: 40.w,
                    ),
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
              SizedBox(height: 32.h),

              Padding(
                padding: EdgeInsets.only(
                  bottom: 100.h,
                  right: 56.w,
                  left: 56.w,
                ),
                child: const BrightnessHintCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}
