part of 'ktp_scan_cubit.dart';

sealed class KtpScanState {}

final class KtpScanInitial extends KtpScanState {}

final class KtpScanLoading extends KtpScanState {}

final class KtpScanLoaded extends KtpScanState {
  final KtmModel item;

  KtpScanLoaded(this.item);
}

final class KtpScanError extends KtpScanState {
  final String message;

  KtpScanError(this.message);
}
