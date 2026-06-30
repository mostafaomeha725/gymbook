import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:gymbook/core/cache/preferences_storage.dart';
import 'package:gymbook/features/customer/customer_qrcode/presentation/cubits/entry_qrcode_cubit/entry_qrcode_state.dart';

class EntryQrcodeCubit extends Cubit<EntryQrcodeState> {
  EntryQrcodeCubit({required this.preferencesStorage})
    : super(EntryQrcodeState.initial());

  final PreferencesStorage preferencesStorage;

  static const int _periodSeconds = 30;
  Timer? _timer;
  String? _secretKey;
  int? _customerId;
  int? _forcedCounter;
  int? _forcedStartedAtSeconds;

  Future<void> initialize() async {
    _secretKey = preferencesStorage.getUserSecretKey();
    _customerId = preferencesStorage.getUserId();

    if (_secretKey == null || _secretKey!.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Secret key is not available. Please login again.',
        ),
      );
      return;
    }

    _emitCurrentCode();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _emitCurrentCode();
    });
  }

  void refreshNow() {
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final nowCounter = nowSeconds ~/ _periodSeconds;

    final baseCounter =
        (_forcedCounter != null && _forcedStartedAtSeconds != null)
        ? (_forcedCounter! > nowCounter ? _forcedCounter! : nowCounter)
        : nowCounter;

    _forcedStartedAtSeconds = nowSeconds;
    _forcedCounter = baseCounter + 1;
    _emitCurrentCode(clearMessages: true);
  }

  void _emitCurrentCode({bool clearMessages = false}) {
    final secret = _secretKey;
    if (secret == null || secret.trim().isEmpty) return;

    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final nowCounter = nowSeconds ~/ _periodSeconds;

    int activeCounter = nowCounter;
    int secondsRemaining = _periodSeconds - (nowSeconds % _periodSeconds);

    if (_forcedCounter != null && _forcedStartedAtSeconds != null) {
      final elapsed = nowSeconds - _forcedStartedAtSeconds!;
      if (elapsed >= _periodSeconds || nowCounter >= _forcedCounter!) {
        _forcedCounter = null;
        _forcedStartedAtSeconds = null;
      } else {
        activeCounter = _forcedCounter!;
        secondsRemaining = _periodSeconds - elapsed;
      }
    }

    final code = _generateTotpCode(secret, counter: activeCounter);
    final qrPayload = _buildQrPayload(code);

    emit(
      state.copyWith(
        userId: _customerId,
        code: code,
        qrPayload: qrPayload,
        secondsRemaining: secondsRemaining,
        isLoading: false,
        clearMessages: clearMessages,
      ),
    );
  }

  String _buildQrPayload(String code) {
    final customerId = _customerId;
    if (customerId == null || customerId <= 0) return code;
    return jsonEncode({'customerId': customerId, 'code': code});
  }

  String _generateTotpCode(String secret, {required int counter}) {
    final key = _decodeBase32(secret);

    final counterBytes = ByteData(8)..setUint64(0, counter, Endian.big);
    final hmac = Hmac(sha1, key);
    final hash = hmac.convert(counterBytes.buffer.asUint8List()).bytes;

    final offset = hash.last & 0x0f;
    final binary =
        ((hash[offset] & 0x7f) << 24) |
        ((hash[offset + 1] & 0xff) << 16) |
        ((hash[offset + 2] & 0xff) << 8) |
        (hash[offset + 3] & 0xff);

    final otp = binary % 1000000;
    return otp.toString().padLeft(6, '0');
  }

  List<int> _decodeBase32(String input) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final cleaned = input
        .toUpperCase()
        .replaceAll('=', '')
        .replaceAll(' ', '')
        .replaceAll('-', '');

    final buffer = StringBuffer();
    for (final char in cleaned.split('')) {
      final index = alphabet.indexOf(char);
      if (index == -1) continue;
      buffer.write(index.toRadixString(2).padLeft(5, '0'));
    }

    final bits = buffer.toString();
    final bytes = <int>[];
    for (var i = 0; i + 8 <= bits.length; i += 8) {
      bytes.add(int.parse(bits.substring(i, i + 8), radix: 2));
    }
    return bytes;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
