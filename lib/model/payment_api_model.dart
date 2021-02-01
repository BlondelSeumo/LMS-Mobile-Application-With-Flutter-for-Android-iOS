// To parse this JSON data, do
//
//     final paymentApi = paymentApiFromJson(jsonString);

import 'dart:convert';

PaymentApi paymentApiFromJson(String str) =>
    PaymentApi.fromJson(json.decode(str));

String paymentApiToJson(PaymentApi data) => json.encode(data.toJson());

class PaymentApi {
  PaymentApi({
    this.stripekey,
    this.stripesecret,
    this.paypalClientId,
    this.paypalSecret,
    this.paypalMode,
    this.instamojoApiKey,
    this.instamojoAuthToken,
    this.instamojoUrl,
    this.razorpayKey,
    this.razorpaySecret,
    this.paystackPublicKey,
    this.paystackSecret,
    this.paystackPayUrl,
    this.paystackMerchantEmail,
    this.paytmEnviroment,
    this.paytmMerchantId,
    this.paytmMerchantKey,
    this.paytmMerchantWebsite,
    this.paytmChannel,
    this.paytmIndustryType,
    this.bankDetails,
  });

  String stripekey;
  String stripesecret;
  String paypalClientId;
  String paypalSecret;
  String paypalMode;
  String instamojoApiKey;
  String instamojoAuthToken;
  String instamojoUrl;
  String razorpayKey;
  String razorpaySecret;
  String paystackPublicKey;
  String paystackSecret;
  String paystackPayUrl;
  String paystackMerchantEmail;
  String paytmEnviroment;
  String paytmMerchantId;
  String paytmMerchantKey;
  String paytmMerchantWebsite;
  String paytmChannel;
  dynamic paytmIndustryType;
  BankDetails bankDetails;

  factory PaymentApi.fromJson(Map<String, dynamic> json) => PaymentApi(
        stripekey: json["stripekey"],
        stripesecret: json["stripesecret"],
        paypalClientId: json["paypal_client_id"],
        paypalSecret: json["paypal_secret"],
        paypalMode: json["paypal_mode"],
        instamojoApiKey: json["instamojo_api_key"],
        instamojoAuthToken: json["instamojo_auth_token"],
        instamojoUrl: json["instamojo_url"],
        razorpayKey: json["razorpay_key"],
        razorpaySecret: json["razorpay_secret"],
        paystackPublicKey: json["paystack_public_key"],
        paystackSecret: json["paystack_secret"],
        paystackPayUrl: json["paystack_pay_url"],
        paystackMerchantEmail: json["paystack_merchant_email"],
        paytmEnviroment: json["paytm_enviroment"],
        paytmMerchantId: json["paytm_merchant_id"],
        paytmMerchantKey: json["paytm_merchant_key"],
        paytmMerchantWebsite: json["paytm_merchant_website"],
        paytmChannel: json["paytm_channel"],
        paytmIndustryType: json["paytm_industry_type"],
        bankDetails: json["bank_details"] == null? null: BankDetails.fromJson(json["bank_details"]),
      );

  Map<String, dynamic> toJson() => {
        "stripekey": stripekey,
        "stripesecret": stripesecret,
        "paypal_client_id": paypalClientId,
        "paypal_secret": paypalSecret,
        "paypal_mode": paypalMode,
        "instamojo_api_key": instamojoApiKey,
        "instamojo_auth_token": instamojoAuthToken,
        "instamojo_url": instamojoUrl,
        "razorpay_key": razorpayKey,
        "razorpay_secret": razorpaySecret,
        "paystack_public_key": paystackPublicKey,
        "paystack_secret": paystackSecret,
        "paystack_pay_url": paystackPayUrl,
        "paystack_merchant_email": paystackMerchantEmail,
        "paytm_enviroment": paytmEnviroment,
        "paytm_merchant_id": paytmMerchantId,
        "paytm_merchant_key": paytmMerchantKey,
        "paytm_merchant_website": paytmMerchantWebsite,
        "paytm_channel": paytmChannel,
        "paytm_industry_type": paytmIndustryType,
        "bank_details": bankDetails.toJson(),
      };
}

class BankDetails {
  BankDetails({
    this.id,
    this.bankName,
    this.ifcsCode,
    this.accountNumber,
    this.accountHolderName,
    this.swiftCode,
    this.bankEnable,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String bankName;
  String ifcsCode;
  String accountNumber;
  String accountHolderName;
  String swiftCode;
  dynamic bankEnable;
  DateTime createdAt;
  DateTime updatedAt;

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        id: json["id"],
        bankName: json["bank_name"],
        ifcsCode: json["ifcs_code"],
        accountNumber: json["account_number"],
        accountHolderName: json["account_holder_name"],
        swiftCode: json["swift_code"],
        bankEnable: json["bank_enable"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "ifcs_code": ifcsCode,
        "account_number": accountNumber,
        "account_holder_name": accountHolderName,
        "swift_code": swiftCode,
        "bank_enable": bankEnable,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
