import 'dart:async';

abstract class BusinessCase<T> {
  const BusinessCase();

  FutureOr<T> run();

  FutureOr<Res?> guardFetch<Res>({
    required FutureOr<Res> Function() action,
    required ErrorCallback? error,
  }) async {
    try {
      return await action();
    } on Exception catch (e, stackTrace) {
      error?.call(e, stackTrace);
      return null;
    }
  }
}

/// Получение данных
typedef FetchCallback<Arg, Res> = FutureOr<Res> Function(Arg arg);

/// Уведомление об ошибке
typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);

/// Сайд эффект
typedef SideEffectCallback<T> = FutureOr<void> Function(T value);

// class ScanProductBusinessCase extends BusinessCase {
//   final FetchCallback<String, String> fetchUserName;
//   final SideEffectCallback<int> infoUserNameLength;
//   final ErrorCallback? errorUserNameInvalid;
//
//   const ScanProductBusinessCase({
//     required this.fetchUserName,
//     required this.infoUserNameLength,
//     this.errorUserNameInvalid,
//   });
//
//   @override
//   FutureOr<void> run() async {
//     final userName = await guardFetch(
//       action: () => fetchUserName(''),
//       error: errorUserNameInvalid,
//     );
//
//     if (userName != null) {
//       infoUserNameLength(userName.length);
//     }
//   }
// }
//
// void main() {
//   ScanProductBusinessCase(
//     fetchUserName: (id) async {
//       if (id.isEmpty) {
//         throw Exception('id cannot be empty');
//       }
//       return await Future.delayed(const Duration(seconds: 6), () => 'abcd');
//     },
//     infoUserNameLength: (value) => print('INFO - $value'),
//     errorUserNameInvalid: (e, _) => print('ERROR - $e'),
//   ).run();
// }
