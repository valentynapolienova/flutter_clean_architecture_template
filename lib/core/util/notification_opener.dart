import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void showNotification(
  Widget notification, {
  Duration duration = const Duration(seconds: 3),
}) {
  BotToast.showCustomNotification(
    useSafeArea: true,
    toastBuilder: (_) => notification,
    duration: duration,
  );
}

void closeNotification() {
  BotToast.cleanAll();
}
