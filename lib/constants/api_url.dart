abstract class ApiUrls {
  //Base Url
  static String baseurl = "https://drovvi.com";

  // Login
  static String postLogin = "/api/v1/customer/auth/login";

  // Refresh
  static String postRefresh = "/api/v1/customer/auth/refresh";

  // Logout
  static String postLogOut = "/api/v1/customer/auth/logout";

  // Forget password
  static String forgotPassword = "/api/v1/customer/auth/forgot-password";

  // Verify Rest OTP
  static String verifyResetOtp = "/api/v1/customer/auth/verify-reset-otp";

  // Resend Rest OTP
  static String resendResetOtp = "/api/v1/customer/auth/resend-reset-otp";

  // Reset Password
  static String resetpassword = "/api/v1/customer/auth/reset-password";

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

  // All Orders
  static String getOrders = "/api/v1/customer/orders";

  //Get Profile
  static String getprofile = "/api/v1/customer/auth/profile";

  //Edit Profile
  static String editprofile = "/api/v1/customer/auth/profile";

  //Default Address
  static String getDefaultAddress = "/api/v1/customer/addresses/default";

  //All Address
  static String getAllAddress = "/api/v1/customer/addresses";

  // Shopify Search
  static String getShopifySearch = "/api/shopify/search";

  // Caluculation
  static String postCalculation = "/api/v1/customer/orders/calculate-quote";

  // Place Order
  static String postPlaceOrder = "/api/v1/customer/orders";

  //Create Order

  // Product Type
  static String getProductType = "/api/master-data/product-types";

  // Packageing Type
  static String getPackageingType = "/api/master-data/packaging-types";

  // Service Type
  static String getServiceType = "/api/master-data/service-types";

  // Add Ons
  static String getAddOns = "/api/master-data/add-ons";

  // Caluculation Standard
  static String postCalculationStandard =
      "/api/v1/customer/orders/calculate-quote";

  // Caluculation Multi Stop
  static String postCalculationMultiStop =
      "/api/v1/customer/orders/calculate-quote";

  //order details
  static const String orderDetails = "/api/v1/customer/orders";

  //Company Dropdown
  static const String getCompany = "/api/master-data/all-companies";

  //Order Tracking
  static const String trackOrder = "/api/v1/customer/orders/track";
}
