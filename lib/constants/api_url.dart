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
}
