import 'history_items_list.dart';
import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PurchaseHistoryScreen extends StatelessWidget {
  HttpService httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => httpService.fetchPurchaseHistory(),
      catchError: (context, error) {},
      child: Scaffold(
        appBar: customAppBar(context, "Purchase History"),
        backgroundColor: Color(0xFFF1F3F8),
        body: HistoryItemsList(),
      ),
    );
  }
}
