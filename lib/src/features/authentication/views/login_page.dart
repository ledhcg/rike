import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rikedu/src/features/authentication/controllers/auth_controller.dart';
import 'package:rikedu/src/utils/constants/size_constants.dart';
import 'package:rikedu/src/utils/widgets/custom_text_field.dart';
import 'package:rikedu/src/utils/widgets/loading_widget.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoading
            ? const LoadingWidget()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(SizesConst.P0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          onChanged: (value) => controller.setEmail(value),
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: 'Email'.tr,
                          ),
                          validator: controller.emailValidator,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          onChanged: (value) => controller.setPassword(value),
                          controller: controller.passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: controller.toggleObscure,
                            ),
                            labelText: 'Password'.tr,
                          ),
                          obscureText: controller.isObscure,
                          validator: controller.passwordValidator,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: controller.login,
                          child: Text('Login'.tr),
                        ),
                        const SizedBox(height: SizesConst.P0),
                        TextButton(
                          onPressed: () {},
                          child: Text('forgotPassword'.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}