import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/features/Home/screens/NavigationHome.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/features/auth/screens/Start_Page.dart';
import 'package:pets/firebase_options.dart';
import 'package:pets/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  void getDetails(data) async {
    ref.read(authControllerProvider.notifier).userData = await ref
        .read(authControllerProvider.notifier)
        .getDetails(data.uid)
        .first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryBgcolor),
          useMaterial3: true,
        ),
        home: ref.watch(authStateProvider).when(
            data: (data) {
              if (data != null) {
                getDetails(data);
                if (ref.watch(authControllerProvider.notifier).userData !=
                        null &&
                    ref.watch(authControllerProvider.notifier).userData?.role ==
                        'user') {
                  return const NavigatorHome();
                }
              }
              return const StartPage();
            },
            error: (e, st) {
              return Center(
                child: Text(e.toString()),
              );
            },
            loading: () => const LoadingScreen()));
  }
}
