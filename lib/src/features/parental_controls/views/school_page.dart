import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rikedu/src/config/routes/app_pages.dart';
import 'package:rikedu/src/features/news/views/widgets/image_container_widget.dart';
import 'package:rikedu/src/features/parental_controls/controllers/parental_controls_controller.dart';
import 'package:rikedu/src/features/parental_controls/controllers/school_controller.dart';

class SchoolPage extends GetView<SchoolController> {
  const SchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.4),
                    child: Obx(
                      () => ImageContainer(
                        width: double.infinity,
                        height: double.infinity,
                        imageUrl: controller.imageURL,
                        overlay: true,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '"${controller.quote}"',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Colors.white,
                                        height: 1.25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '- ${controller.author} -',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        height: 1.25,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    right: 0,
                    left: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              buildHandleBar(context),
                              const FunctionBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildHandleBar(BuildContext context) {
  final theme = Theme.of(context);
  return FractionallySizedBox(
    widthFactor: 0.10,
    child: Container(
      margin: const EdgeInsets.only(
        top: 12.0,
      ),
      child: Container(
        height: 5.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(2.5)),
        ),
      ),
    ),
  );
}

class FunctionBox extends GetView<ParentalControlsController> {
  const FunctionBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          FunctionItem(
            function: 'Notifications'.tr,
            icon: Icon(
              FluentIcons.alert_urgent_24_regular,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
          ),
          const SizedBox(height: 15),
          FunctionItem(
            function: 'Results'.tr,
            icon: Icon(
              FluentIcons.book_contacts_28_regular,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Get.toNamed(Routes.RESULTS),
          ),
          const SizedBox(height: 15),
          FunctionItem(
            function: 'Group'.tr,
            icon: Icon(
              FluentIcons.book_pulse_24_regular,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Get.toNamed(Routes.GROUP),
          ),
          const SizedBox(height: 15),
          FunctionItem(
            function: 'Exercises'.tr,
            icon: Icon(
              FluentIcons.box_24_regular,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Get.toNamed(Routes.EXERCISE),
          )
        ],
      ),
    );
  }
}

class FunctionItem extends StatelessWidget {
  const FunctionItem({
    Key? key,
    required this.function,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String function;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: icon,
                  )),
              Align(
                alignment: Alignment.center,
                child: Text(
                  function,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
