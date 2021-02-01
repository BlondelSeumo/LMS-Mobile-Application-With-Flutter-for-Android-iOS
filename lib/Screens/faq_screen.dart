import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'faq_view.dart';

// ignore: must_be_immutable
class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  HttpService httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => httpService.fetchUserFaq(),
      catchError: (context, error) {},
      child: Scaffold(
        appBar: customAppBar(context, "FAQ"),
        backgroundColor: Color(0xFFF1F3F8),
        body: FaqView(),
      ),
    );
  }
}
