import 'dart:convert';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/user_profile_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class UserProfile with ChangeNotifier {
  UserProfileModel profileInstance = new UserProfileModel(
    id: 0,
    fname: "",
    lname: "",
    dob: "",
    doa: "",
    mobile: "",
    email: "",
    address: "",
    marriedStatus: "",
    cityId: "",
    stateId: "",
    countryId: "",
    gender: "",
    pinCode: "",
    status: "",
    verified: "",
    userImg: "",
    role: "",
    emailVerifiedAt: null,
    detail: "",
    braintreeId: "",
    fbUrl: "",
    twitterUrl: "",
    youtubeUrl: "",
    linkedinUrl: "",
    preferPayMethod: "",
    paypalEmail: "",
    paytmMobile: "",
    bankAccName: "",
    bankAccNo: "",
    ifscCode: "",
    bankName: "",
    facebookId: "",
    googleId: "",
    amazonId: "",
    createdAt: null,
    updatedAt: null,
    zoomEmail: "",
    jwtToken: "",
    gitlabId: "",
    linkedinId: "",
    twitterId: "",
    code: "",
  );

  Future<String> fetchUserProfile() async {
    String url = APIData.userProfile + "${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body)["user"];
      this.profileInstance = new UserProfileModel(
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
        emailVerifiedAt: json["email_verified_at"] == null ? null: DateTime.parse(json["email_verified_at"]),
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
    } else if (res.statusCode == 401) {
      http.Response res = await http.post(APIData.refresh);
      var response = jsonDecode(res.body);
      await storage.write(key: "token", value: "${response['access_token']}");
      await storage.write(
          key: "refreshToken", value: "${response['refresh_token']}");
      http.Response userProfileResponse =
          await http.post(APIData.userProfile + "${APIData.secretKey}", headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      var json = jsonDecode(userProfileResponse.body)["user"];
      this.profileInstance = new UserProfileModel(
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
    } else {
      throw "Can't get user profile data";
    }
    notifyListeners();
    return this.profileInstance.fname;
  }

  void updateDetails(upFName, upLName, upMob, upDetail, upAddress) {
    this.profileInstance.fname = upFName;
    this.profileInstance.lname = upLName;
    this.profileInstance.mobile = upMob;
    this.profileInstance.detail = upDetail;
    this.profileInstance.address = upAddress;
    notifyListeners();
  }
}
