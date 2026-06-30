class EntryQrcodeState {
  final int? userId;
  final String code;
  final String qrPayload;
  final int secondsRemaining;
  final bool isLoading;
  final String? errorMessage;

  const EntryQrcodeState({
    this.userId,
    required this.code,
    required this.qrPayload,
    required this.secondsRemaining,
    this.isLoading = false,
    this.errorMessage,
  });

  factory EntryQrcodeState.initial() => const EntryQrcodeState(
    code: '------',
    qrPayload: '',
    secondsRemaining: 30,
    isLoading: true,
  );

  EntryQrcodeState copyWith({
    int? userId,
    String? code,
    String? qrPayload,
    int? secondsRemaining,
    bool? isLoading,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return EntryQrcodeState(
      userId: userId ?? this.userId,
      code: code ?? this.code,
      qrPayload: qrPayload ?? this.qrPayload,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
