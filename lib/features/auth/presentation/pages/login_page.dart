import 'dart:async';

import 'package:clean_architecture_template/core/extensions/build_context_x.dart';
import 'package:clean_architecture_template/core/extensions/failure_message.dart';
import 'package:clean_architecture_template/core/theme/spacing.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const new({super.key});

  // DummyJSON's public demo account. Delete it together with the example API.
  static const demoUsername = 'emilys';
  static const demoPassword = 'emilyspass';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    unawaited(
      context.read<LoginCubit>().signIn(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _fillDemoAccount() {
    _usernameController.text = LoginPage.demoUsername;
    _passwordController.text = LoginPage.demoPassword;
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty)
      ? context.l10n.fieldRequired
      : null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const .all(Spacing.l),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final isBusy = state is LoginInProgress;
                  return Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          Text(
                            l10n.loginTitle,
                            style: context.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: Spacing.s),
                          Text(
                            l10n.loginSubtitle,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.subtleText,
                            ),
                          ),
                          const SizedBox(height: Spacing.l),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: l10n.usernameLabel,
                            ),
                            textInputAction: .next,
                            autofillHints: const [AutofillHints.username],
                            validator: _required,
                          ),
                          const SizedBox(height: Spacing.m),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: l10n.passwordLabel,
                            ),
                            obscureText: true,
                            textInputAction: .done,
                            autofillHints: const [AutofillHints.password],
                            validator: _required,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          if (state case LoginFailed(:final failure)) ...[
                            const SizedBox(height: Spacing.m),
                            Text(
                              failure.toMessage(l10n),
                              style: TextStyle(
                                color: context.colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: Spacing.l),
                          FilledButton(
                            onPressed: isBusy ? null : _submit,
                            child: isBusy
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.signInButton),
                          ),
                          const SizedBox(height: Spacing.s),
                          TextButton(
                            onPressed: isBusy ? null : _fillDemoAccount,
                            child: Text(l10n.useDemoAccount),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
