import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:rikedu/src/config/routes/app_pages.dart';
import 'package:rikedu/src/config/themes/themes.dart';
import 'package:rikedu/src/features/authentication/controllers/auth_controller.dart';
import 'package:rikedu/src/features/authentication/controllers/home_controller.dart';
import 'package:rikedu/src/features/authentication/providers/auth_provider.dart';
import 'package:rikedu/src/features/news/controllers/post_controller.dart';
import 'package:rikedu/src/features/news/views/news_page.dart';
import 'package:rikedu/src/features/on_boarding/controllers/on_boarding_controller.dart';
import 'package:rikedu/src/features/on_boarding/screens/on_boarding_page.dart';
import 'package:rikedu/src/features/parental_controls/controllers/baterry_controller.dart';
import 'package:rikedu/src/features/parental_controls/controllers/group_controller.dart';
import 'package:rikedu/src/features/parental_controls/controllers/map_controller.dart';
import 'package:rikedu/src/features/parental_controls/controllers/parental_controls_controller.dart';
import 'package:rikedu/src/features/parental_controls/controllers/school_controller.dart';
import 'package:rikedu/src/features/parental_controls/controllers/student_active_controller.dart';
import 'package:rikedu/src/features/parental_controls/providers/battery_provider.dart';
import 'package:rikedu/src/features/parental_controls/providers/location_provider.dart';
import 'package:rikedu/src/features/parental_controls/views/school_page.dart';
import 'package:rikedu/src/features/parental_controls/views/widgets/map_widget.dart';
import 'package:rikedu/src/features/performance/screens/performance.dart';
import 'package:rikedu/src/features/settings/controllers/about_controller.dart';
import 'package:rikedu/src/features/settings/controllers/language_controller.dart';
import 'package:rikedu/src/features/settings/controllers/logout_controller.dart';
import 'package:rikedu/src/features/settings/controllers/setting_controller.dart';
import 'package:rikedu/src/features/settings/controllers/theme_controller.dart';
import 'package:rikedu/src/features/settings/providers/locale_provider.dart';
import 'package:rikedu/src/features/settings/providers/theme_provider.dart';
import 'package:rikedu/src/features/parental_controls/views/parental_controls_page.dart';
import 'package:rikedu/src/features/settings/views/settings_page.dart';
import 'package:rikedu/src/features/timetable/controllers/timetable_controller.dart';
import 'package:rikedu/src/features/timetable/providers/timetable_provider.dart';
import 'package:rikedu/src/features/timetable/views/timetable_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rikedu/src/languages/languages.dart';
import 'package:rikedu/src/utils/constants/roles_constants.dart';
import 'package:rikedu/src/utils/constants/storage_constants.dart';
import 'package:rikedu/src/utils/service/api_service.dart';
import 'package:rikedu/src/utils/service/firebase_service.dart';
import 'package:rikedu/src/utils/service/storage_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ApiService());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<FirebaseService>(() => FirebaseService().init());
  initializeDateFormatting(Get.locale.toString());

  final authProvider = AuthProvider();
  final themeProvider = ThemeProvider();
  final localProvider = LocaleProvider();
  final timetableProvider = TimetableProvider();
  final locationProvider = LocationProvider();
  final batteryProvider = BatteryProvider();
  await authProvider.init();
  await themeProvider.init();
  await localProvider.init();
  await timetableProvider.init();
  await locationProvider.init();
  await batteryProvider.init();

  initializeSystemUI();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => themeProvider),
    ChangeNotifierProvider(create: (_) => localProvider),
    ChangeNotifierProvider(create: (_) => authProvider),
    ChangeNotifierProvider(create: (_) => timetableProvider),
    ChangeNotifierProvider(create: (_) => locationProvider),
    ChangeNotifierProvider(create: (_) => batteryProvider),
  ], child: const MainApp()));
}

bool isDarkMode() {
  final StorageService storageService = Get.find();
  final themeModeTypeString =
      storageService.readData(StorageConst.SETTING_THEME_MODE);
  if (themeModeTypeString != null) {
    final themeModeType = ThemeModeType.values
        .firstWhere((e) => e.toString() == themeModeTypeString);
    return checkIsDarkMode(themeModeType);
  }
  return false;
}

bool checkIsDarkMode(ThemeModeType themeModeType) {
  return themeModeType == ThemeModeType.dark ? true : false;
}

void initializeSystemUI() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  Brightness statusBarIconBrightness =
      isDarkMode() ? Brightness.light : Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has resumed from the background
      setUserActive(true);
    } else if (state == AppLifecycleState.paused) {
      // App has been paused or closed
      setUserActive(false);
    }
  }

  void setUserActive(bool isActive) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isActive
        ? authProvider.setStudentOnline()
        : authProvider.setStudentOffline();
    print("Student active: $isActive");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localProvider = Provider.of<LocaleProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: RikeTheme.lightTheme,
      darkTheme: RikeTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: authProvider.isAuthenticated ? const HomePage() : OnBoardingPage(),
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
      translations: LanguageStrings(),
      locale: localProvider.locale,
      fallbackLocale: localProvider.localeDefault,
    );
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> navigationPages = [];
    List<GButton> tabs = [];
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.role == RolesConst.PARENT) {
      navigationPages = [
        const NewsPage(),
        TimetablePage(),
        const ParentalControlsPage(),
        const SettingsPage(),
      ];
      tabs = [
        GButton(
          icon: FluentIcons.news_24_regular,
          text: 'News'.tr,
        ),
        GButton(
          icon: FluentIcons.calendar_ltr_24_regular,
          text: 'Timetable'.tr,
        ),
        GButton(
          icon: FluentIcons.communication_person_24_regular,
          text: 'Parental Controls'.tr,
        ),
        GButton(
          icon: FluentIcons.settings_24_regular,
          text: 'Settings'.tr,
        ),
      ];
    }
    if (authProvider.role == RolesConst.STUDENT) {
      navigationPages = [
        const NewsPage(),
        TimetablePage(),
        const SchoolPage(),
        const SettingsPage(),
      ];

      tabs = [
        GButton(
          icon: FluentIcons.news_24_regular,
          text: 'News'.tr,
        ),
        GButton(
          icon: FluentIcons.calendar_ltr_24_regular,
          text: 'Timetable'.tr,
        ),
        GButton(
          icon: FluentIcons.hat_graduation_24_regular,
          text: 'School'.tr,
        ),
        GButton(
          icon: FluentIcons.settings_24_regular,
          text: 'Settings'.tr,
        ),
      ];
    }
    return Obx(
      () => Scaffold(
        extendBody: true,
        body: navigationPages[controller.selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: GNav(
                  rippleColor: Theme.of(context).colorScheme.surface,
                  hoverColor: Theme.of(context).colorScheme.scrim,
                  gap: 8,
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Theme.of(context).colorScheme.primary,
                  color: Theme.of(context).colorScheme.onBackground,
                  tabs: tabs,
                  selectedIndex: controller.selectedIndex,
                  onTabChange: (index) {
                    controller.selectedIndex = index;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FilledButton(
            onPressed: () => {Get.toNamed(Routes.LOGIN)},
            child: const Text(
              'Login',
            ),
          ),
          FilledButton(
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapWidget()))
            },
            child: const Text(
              'MAPVIEW',
            ),
          ),
          FilledButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PerformancePage()))
            },
            child: const Text(
              'Performance',
            ),
          ),
        ],
      ),
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardingController>(() => OnBoardingController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<LogoutController>(() => LogoutController());
    Get.lazyPut<TimetableController>(() => TimetableController());
    Get.lazyPut<MapController>(() => MapController());
    Get.lazyPut<BatteryController>(() => BatteryController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<ParentalControlsController>(() => ParentalControlsController());
    Get.lazyPut<StudentActiveController>(() => StudentActiveController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GroupController>(() => GroupController());
    Get.lazyPut<AboutController>(() => AboutController());
    Get.lazyPut<SchoolController>(() => SchoolController());
  }
}
