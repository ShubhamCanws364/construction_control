
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;
  static const _secure = FlutterSecureStorage();
  static const String userToken = "userToken";
  static const String userName = "userName";
  static const String communityName = "communityName";
  static const String userEmail = "userEmail";
  static const String userPhoneNumber = "userPhoneNumber";
  static const String fcmToken = "fcm";
  static const String rememberMe = "rememberMe";
  static const String userId = "userId";
  static const String saveLoggedIn = "saveLoggedIn";
  static const String userRole = "user_role";
  static const String userRoleId = "user_role_id";
  static const String customerName = "customer_name";
  static const String savedEmail = "savedEmail";
  static const String savedPassword = "savedPassword";
  static const String savedAiChatCount = "savedAiChatCount";
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveFcmToken(String token) async {
    await _prefs?.setString(fcmToken,token);
  }
  static Future<void> setUserId(String id) async {
    await _prefs?.setString(userId, id);
  }
  static Future<void> setUserName(String name) async {
    await _prefs?.setString(userName, name);
  }
  static Future<void> setUserEmail(String email) async {
    await _prefs?.setString(userEmail, email);
  }
  static Future<void> setUserPhoneNumber(String phoneNumber) async {
    await _prefs?.setString(userPhoneNumber, phoneNumber);
  }

  static Future<void> setSavedEmail(String email) async {
    await _prefs?.setString(savedEmail, email);
  }

  static Future<void> setSavedAiCount(String savedAiCount) async {
    await _prefs?.setString(savedAiChatCount, savedAiCount);
  }


  static Future<void> setEmailId(String key,String id) async {
    await _prefs?.setString(key, id);
  }

  static Future<void> setSubscription(String subscriptionKey, String value) async {
    await _prefs?.setString(subscriptionKey, value);
  }

  static Future<void> userType(String userType, String value) async {
    await _prefs?.setString(userType, value);
  }

  static Future<void> saveIsLoggedIn( bool value) async {
    await _prefs?.setBool(saveLoggedIn, value);
  }
  static Future<void> saveRememberMe( bool value) async {
    await _prefs?.setBool(rememberMe, value);
  }


  static Future<void> setUserRole(String? role) async {
    if (role != null) {
      await _prefs?.setString(userRole, role);
    }
  }
  static Future<void> setUserRoleId(String? role) async {
    if (role != null) {
      await _prefs?.setString(userRoleId, role);
    }
  }

  static Future<void> setCustomerName(String? role) async {
    if (role != null) {
      await _prefs?.setString(customerName, role);
    }
  }



  static Future<void> setSavedPassword(String password) async {
    await _secure.write(key: savedPassword, value: password);
  }

  static Future<String?> getSavedPassword() async {
    return await _secure.read(key: savedPassword);
  }

  static Future<void> setUserToken(String token) async {
    await _secure.write(key: userToken, value: token);
  }

  static Future<String?> getUserToken() async {
    return await _secure.read(key: userToken);
  }


  // ------------------ getter ------------------


  static String? getFcmToken() {
    return _prefs?.getString(fcmToken);
  }

  static String? getUserId() {
    return _prefs?.getString(userId);
  }

  static String? getUserName() {
    return _prefs?.getString(userName);
  }

  static String? getUserEmail() {
    return _prefs?.getString(userEmail);
  }

  static String? getSavedAiCount() {
    return _prefs?.getString(savedAiChatCount);
  }

  static String? getUserPhoneNumber() {
    return _prefs?.getString(userPhoneNumber);
  }

  static bool? getSaveLoggedIn() {
    return _prefs?.getBool(saveLoggedIn);
  }

  static bool? getSaveRememberMe() {
    return _prefs?.getBool(rememberMe);
  }

  static String? getUserRole() {
    return _prefs?.getString(userRole);
  }

  static String? getUserRoleId() {
    return _prefs?.getString(userRoleId);
  }

  static String? getCustomerName() {
    return _prefs?.getString(customerName);
  }

  static bool hasAccessToken(String accessTokenKey) {
    return _prefs?.containsKey(accessTokenKey) ?? false;
  }
  static bool getEmailId(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  static String? getSubscription(String subscriptionKey) {
    return _prefs?.getString(subscriptionKey);
  }

  static String? getUserType(String userType) {
    return _prefs?.getString(userType);
  }

  static String? getSavedEmail() {
    return _prefs?.getString(savedEmail);
  }


  static Future<void> clearSavedEmail() async {
    await _prefs?.remove(savedEmail);
  }

  static Future<void> clearSavedPassword() async {
    await _prefs?.remove(savedPassword);
  }

  // ------------------ Remove & Clear ------------------

  static Future<void> clear() async {
    bool remember = getSaveRememberMe() ?? false;
    String? email = getSavedEmail();
    String? password =await getSavedPassword();
    String? fcm = getFcmToken();
    await _prefs?.clear();
    await _secure.deleteAll();
    if (fcm != null) {
      await saveFcmToken(fcm);
    }
    if (remember) {
      await saveRememberMe(true);
      if (email != null) await setSavedEmail(email);
      if (password != null) await setSavedPassword(password);
    }
  }
}