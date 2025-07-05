import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Buttoms/CloseIconButton.dart';
import 'package:tadrib_hub/presentation/Screens/Success_Dialog.dart';
import 'package:tadrib_hub/utils/app_router.dart';
import 'package:tadrib_hub/utils/color_manager.dart';
import 'package:tadrib_hub/utils/strings_manager.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final String phoneNumber;
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  VerifyPhoneScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: AppStrings.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            AppStrings.verifyPhone(context),
            style: TextStyle(color: AppColors.textBlack),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: CloseIconButton(),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.02),
              Text(
                "${AppStrings.codeSent(context)} $phoneNumber",
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: size.width * 0.045,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.height * 0.02,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    showSuccessDialog(context, AppRoutes.newPassword);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.height * 0.02),
                    ),
                  ),
                  child: Text(
                    AppStrings.verifyPhone(context),
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
