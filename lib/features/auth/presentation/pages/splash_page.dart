import 'package:clean_architecture_template/shared/widgets/page_loader.dart';
import 'package:flutter/material.dart';

/// Shown while the stored session is being checked.
class SplashPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PageLoader());
  }
}
