abstract class ApiUrls {
  //Base Url
  static String baseurl = "https://seedlink.skyguruu.com";

  // Login
  static String postLogin = "/api/v1/customer/auth/login";

  // Logout
  static String postLogOut = "/api/v1/customer/auth/logout";

  // Register Email
  static String postEmailRegister = "/api/v1/customer/auth/register/initiate";

  // Register VerifyOTP
  static String postVerifyOTP = "/api/v1/customer/auth/register/verify-otp";

  // ResentOTP
  static String postResentOTP = "/api/v1/customer/auth/register/resend-otp";

  // Create Password
  static String postCreatePassword =
      "/api/v1/customer/auth/register/set-password";

  // Set Up Profile
  static String postSetUpProfile =
      "/api/v1/customer/auth/register/complete-profile";

  // Home
  static String getHome = "/api/v1/customer/dashboard";

  //Get Profile
  static String getprofile = "/api/v1/customer/auth/profile";

  //Edit Profile
  static String editprofile = "/api/v1/customer/auth/profile";

  //Default Address
  static String getDefaultAddress = "/api/v1/customer/addresses/default";
  

  //All Address
  static String getAllAddress = "/api/v1/customer/addresses";
}
