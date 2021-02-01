import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'instructor_faq_view.dart';

// ignore: must_be_immutable
class InstructorFaqScreen extends StatelessWidget {
  HttpService httpService = new HttpService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => httpService.fetchInstructorFaq(),
      catchError: (context, error) {},
      child: Scaffold(
        appBar: customAppBar(context, "Instructor FAQ"),
        backgroundColor: Color(0xFFF1F3F8),
        body: InstructorFaqView(),
      ),
    );
  }
}
