import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class SearchAddressScreen extends StatelessWidget {
  static String get routeName => 'search_address';
  const SearchAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: KpostalView(
        title: tr('search_address_title'),
      ),
    );
  }
}
