import '../Widgets/appbar.dart';
import 'about_us_view.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AboutUsScreen extends StatelessWidget {
  HttpService httpService = new HttpService();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return FutureProvider(
      create: (context) => httpService.fetchAboutUs(),
      catchError: (context, error) {},
      child: Scaffold(
        appBar: customAppBar(context, "About Us"),
        backgroundColor: mode.bgcolor,
        body: AboutUsView(),
      ),
    );
  }
}
