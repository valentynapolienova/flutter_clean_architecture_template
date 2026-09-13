import 'package:clean_architecture_template/features/auth/presentation/cubits/session/session_cubit.dart';
import 'package:clean_architecture_template/shared/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.signOut,
      icon: const Icon(Icons.logout),
      onPressed: () => context.read<SessionCubit>().signOut(),
    );
  }
}
