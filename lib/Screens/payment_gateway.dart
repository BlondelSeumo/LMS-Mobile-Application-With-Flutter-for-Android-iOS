import 'package:eclass/common/global.dart';
import 'package:eclass/gateways/paypal/PaypalPayment.dart';
import 'package:eclass/gateways/stripe_payment.dart';
import 'package:eclass/model/payment_gateway_model.dart';
import 'package:eclass/provider/user_profile.dart';
import '../Widgets/utils.dart';
import '../gateways/bank_payment.dart';
import '../gateways/paystack_payment.dart';
import '../gateways/paytm_payment_page.dart';
import '../gateways/razor_payments.dart';
import '../provider/home_data_provider.dart';
import '../provider/payment_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class PaymentGateway extends StatefulWidget {
  final int tAmount;
  final disCountedAmount;

  PaymentGateway(this.tAmount, this.disCountedAmount);

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  int value;
  int id;
  var payAbleAmount;
  List<PaymentGatewayModel> listPayment = [];
  var loading = true;

  Widget bottomFixed(payment, user) {
    var homeData = Provider.of<HomeDataProvider>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, -20.5),
            spreadRadius: -15.0)
      ]),
      child: InkWell(
        child: Material(
          color: Colors.transparent,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(18.0),
              padding: EdgeInsets.all(10.0),
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Color(0xFFF44A4A),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6E1A52),
                      Color(0xFFF44A4A),
                    ]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Amount:  ${payAbleAmount.toString()}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                  Text(
                    "Continue to payment >>",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ],
              )),
        ),
        onTap: () {
          if (id == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StripePaymentScreen(amount: payAbleAmount),
                ));
          } else if (id == 2) {
            onPayWithPayPal(homeData, user);
          } else if (id == 3) {
            if ("${homeData.homeModel.currency}" == "NGN") {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: PayStackPage(
                    amount: payAbleAmount,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(msg: "Supported only NGN currency");
            }
          } else if (id == 4) {
            Fluttertoast.showToast(msg: "Supported only live mode");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaytmPaymentPage(amount: payAbleAmount),
                ));
          } else if (id == 5) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyRazorPaymentPage(amount: payAbleAmount),
                ));
          } else if (id == 6) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BankPayment(),
                ));
          } else {
            Fluttertoast.showToast(msg: "Please select payment gateway");
          }
        },
      ),
    );
  }

  void onPayWithPayPal(homeData, user) {
    currency = homeData.homeModel.currency.currency;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalPayment(
          onFinish: (number) async {},
          currency: currency,
          userFirstName: user.profileInstance.fname,
          userLastName: user.profileInstance.lname,
          userEmail: user.profileInstance.email,
          payAmount: "$payAbleAmount",
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    payAbleAmount = widget.disCountedAmount;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PaymentAPIProvider paymentAPIProvider =
      Provider.of<PaymentAPIProvider>(context, listen: false);
      await paymentAPIProvider.fetchPaymentAPI(context);

      var stripe = Provider.of<HomeDataProvider>(context, listen: false).homeModel.settings.stripeEnable;
      var paypal = Provider.of<HomeDataProvider>(context, listen: false)
          .homeModel
          .settings
          .paypalEnable;
      var paystack = Provider.of<HomeDataProvider>(context, listen: false)
          .homeModel
          .settings
          .paystackEnable;
      var paytm = Provider.of<HomeDataProvider>(context, listen: false)
          .homeModel
          .settings
          .paytmEnable;
      var razorpay = Provider.of<HomeDataProvider>(context, listen: false)
          .homeModel
          .settings
          .razorpayEnable;
      var bank = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .bankDetails ==
          null
          ? 0
          : Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .bankDetails
          .bankEnable;

      if (stripe == 1 || stripe == "1") {
        listPayment.add(
          PaymentGatewayModel(
              1, "Stripe", "assets/placeholder/stripe.png", "1"),
        );
      }
      if (paypal == 1 || paypal == "1") {
        listPayment.add(
          PaymentGatewayModel(
              2, "Paypal", "assets/placeholder/paypal.png", "1"),
        );
      }
      if (paystack == 1 || paystack == "1") {
        listPayment.add(PaymentGatewayModel(
            3, "PayStack", "assets/placeholder/paystackwallets.png", "1"));
      }
      if (paytm == 1 || paytm == "1") {
        listPayment.add(
          PaymentGatewayModel(4, "Paytm", "assets/placeholder/paytm.png", "1"),
        );
      }
      if (razorpay == 1 || razorpay == "1") {
        listPayment.add(
          PaymentGatewayModel(
              5, "RazorPay", "assets/placeholder/razorpay.png", "1"),
        );
      }
      if (bank == 1 || bank == "1") {
        listPayment.add(
          PaymentGatewayModel(
              6, "Bank Transfer", "assets/placeholder/bankwallets.png", "1"),
        );
      }
      setState(() {
        loading = false;
      });
    });
  }

  Widget listsOfGateways() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: index == 0
                  ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.4))
                  : BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
          child: RadioListTile(
            activeColor: const Color(0xFF0284A2),
            value: index,
            groupValue: value,
            onChanged: (ind) {
              setState(() {
                value = ind;
                id = listPayment[index].id;
              });
            },
            title: Row(
              children: [
                Container(
                  height: 65,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(listPayment[index].walletImage),
                      ),
                      borderRadius: BorderRadius.circular(15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    listPayment[index].name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: listPayment.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var payment = Provider.of<PaymentAPIProvider>(context).paymentApi;
    var user = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar: secondaryAppBar(Colors.black, mode.bgcolor, context, "Checkout"),
        backgroundColor: mode.bgcolor,
        bottomNavigationBar: value == null ? SizedBox.shrink(): bottomFixed(payment, user),
        body: loading == true
            ? Center(
          child: CircularProgressIndicator(),
        )
            : listsOfGateways());
  }
}
