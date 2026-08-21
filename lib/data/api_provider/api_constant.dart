class ApiConstants{
///Live base Url
   static const String _baseUrl = "https://www.qualitysyncsolutions.com/api";

  ///dev baseUrl
  // static const String _baseUrl = "https://dev.qualitysyncsolutions.com/api";
  ///Live socket Url
  static  String socketUrl = "https://www.qualitysyncsolutions.com:8005";
  ///dev baseUrl
  // static  String socketUrl = "https://dev.qualitysyncsolutions.com:8006";
  ///Live image Url
  static  String imageUrl = "https://www.qualitysyncsolutions.com/storage/";
  ///dev image url
  // static  String imageUrl = "https://dev.qualitysyncsolutions.com/storage/";
  ///Live ai baseUrl
  static  String aiDiagnose = "https://www.qualitysyncsolutions.com/api/user/issues";

  ///dev ai baseUrl
  // static  String aiDiagnose = "https://dev.qualitysyncsolutions.com/api/user/issues";

  static String login = "$_baseUrl/login";
  static String finderSignup = "$_baseUrl/finder-register";
  static String verifyEmailOtp = "$_baseUrl/verify-otp";
  static String forgotPassword = "$_baseUrl/forgot-password";
  static String resendOtp = "$_baseUrl/resend-otp";
  static String verifyForgotPassword = "$_baseUrl/verify-password-otp";
  static String saveTermsConditionTime = "$_baseUrl/verify-password-otp";
  static String resetPassword = "$_baseUrl/reset-password";
  static String setNewPassword = "$_baseUrl/set-new-password";
  static String logout = "$_baseUrl/user/logout";
  static String changePassword = "$_baseUrl/user/change-password";
  static String getUserProfile = "$_baseUrl/user/profile";
  static String inspectionList = "$_baseUrl/user/inspections";
  static String inspectionAssignedList = "$_baseUrl/user/inspections";
  static String fetchAllUnAssignedIssues = "$_baseUrl/user/cm/issue/open-issues";
  static String inspectionDetails= "$_baseUrl/user/inspection";
  static String getProfile= "$_baseUrl/user/profile";
  static String getNotifications= "$_baseUrl/user/notification";
  static String markAsRead= "$_baseUrl/user/notification-mark/";
  static String faqList= "$_baseUrl/user/faqs";
  static String fcmTokenSave= "$_baseUrl/user/save-fcm-token";
  static String getCommunities= "$_baseUrl/user/communities";
  static String getUnAssignCommunities= "$_baseUrl/user/communities";
  static String getAllIssuesCounts= "$_baseUrl/user/trademen/issue/count";
  static String getInspections= "$_baseUrl/user/inspections";
  static String inspectionsDetails= "$_baseUrl/user/inspection/";
  static String nonNegotiables= "$_baseUrl/user/non-negotiables";
  static String viewNonNegotiable= "$_baseUrl/user/inspections/questions-ansers";
  static String createIssue= "$_baseUrl/user/issue/create";
  static String createNonNegotiable= "$_baseUrl/user/inspections/submit";
  static String createBug= "$_baseUrl/user/bugs/create";
  static String createSuggestions= "$_baseUrl/user/suggestions/create";
  static String getIssueTypeList= "$_baseUrl/user/issue/types/list";

  static String getSiteIdList= "$_baseUrl/user/communities";

  static String getIssueList= "$_baseUrl/user/issue/list";
  static String issueUpdate= "$_baseUrl/user/trademen/issue/action";
  static String getLocationsList= "$_baseUrl/user/locations/list/";

  static String cmIssueAccepted= "$_baseUrl/user/cm/issue/action/";
  static String updateIssueCount= "$_baseUrl/user/inspections/update-closed-count";
  static String issueAssignTadeCompany= "$_baseUrl/user/cm/issue/assign/trade-company/";
  static String getIssueDetails= "$_baseUrl/user/issue/detail/";
  static String issueUpdated= "$_baseUrl/user/issue/update/";
  static String deleteImage= "$_baseUrl/user/issue/delete-file/";
  static String issueDelete= "$_baseUrl/user/issue/delete";
  static String getTradeMenIssueList= "$_baseUrl/user/trademen/issue/list";
  static String getNewIssueAssigned= "$_baseUrl/user/trademen/issue/list-all";
  static String getTradeList= "$_baseUrl/user/tradecompanies/";
  static String getTradeCompany= "$_baseUrl/user/communities/tradecompanies";
  static String cmIssueUpdate= "$_baseUrl/user/cm/issue/assign/trade-company/";
  static String tradeCompanyAssignByCm= "$_baseUrl/user/issue/issues-assign-trade-company";
  static String addNotes= "$_baseUrl/user/issue/notes/save/";
  static String issueUpdateOthers= "$_baseUrl/user/cm/issue/action/";
  static String finishInspection= "$_baseUrl/user/inspections/finish/";
  static String acceptAssignment= "$_baseUrl/user/inspections/finish/";
  static String rejectInspection= "$_baseUrl/user/inspections/finish/";
  static String getNewAssignments= "$_baseUrl/user/inspections";
  static String issueAcceptTrademen= "$_baseUrl/user/cm/issue/action/";
  static String acceptUnAssignedIssues= "$_baseUrl/user/cm/issue/open-issues/accept/";
  static String issueAcceptAll= "$_baseUrl/user/trademen/issue/accept-all";
  static String submitToTrade= "$_baseUrl/user/cm/issue/confirm-all";
  static String updateProfile= "$_baseUrl/user/profile/update/";
  static String issueLogs= "$_baseUrl/user/issue/logs/";
  static String inspectionLogs= "$_baseUrl/user/inspections/logs/";
  static String chatUserRole= "$_baseUrl/user/roles";
  static String selectUserRole= "$_baseUrl/user/chat-users/";
  static String chatNotification= "$_baseUrl/user/chat-notification";
  static String sendMessage= "$_baseUrl/user/inspections/comment";
  static String deleteAccount= "$_baseUrl/user/account";
}