import 'package:flutter/material.dart';
import 'package:tadrib_hub/utils/assets_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';


class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(AppStrings.orLoginWith(context)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(ImageAssets.googleIcon),
              iconSize: 40,
              onPressed: () {},
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Image.asset(ImageAssets.facebookIcon),
              iconSize: 40,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
