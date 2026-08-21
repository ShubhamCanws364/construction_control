import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:construction_control/ui/ai_chat_boot_module/binding.dart';
import 'package:construction_control/ui/ai_chat_boot_module/screen.dart';
import 'package:construction_control/ui/auth/binding/forgot_email_binding.dart';
import 'package:construction_control/ui/auth/binding/invitation_code_binding.dart';
import 'package:construction_control/ui/auth/binding/login_binding.dart';
import 'package:construction_control/ui/auth/binding/email_verify_binding.dart';
import 'package:construction_control/ui/auth/binding/reset_password_binding.dart';
import 'package:construction_control/ui/auth/screen/email_verificaton_screen.dart';
import 'package:construction_control/ui/auth/screen/forgot_email_screen.dart';
import 'package:construction_control/ui/auth/screen/invitation_code_screen.dart';
import 'package:construction_control/ui/auth/screen/login_screen.dart';
import 'package:construction_control/ui/auth/screen/reset_password_screen.dart';
import 'package:construction_control/ui/auth/screen/set_permanent_password_screen.dart';
import 'package:construction_control/ui/dashboard/bindings/dashboard_bindings.dart';
import 'package:construction_control/ui/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:construction_control/ui/home/binding/assignments_binding.dart';
import 'package:construction_control/ui/home/binding/home_binding.dart';
import 'package:construction_control/ui/home/binding/new_open_issues_binding.dart';
import 'package:construction_control/ui/home/screens/assignment_screen.dart';
import 'package:construction_control/ui/home/screens/home_screen.dart';
import 'package:construction_control/ui/home/screens/new_open_issues_screen.dart';
import 'package:construction_control/ui/inspections/binding/inspection_binding.dart';
import 'package:construction_control/ui/inspections/binding/inspection_detail_binding.dart';
import 'package:construction_control/ui/issues/binding/issue_binding.dart';
import 'package:construction_control/ui/issues/binding/issue_create_binding.dart';
import 'package:construction_control/ui/issues/binding/issue_detail_binding.dart';
import 'package:construction_control/ui/inspections/binding/logs_binding.dart';
import 'package:construction_control/ui/inspections/binding/new_inspection_binding.dart';
import 'package:construction_control/ui/inspections/binding/non_negotiable_binding.dart';
import 'package:construction_control/ui/issues/screens/create_issue_screen.dart';
import 'package:construction_control/ui/inspections/screens/finish_inspection_screen.dart';
import 'package:construction_control/ui/inspections/screens/inspection_detail_screen.dart';
import 'package:construction_control/ui/inspections/screens/inspection_logs_screen.dart';
import 'package:construction_control/ui/inspections/screens/inspection_screen.dart';
import 'package:construction_control/ui/issues/screens/issue_details_screen.dart';
import 'package:construction_control/ui/issues/screens/issue_logs_screen.dart';
import 'package:construction_control/ui/issues/screens/issue_screen.dart';
import 'package:construction_control/ui/issues/screens/issue_submit_screen.dart';
import 'package:construction_control/ui/inspections/screens/new_inspection_screen.dart';
import 'package:construction_control/ui/inspections/screens/non_negotiable_screen.dart';
import 'package:construction_control/ui/inspections/screens/view_log_non_negotiable_page.dart';
import 'package:construction_control/ui/settings/binding/bug_identified_binding.dart';
import 'package:construction_control/ui/settings/binding/chat_binding.dart';
import 'package:construction_control/ui/settings/binding/chat_view_binding.dart';
import 'package:construction_control/ui/settings/binding/edit_profile_binding.dart';
import 'package:construction_control/ui/settings/binding/faq_binding.dart';
import 'package:construction_control/ui/settings/binding/notification_binding.dart';
import 'package:construction_control/ui/settings/binding/request_feature_binding.dart';
import 'package:construction_control/ui/settings/binding/setting_binding.dart';
import 'package:construction_control/ui/settings/screens/bug_identified_screen.dart';
import 'package:construction_control/ui/settings/screens/chat_screen.dart';
import 'package:construction_control/ui/settings/screens/chat_users_screen.dart';
import 'package:construction_control/ui/settings/screens/edit_profile_screen.dart';
import 'package:construction_control/ui/settings/screens/faq_question_screen.dart';
import 'package:construction_control/ui/settings/screens/faq_screen.dart';
import 'package:construction_control/ui/settings/screens/notification_screen.dart';
import 'package:construction_control/ui/settings/screens/request_a_feature_screen.dart';
import 'package:construction_control/ui/settings/screens/setting_screen.dart';
import 'package:construction_control/ui/splash/binding/splash_bindings.dart';
import 'package:construction_control/ui/splash/screen/second_splash.dart';
import 'package:construction_control/ui/splash/screen/splash_screen.dart';

import 'app_pages.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRoutes.secondSplashScreen,
      page: () => SecondSplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.setNewPasswordScreen,
      page: () => SetPermanentPasswordScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerificationScreen,
      page: () => ForgotEmailScreen(),
      binding: ForgotEmailBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPasswordScreen,
      page: () => ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.inviteCodeScreen,
      page: () => InvitationCodeScreen(),
      binding: InvitationCodeBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerifyOtpScreen,
      page: () => EmailVerificationScreen(),
      binding: EmailVerifyBinding(),
    ),
    GetPage(
      name: AppRoutes.dashBoardScreen,
      page: () => DashboardScreen(),
      binding: DashboardBindings(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.inspectionScreen,
      page: () => InspectionScreen(),
      binding: InspectionBinding(),
    ),
    GetPage(
      name: AppRoutes.newInspectionScreen,
      page: () => NewInspectionScreen(),
      binding: NewInspectionBinding(),
    ),
    GetPage(
      name: AppRoutes.inspectionDetailScreen,
      page: () => InspectionDetailScreen(),
      binding: InspectionDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.finishInspectionScreen,
      page: () => FinishInspectionScreen(),
      binding: InspectionDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.settingScreen,
      page: () => SettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.nonNegotiableScreen,
      page: () => NonNegotiableScreen(),
      binding: NonNegotiableBinding(),
    ),
    GetPage(
      name: AppRoutes.issueScreen,
      page: () => IssueScreen(),
      binding: IssueBinding(),
    ),
    GetPage(
      name: AppRoutes.faqScreen,
      page: () => FaqScreen(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: AppRoutes.faqQuestionScreen,
      page: () => FaqQuestionScreen(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: AppRoutes.chatUserScreen,
      page: () => ChatUsersScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.chatScreen,
      page: () => ChatScreen(),
      binding: ChatViewBinding(),
    ),
    GetPage(
      name: AppRoutes.bugScreen,
      page: () => BugIdentifiedScreen(),
      binding: BugIdentifiedBinding(),
    ),
    GetPage(
      name: AppRoutes.requestFeatureScreen,
      page: () => RequestAFeatureScreen(),
      binding: RequestFeatureBinding(),
    ),
    GetPage(
      name: AppRoutes.assignmentScreen,
      page: () => AssignmentScreen(),
      binding: AssignmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.issueCreateScreen,
      page: () => CreateIssueScreen(),
      binding: IssueCreateBinding(),
    ),
    GetPage(
      name: AppRoutes.issueDetailScreen,
      page: () => IssueDetailScreen(),
      binding: IssueDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.issueSubmitScreen,
      page: () => IssueSubmitScreen(),
      binding: IssueDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () => EditProfileScreen(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.issueLogsScreen,
      page: () => IssueLogsScreen(),
      binding: LogsBinding(),
    ),
    GetPage(
      name: AppRoutes.viewLogNonNegotiablePage,
      page: () => ViewLogNonNegotiablePage(),
      binding: LogsBinding(),
    ),
    GetPage(
      name: AppRoutes.inspectionLogsScreen,
      page: () => InspectionLogsScreen(),
      binding: LogsBinding(),
    ),
    GetPage(
      name: AppRoutes.newOpenIssuesScreen,
      page: () => NewOpenIssuesScreen(),
      binding: NewOpenIssuesBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.aiDiagnosticSheet,
    //   page: () => AiDiagnosticSheet(),
    //   binding: AiChatBinding(),
    // ),

  ];
}
