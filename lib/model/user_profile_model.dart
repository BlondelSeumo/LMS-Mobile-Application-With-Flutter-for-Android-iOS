class UserProfileModel {
  int id;
  String fname;
  String lname;
  dynamic dob;
  dynamic doa;
  dynamic mobile;
  String email;
  String address;
  String marriedStatus;
  dynamic cityId;
  dynamic stateId;
  dynamic countryId;
  dynamic gender;
  dynamic pinCode;
  dynamic status;
  dynamic verified;
  String userImg;
  String role;
  DateTime emailVerifiedAt;
  String detail;
  dynamic braintreeId;
  dynamic fbUrl;
  dynamic twitterUrl;
  String youtubeUrl;
  String linkedinUrl;
  dynamic preferPayMethod;
  dynamic paypalEmail;
  dynamic paytmMobile;
  dynamic bankAccName;
  dynamic bankAccNo;
  dynamic ifscCode;
  dynamic bankName;
  dynamic facebookId;
  dynamic googleId;
  dynamic amazonId;
  DateTime createdAt;
  DateTime updatedAt;
  String zoomEmail;
  String jwtToken;
  dynamic gitlabId;
  dynamic linkedinId;
  dynamic twitterId;
  dynamic code;

  UserProfileModel({
    this.id,
    this.fname,
    this.lname,
    this.dob,
    this.doa,
    this.mobile,
    this.email,
    this.address,
    this.marriedStatus,
    this.cityId,
    this.stateId,
    this.countryId,
    this.gender,
    this.pinCode,
    this.status,
    this.verified,
    this.userImg,
    this.role,
    this.emailVerifiedAt,
    this.detail,
    this.braintreeId,
    this.fbUrl,
    this.twitterUrl,
    this.youtubeUrl,
    this.linkedinUrl,
    this.preferPayMethod,
    this.paypalEmail,
    this.paytmMobile,
    this.bankAccName,
    this.bankAccNo,
    this.ifscCode,
    this.bankName,
    this.facebookId,
    this.googleId,
    this.amazonId,
    this.createdAt,
    this.updatedAt,
    this.zoomEmail,
    this.jwtToken,
    this.gitlabId,
    this.linkedinId,
    this.twitterId,
    this.code,
  });
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json["id"],
        fname: json["fname"],
        lname: json["lname"],
        dob: json["dob"],
        doa: json["doa"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        marriedStatus: json["married_status"],
        cityId: json["city_id"],
        stateId: json["state_id"],
        countryId: json["country_id"],
        gender: json["gender"],
        pinCode: json["pin_code"],
        status: json["status"],
        verified: json["verified"],
        userImg: json["user_img"],
        role: json["role"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        detail: json["detail"],
        braintreeId: json["braintree_id"],
        fbUrl: json["fb_url"],
        twitterUrl: json["twitter_url"],
        youtubeUrl: json["youtube_url"],
        linkedinUrl: json["linkedin_url"],
        preferPayMethod: json["prefer_pay_method"],
        paypalEmail: json["paypal_email"],
        paytmMobile: json["paytm_mobile"],
        bankAccName: json["bank_acc_name"],
        bankAccNo: json["bank_acc_no"],
        ifscCode: json["ifsc_code"],
        bankName: json["bank_name"],
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        amazonId: json["amazon_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        zoomEmail: json["zoom_email"],
        jwtToken: json["jwt_token"],
        gitlabId: json["gitlab_id"],
        linkedinId: json["linkedin_id"],
        twitterId: json["twitter_id"],
        code: json["code"],
      );
}
