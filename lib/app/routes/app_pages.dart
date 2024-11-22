import 'package:get/get.dart';

import '../modules/CreditCard/bindings/credit_card_binding.dart';
import '../modules/CreditCard/views/credit_card_view.dart';
import '../modules/Maintenance/bindings/maintenance_binding.dart';
import '../modules/Maintenance/views/maintenance_view.dart';
import '../modules/Navigation/bindings/navigation_binding.dart';
import '../modules/Navigation/views/navigation_view.dart';
import '../modules/Notification/bindings/notification_binding.dart';
import '../modules/Notification/views/notification_view.dart';
import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/VerifyCredit/bindings/verify_credit_binding.dart';
import '../modules/VerifyCredit/views/verify_credit_view.dart';
import '../modules/VerifyDoc/bindings/verify_doc_binding.dart';
import '../modules/VerifyDoc/views/verify_doc_view.dart';
import '../modules/VerifyFace/bindings/verify_face_binding.dart';
import '../modules/VerifyFace/views/verify_face_view.dart';
import '../modules/VerifyFinger/bindings/verify_finger_binding.dart';
import '../modules/VerifyFinger/views/verify_finger_view.dart';
import '../modules/VerifyKTP/bindings/verify_k_t_p_binding.dart';
import '../modules/VerifyKTP/views/verify_k_t_p_view.dart';
import '../modules/fingerprint/bindings/fingerprint_binding.dart';
import '../modules/fingerprint/views/fingerprint_view.dart';
import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboardings/bindings/onboardings_binding.dart';
import '../modules/onboardings/views/onboardings_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDINGS;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDINGS,
      page: () => const OnboardingsView(),
      binding: OnboardingsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.FINGERPRINT,
      page: () => const FingerprintView(),
      binding: FingerprintBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => const ForgotpasswordView(),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_FACE,
      page: () => const VerifyFaceView(),
      binding: VerifyFaceBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_FINGER,
      page: () => const VerifyFingerView(),
      binding: VerifyFingerBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_K_T_P,
      page: () => const VerifyKTPView(),
      binding: VerifyKTPBinding(),
    ),
    GetPage(
      name: _Paths.MAINTENANCE,
      page: () => const MaintenanceView(),
      binding: MaintenanceBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_CREDIT,
      page: () => const VerifyCreditView(),
      binding: VerifyCreditBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_DOC,
      page: () => const VerifyDocView(),
      binding: VerifyDocBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_CARD,
      page: () => const CreditCardView(),
      binding: CreditCardBinding(),
    ),
  ];
}
