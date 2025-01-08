import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final name = TextEditingController();
  final breed = TextEditingController();
  final category = TextEditingController();

  @override
  void initState() {
    final user = ref.read(authControllerProvider.notifier).userData;
    name.text = user?.name ?? "";
    category.text = user?.email ?? "";
    breed.text = user?.uid ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider.notifier).userData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryLightColor,
        centerTitle: true,
        title: ResponsiveText(
          text: user?.name ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          CustomTextFieldUpload(
              textController: name, icon: Icons.account_circle_rounded),
          CustomTextFieldUpload(textController: category, icon: Icons.email),
          CustomTextFieldUpload(textController: breed, icon: Icons.verified),
        ],
      ),
    );
  }
}
