import 'package:home_service_provider/app/view/address/edit_address_screen.dart';
import 'package:home_service_provider/app/view/address/my_address_screen.dart';
import 'package:home_service_provider/app/view/bookings/booking_detail.dart';
import 'package:home_service_provider/app/view/card/card_screen.dart';
import 'package:home_service_provider/app/view/home/pick_screen.dart';
import 'package:home_service_provider/app/view/home/address_screen.dart';
import 'package:home_service_provider/app/view/home/cart_screen.dart';
import 'package:home_service_provider/app/view/home/category_screen.dart';
import 'package:home_service_provider/app/view/home/tab/courier_pick_screen.dart';
import 'package:home_service_provider/app/view/home/tab/local_pick_screen.dart';
import 'package:home_service_provider/app/view/home/date_time_screen.dart';
import 'package:home_service_provider/app/view/home/home_screen.dart';
import 'package:home_service_provider/app/view/home/detail_screen.dart';
import 'package:home_service_provider/app/view/home/payment_screen.dart';
import 'package:home_service_provider/app/view/home/order_detail.dart';
import 'package:home_service_provider/app/view/home/tab/outStation_pick_screen.dart';
//import 'package:home_service_provider/app/view/qrscan/scan_part.dart';
import 'package:home_service_provider/app/view/home/tab/town_pick_screen.dart';
import 'package:home_service_provider/app/view/intro/intro_screen.dart';
import 'package:home_service_provider/app/view/login/forgot_password.dart';
import 'package:home_service_provider/app/view/login/login_screen.dart';
import 'package:home_service_provider/app/view/login/reset_password.dart';
import 'package:home_service_provider/app/view/notification_screen.dart';
import 'package:home_service_provider/app/view/profile/edit_profile_screen.dart';
import 'package:home_service_provider/app/view/profile/profile_screen.dart';
import 'package:home_service_provider/app/view/search/search_screen.dart';
import 'package:home_service_provider/app/view/setting/help_screen.dart';
import 'package:home_service_provider/app/view/setting/privacy_screen.dart';
import 'package:home_service_provider/app/view/setting/security_screen.dart';
import 'package:home_service_provider/app/view/setting/setting_screen.dart';
import 'package:home_service_provider/app/view/setting/term_of_service_screen.dart';
import 'package:home_service_provider/app/view/signup/select_country.dart';
import 'package:home_service_provider/app/view/signup/signup_screen.dart';
import 'package:home_service_provider/app/view/signup/verify_screen.dart';
import 'package:home_service_provider/app/view/bookings/scan_part_screen.dart';
import 'package:home_service_provider/app/view/bookings/complete_booking_details.dart';
import 'package:home_service_provider/app/view/bookings/complete_PickedRate.dart';

import 'package:flutter/cupertino.dart';

import '../view/bookings/active_details_screen.dart';
import '../view/bookings/pick_List_Preview.dart';
import '../view/bookings/profile_history_screen.dart';
import '../view/bookings/report_details.dart';
import '../view/qrscan/scan_bin.dart';
import '../view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.homeRoute: (context) => const SplashScreen(),
    Routes.introRoute: (context) => const IntroScreen(),
    Routes.loginRoute: (context) => const LoginScreen(),
    Routes.forgotRoute: (context) => const ForgotPassword(),
    Routes.resetRoute: (context) => const ResetPassword(),
    Routes.signupRoute: (context) => const SignUpScreen(),
    Routes.selectCountryRoute: (context) => const SelectCountry(),
    Routes.verifyRoute: (context) => const VerifyScreen(),
    Routes.homeScreenRoute: (context) => const HomeScreen(0),
    Routes.categoryRoute: (context) => const CategoryScreen(),
    Routes.detailRoute: (context) => const DetailScreen(),
    Routes.cartRoute: (context) => const CartScreen(),
    Routes.addressRoute: (context) => const AddressScreen(),
    Routes.dateTimeRoute: (context) => const DateTimeScreen(),
    Routes.paymentRoute: (context) => const PaymentScreen(),
    Routes.orderDetailRoute: (context) => const OrderDetail(),
    Routes.profileRoute: (context) => const ProfileScreen(),
    Routes.editProfileRoute: (context) => const EditProfileScreen(),
    Routes.myAddressRoute: (context) => const MyAddressScreen(),
    Routes.editAddressRoute: (context) => const EditAddressScreen(),
    Routes.cardRoute: (context) => const CardScreen(),
    Routes.settingRoute: (context) => const SettingScreen(),
    Routes.notificationRoutes: (context) => const NotificationScreen(),
    Routes.searchRoute: (context) => const SearchScreen(),
    Routes.bookingRoute: (context) => const BookingDetail(),
    Routes.helpRoute: (context) => const HelpScreen(),
    Routes.privacyRoute: (context) => const PrivacyScreen(),
    Routes.securityRoute: (context) => const SecurityScreen(),
    Routes.termOfServiceRoute: (context) => const TermOfServiceScreen(),
    Routes.pickRoute: (context) => const PickScreen(),
    Routes.localPickScreenRoute: (context) => const LocalPickScreen(),
    Routes.courierPickScreenRoute: (context) => const CourierPickScreen(),
    Routes.outStationPickScreenRoute: (context) => const OutStationPickScreen(),
    Routes.townPickScreenRoute: (context) => const TownPickScreen(),
    Routes.scanBinRoute: (context) => ScanBin(),
    Routes.scanPartScreenRoute: (context) =>  const ScanPartScreen(),
    Routes.completeBookingDetailsScreenRoute: (context) =>  const CompleteBookingDetails(),
    Routes.completePickedRateScreenRoute: (context) =>  const CompletePickedRate(),
    Routes.activeDetailsScreenRoute: (context) =>  const ActiveDetails(),

    Routes.profileHistoryScreenRoute: (context) =>  const ProfileHistory(),
    Routes.reportDetailsScreenRoute: (context) =>  const ReportDetails(),
    Routes.pickListPreviewScreenRoute: (context) =>  const PickListPreview(),
  };
}
