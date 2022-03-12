import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/controller/authentication/authentication_provider.dart';
import 'package:listify/services/network_status.dart';
import 'package:listify/views/screens/home_screen.dart';
import 'package:listify/views/screens/k_base_screen.dart';
import 'package:listify/views/screens/startup/welcome_screen.dart';
import 'package:listify/views/screens/error_screen.dart';

class AuthenticationWrapper extends KBaseScreen {
  @override
  KBaseState<AuthenticationWrapper> createState() =>
      _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends KBaseState<AuthenticationWrapper> {
  @override
  bool scrollable() => false;

  @override
  bool defaultPadding() => false;

  @override
  Widget body() {
    final asyncUser = ref.watch(authStateChangesProvider);
    final asyncNetworkStatus = ref.watch(networkStatusProvider);

    return asyncNetworkStatus.when(
      data: (result) {
        return asyncUser.when(
          data: (user) {
            return result == NetworkStatus.ONLINE
                ? user != null
                    ? HomeScreen()
                    : WelcomeScreen()
                : ErrorScreen();
          },
          loading: () => WelcomeScreen(),
          error: (e, stackTrace) => ErrorScreen(),
        );
      },

      /// TODO: Network status loading screen should be WelcomeScreen?
      loading: () => WelcomeScreen(),
      error: (e, stackTrace) => ErrorScreen(),
    );
  }
}
