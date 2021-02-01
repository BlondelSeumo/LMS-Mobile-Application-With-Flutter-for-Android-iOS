class APIData {
  // Replace with your domain link : http://example.com/public/
  static const String domainLink = "ENTER_DOMAIN_LINK";

  static const String domainApiLink = domainLink + "api/";

  // API Links
  static const String getSecretKey = domainApiLink + "apikeys";
  static const String login = domainApiLink + "login";
  static const String fbLoginAPI = domainApiLink + "fblogin";
  static const String googleLoginApi = domainApiLink+"googlelogin";
  static const String register = domainApiLink + "register";
  static const String refresh = domainApiLink + "refresh";
  static const String logOut = domainApiLink + "logout";
  static const String forgotPassword = domainApiLink + "forgotpassword";
  static const String verifyCode = domainApiLink + "verifycode";
  static const String restPassword = domainApiLink + "resetpassword";
  static const String allCourse = domainApiLink + "course?secret=";
  static const String featuredCourses = domainApiLink + "featuredcourse?secret=";
  static const String categories = domainApiLink + "categories?secret=";
  static const String subCategories = domainApiLink + "subcategories?secret=";
  static const String childCategories = domainApiLink + "childcategories?secret=";
  static const String addToWishList = domainApiLink + "addtowishlist?secret=";
  static const String removeWishList = domainApiLink + "remove/wishlist?secret=";
  static const String wishList = domainApiLink + "show/wishlist?secret=";
  static const String featuredCategories = domainApiLink + "featured/categories?secret=";
  static const String bundleCourses = domainApiLink + "bundle/courses?secret=";
  static const String recentCourse = domainApiLink + "recent/course?secret=";
  static const String testimonials = domainApiLink + "testimonial?secret=";
  static const String trustedCompany = domainApiLink + "trusted?secret=";
  static const String userFaq = domainApiLink + "user/faq?secret=";
  static const String instructorFaq = domainApiLink + "instructor/faq?secret=";
  static const String blog = domainApiLink + "blog?secret=";
  static const String userProfile = domainApiLink + "show/profile?secret=";
  static const String updateUserProfile = domainApiLink + "update/profile?secret=";
  static const String addToCart = domainApiLink + "addtocart?secret=";
  static const String removeFromCart = domainApiLink + "remove/cart?secret=";
  static const String showCart = domainApiLink + "show/cart?secret=";
  static const String courseDetail = domainApiLink + "course/detail?secret=";
  static const String allPage = domainApiLink + "all/pages?secret=";
  static const String home = domainApiLink + "home?secret=";
  static const String slider = domainApiLink + "slider?secret=";
  static const String sliderFacts = domainApiLink + "sliderfacts?secret=";
  static const String removeAllCourseFromCart = domainApiLink + "remove/all/cart?secret=";
  static const String addBundleToCart = domainApiLink + "addtocart/bundle?secret=";
  static const String removeBundleCourseFromCart = domainApiLink + "remove/bundle?secret=";
  static const String notifications = domainApiLink + "notifications?secret=";
  static const String readNotification = domainApiLink + "readnotification/";
  static const String readAllNotification = domainApiLink + "readall/notification?secret=";
  static const String instructorProfile = domainApiLink + "instructor/profile?secret=";
  static const String courseReview = domainApiLink + "course/review?secret=";
  static const String chapterDuration = domainApiLink + "chapter/duration?secret=";
  static const String myCourses = domainApiLink + "my/courses?secret=";
  static const String aboutUs = domainApiLink + "aboutus?secret=";
  static const String contactUs = domainApiLink + "contactus?secret=";
  static const String becomeAnInstructor = domainApiLink + "instructor/request?secret=";
  static const String purchaseHistory = domainApiLink + "purchase/history?secret=";
  static const String coupon = domainApiLink + "all/coupons?secret=";
  static const String flagContent = domainApiLink + "course/report?secret=";
  static const String updateProgress = domainApiLink + "course/progress/update?secret=";
  static const String paymentGatewayKeys = domainApiLink + "payment/apikeys?secret=";
  static const String payStore = domainApiLink + "pay/store?secret=";
  static const String applyCoupon = domainApiLink + "apply/coupon?secret=";
  static const String removeCoupon = domainApiLink + "remove/coupon?secret=";
  static const String courseProgress = domainApiLink + "course/progress?secret=";
  static const String courseContent = domainApiLink + "course/content/";
  static const String requestAppointment = domainApiLink + "appointment/request?secret=";
  static const String submitAssignment = domainApiLink + "assignment/submit?secret=";
  static const String submitAnswer = domainApiLink + "answer/submit?secret=";
  static const String submitQuestion = domainApiLink + "question/submit?secret=";
  static const String deleteAppointment = domainApiLink + "appointment/delete/";

//  Images server path URI
  static const String logo = domainLink + "images/logo/";
  static const String testimonialImages = domainLink + "images/testimonial/";
  static const String trustedImages = domainLink + "images/trusted/";
  static const String loginImageUri = domainLink + "images/login/";
  static const String userImage = domainLink + "/images/user_img/";
  static const String courseImages = domainLink + "images/course/";
  static const String bundleImages = domainLink + "images/bundle/";
  static const String sliderImages = domainLink + "images/slider/";
  static const String aboutUsImages = domainLink + "images/about/";
  static const String contactUsImages = domainLink + "images/contact/";
  static const String categoryImages = domainLink + "images/category/";
  static const String userImagePath = domainLink + "images/user_img/";


// Webview player
  static const String watchCourse = domainLink + "watchcourse/";
  static const String watchClass = domainLink + "watchclass/";

//  Constants
  static const String appName = "eClass";
 //  static const String secretKey = "ENTER_SECRET_KEY";
   static const String secretKey = "";

  // To play google drive video

  // Enter google drive key to play Google drive video 

  static const String googleDriveApi = '';

//  Zoom details
  static const String zoomAppKey = "2ZAW3uJzMwr7kJJlQHjd4N8FUAFUbYwLzsMz";
  static const String zoomSecretKey = "BowiWIeIVOngA46vZJGYipa5U4Ys0vpqODdU";
}
