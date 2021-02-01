import 'package:eclass/model/zoom_meeting.dart';

class HomeModel {
  HomeModel({
    this.settings,
    this.currency,
    this.slider,
    this.sliderfacts,
    this.trusted,
    this.testimonial,
    this.category,
    this.subcategory,
    this.childcategory,
    this.featuredCate,
    this.zoomMeeting,
  });

  Settings settings;
  Currency currency;
  List<MySlider> slider;
  List<SliderFact> sliderfacts;
  List<Trusted> trusted;
  List<Testimonial> testimonial;
  List<MyCategory> category;
  List<SubCategory> subcategory;
  List<ChildCategory> childcategory;
  List<MyCategory> featuredCate;
  List<ZoomMeeting> zoomMeeting;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        settings: Settings.fromJson(json["settings"]),
        currency: Currency.fromJson(json["currency"]),
        slider:
            List<MySlider>.from(json["slider"].map((x) => MySlider.fromJson(x))),
        sliderfacts: List<SliderFact>.from(
            json["sliderfacts"].map((x) => SliderFact.fromJson(x))),
        trusted:
            List<Trusted>.from(json["trusted"].map((x) => Trusted.fromJson(x))),
        testimonial: List<Testimonial>.from(
            json["testimonial"].map((x) => Testimonial.fromJson(x))),
        category: List<MyCategory>.from(
            json["category"].map((x) => MyCategory.fromJson(x))),
        subcategory: List<SubCategory>.from(
            json["subcategory"].map((x) => SubCategory.fromJson(x))),
        childcategory: List<ChildCategory>.from(
            json["childcategory"].map((x) => ChildCategory.fromJson(x))),
        featuredCate: List<MyCategory>.from(
            json["featured_cate"].map((x) => MyCategory.fromJson(x))),
      zoomMeeting: List<ZoomMeeting>.from(
          json["meeting"].map((x) => ZoomMeeting.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
        "settings": settings.toJson(),
        "currency": currency.toJson(),
        "slider": List<dynamic>.from(slider.map((x) => x.toJson())),
        "sliderfacts": List<dynamic>.from(sliderfacts.map((x) => x.toJson())),
        "trusted": List<dynamic>.from(trusted.map((x) => x.toJson())),
        "testimonial": List<dynamic>.from(testimonial.map((x) => x.toJson())),
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
        "subcategory": List<dynamic>.from(subcategory.map((x) => x.toJson())),
        "childcategory":
            List<dynamic>.from(childcategory.map((x) => x.toJson())),
        "featured_cate":
            List<dynamic>.from(featuredCate.map((x) => x.toJson())),
      };
}

class MyCategory {
  MyCategory({
    this.id,
    this.title,
    this.icon,
    this.slug,
    this.featured,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.catImage,
  });

  int id;
  String title;
  String icon;
  String slug;
  String featured;
  String status;
  dynamic position;
  DateTime createdAt;
  DateTime updatedAt;
  String catImage;

  factory MyCategory.fromJson(Map<String, dynamic> json) => MyCategory(
    id: json["id"],
    title: json["title"],
    icon: json["icon"],
    slug: json["slug"],
    featured: json["featured"],
    status: json["status"],
    position: json["position"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    catImage: json["cat_image"] == null ? null : json["cat_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "icon": icon,
    "slug": slug,
    "featured": featured,
    "status": status,
    "position": position,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "cat_image": catImage == null ? null : catImage,
  };
}


class Currency {
  Currency({
    this.id,
    this.icon,
    this.currency,
    this.currencyDefault,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String icon;
  String currency;
  dynamic currencyDefault;
  DateTime createdAt;
  DateTime updatedAt;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        icon: json["icon"],
        currency: json["currency"],
        currencyDefault: json["default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "currency": currency,
        "default": currencyDefault,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Settings {
  Settings({
    this.id,
    this.projectTitle,
    this.logo,
    this.favicon,
    this.cpyTxt,
    this.logoType,
    this.rightclick,
    this.inspect,
    this.metaDataDesc,
    this.metaDataKeyword,
    this.googleAna,
    this.fbPixel,
    this.fbLoginEnable,
    this.googleLoginEnable,
    this.gitlabLoginEnable,
    this.stripeEnable,
    this.instamojoEnable,
    this.paypalEnable,
    this.paytmEnable,
    this.braintreeEnable,
    this.razorpayEnable,
    this.paystackEnable,
    this.wEmailEnable,
    this.verifyEnable,
    this.welEmail,
    this.defaultAddress,
    this.defaultPhone,
    this.instructorEnable,
    this.debugEnable,
    this.catEnable,
    this.featureAmount,
    this.preloaderEnable,
    this.zoomEnable,
    this.amazonEnable,
    this.captchaEnable,
    this.bblEnable,
    this.mapLat,
    this.mapLong,
    this.mapEnable,
    this.contactImage,
    this.mobileEnable,
    this.promoEnable,
    this.promoText,
    this.promoLink,
    this.linkedinEnable,
    this.mapApi,
    this.twitterEnable,
    this.awsEnable,
    this.certificateEnable,
    this.deviceControl,
    this.ipblockEnable,
    this.ipblock,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String projectTitle;
  String logo;
  String favicon;
  String cpyTxt;
  String logoType;
  dynamic rightclick;
  dynamic inspect;
  String metaDataDesc;
  String metaDataKeyword;
  String googleAna;
  String fbPixel;
  dynamic fbLoginEnable;
  dynamic googleLoginEnable;
  dynamic gitlabLoginEnable;
  dynamic stripeEnable;
  dynamic instamojoEnable;
  dynamic paypalEnable;
  dynamic paytmEnable;
  dynamic braintreeEnable;
  dynamic razorpayEnable;
  dynamic paystackEnable;
  dynamic wEmailEnable;
  dynamic verifyEnable;
  String welEmail;
  String defaultAddress;
  String defaultPhone;
  dynamic instructorEnable;
  dynamic debugEnable;
  dynamic catEnable;
  dynamic featureAmount;
  dynamic preloaderEnable;
  dynamic zoomEnable;
  dynamic amazonEnable;
  dynamic captchaEnable;
  dynamic bblEnable;
  String mapLat;
  String mapLong;
  dynamic mapEnable;
  String contactImage;
  dynamic mobileEnable;
  dynamic promoEnable;
  String promoText;
  String promoLink;
  dynamic linkedinEnable;
  String mapApi;
  dynamic twitterEnable;
  dynamic awsEnable;
  dynamic certificateEnable;
  dynamic deviceControl;
  dynamic ipblockEnable;
  dynamic ipblock;
  dynamic createdAt;
  DateTime updatedAt;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        id: json["id"],
        projectTitle: json["project_title"],
        logo: json["logo"],
        favicon: json["favicon"],
        cpyTxt: json["cpy_txt"],
        logoType: json["logo_type"],
        rightclick: json["rightclick"],
        inspect: json["inspect"],
        metaDataDesc: json["meta_data_desc"],
        metaDataKeyword: json["meta_data_keyword"],
        googleAna: json["google_ana"],
        fbPixel: json["fb_pixel"],
        fbLoginEnable: json["fb_login_enable"],
        googleLoginEnable: json["google_login_enable"],
        gitlabLoginEnable: json["gitlab_login_enable"],
        stripeEnable: json["stripe_enable"],
        instamojoEnable: json["instamojo_enable"],
        paypalEnable: json["paypal_enable"],
        paytmEnable: json["paytm_enable"],
        braintreeEnable: json["braintree_enable"],
        razorpayEnable: json["razorpay_enable"],
        paystackEnable: json["paystack_enable"],
        wEmailEnable: json["w_email_enable"],
        verifyEnable: json["verify_enable"],
        welEmail: json["wel_email"],
        defaultAddress: json["default_address"],
        defaultPhone: json["default_phone"],
        instructorEnable: json["instructor_enable"],
        debugEnable: json["debug_enable"],
        catEnable: json["cat_enable"],
        featureAmount: json["feature_amount"],
        preloaderEnable: json["preloader_enable"],
        zoomEnable: json["zoom_enable"],
        amazonEnable: json["amazon_enable"],
        captchaEnable: json["captcha_enable"],
        bblEnable: json["bbl_enable"],
        mapLat: json["map_lat"],
        mapLong: json["map_long"],
        mapEnable: json["map_enable"],
        contactImage: json["contact_image"],
        mobileEnable: json["mobile_enable"],
        promoEnable: json["promo_enable"],
        promoText: json["promo_text"],
        promoLink: json["promo_link"],
        linkedinEnable: json["linkedin_enable"],
        mapApi: json["map_api"],
        twitterEnable: json["twitter_enable"],
        awsEnable: json["aws_enable"],
        certificateEnable: json["certificate_enable"],
        deviceControl: json["device_control"],
        ipblockEnable: json["ipblock_enable"],
        ipblock: json["ipblock"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_title": projectTitle,
        "logo": logo,
        "favicon": favicon,
        "cpy_txt": cpyTxt,
        "logo_type": logoType,
        "rightclick": rightclick,
        "inspect": inspect,
        "meta_data_desc": metaDataDesc,
        "meta_data_keyword": metaDataKeyword,
        "google_ana": googleAna,
        "fb_pixel": fbPixel,
        "fb_login_enable": fbLoginEnable,
        "google_login_enable": googleLoginEnable,
        "gitlab_login_enable": gitlabLoginEnable,
        "stripe_enable": stripeEnable,
        "instamojo_enable": instamojoEnable,
        "paypal_enable": paypalEnable,
        "paytm_enable": paytmEnable,
        "braintree_enable": braintreeEnable,
        "razorpay_enable": razorpayEnable,
        "paystack_enable": paystackEnable,
        "w_email_enable": wEmailEnable,
        "verify_enable": verifyEnable,
        "wel_email": welEmail,
        "default_address": defaultAddress,
        "default_phone": defaultPhone,
        "instructor_enable": instructorEnable,
        "debug_enable": debugEnable,
        "cat_enable": catEnable,
        "feature_amount": featureAmount,
        "preloader_enable": preloaderEnable,
        "zoom_enable": zoomEnable,
        "amazon_enable": amazonEnable,
        "captcha_enable": captchaEnable,
        "bbl_enable": bblEnable,
        "map_lat": mapLat,
        "map_long": mapLong,
        "map_enable": mapEnable,
        "contact_image": contactImage,
        "mobile_enable": mobileEnable,
        "promo_enable": promoEnable,
        "promo_text": promoText,
        "promo_link": promoLink,
        "linkedin_enable": linkedinEnable,
        "map_api": mapApi,
        "twitter_enable": twitterEnable,
        "aws_enable": awsEnable,
        "certificate_enable": certificateEnable,
        "device_control": deviceControl,
        "ipblock_enable": ipblockEnable,
        "ipblock": ipblock,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
      };
}

class MySlider {
  MySlider({
    this.id,
    this.heading,
    this.subHeading,
    this.searchText,
    this.detail,
    this.status,
    this.image,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String heading;
  String subHeading;
  String searchText;
  String detail;
  String status;
  String image;
  dynamic position;
  DateTime createdAt;
  DateTime updatedAt;

  factory MySlider.fromJson(Map<String, dynamic> json) => MySlider(
        id: json["id"],
        heading: json["heading"],
        subHeading: json["sub_heading"],
        searchText: json["search_text"],
        detail: json["detail"],
        status: json["status"],
        image: json["image"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "sub_heading": subHeading,
        "search_text": searchText,
        "detail": detail,
        "status": status,
        "image": image,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class SliderFact {
  SliderFact({
    this.id,
    this.icon,
    this.heading,
    this.subHeading,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String icon;
  String heading;
  String subHeading;
  DateTime createdAt;
  DateTime updatedAt;

  factory SliderFact.fromJson(Map<String, dynamic> json) => SliderFact(
        id: json["id"],
        icon: json["icon"],
        heading: json["heading"],
        subHeading: json["sub_heading"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "heading": heading,
        "sub_heading": subHeading,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Testimonial {
  Testimonial({
    this.id,
    this.clientName,
    this.details,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String clientName;
  String details;
  dynamic status;
  String image;
  dynamic createdAt;
  dynamic updatedAt;

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        id: json["id"],
        clientName: json["client_name"],
        details: json["details"],
        status: json["status"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_name": clientName,
        "details": details,
        "status": status,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Trusted {
  Trusted({
    this.id,
    this.url,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String url;
  String image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Trusted.fromJson(Map<String, dynamic> json) => Trusted(
        id: json["id"],
        url: json["url"],
        image: json["image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class FeaturedCate {
  FeaturedCate({
    this.id,
    this.title,
    this.icon,
    this.slug,
    this.featured,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String icon;
  String slug;
  String featured;
  String status;
  dynamic position;
  DateTime createdAt;
  DateTime updatedAt;

  factory FeaturedCate.fromJson(Map<String, dynamic> json) => FeaturedCate(
        id: json["id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        featured: json["featured"],
        status: json["status"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon": icon,
        "slug": slug,
        "featured": featured,
        "status": status,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ChildCategory {
  ChildCategory({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.title,
    this.icon,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic categoryId;
  dynamic subcategoryId;
  String title;
  String icon;
  String slug;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "title": title,
        "icon": icon,
        "slug": slug,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class SubCategory {
  SubCategory({
    this.id,
    this.categoryId,
    this.title,
    this.icon,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String categoryId;
  String title;
  String icon;
  String slug;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "icon": icon,
        "slug": slug,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
