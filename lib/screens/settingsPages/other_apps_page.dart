import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherAppsPage extends StatelessWidget {
  OtherAppsPage({super.key});

  final String bbAppUrl = Platform.isAndroid
      ? "https://play.google.com/store/apps/details?id=com.bayrak.bayrakBulmaca"
      : "https://apps.apple.com/us/app/bayrak-bulmaca/id6450397812";

  final String bbLogoUrl = "assets/logos/bb_logo.jpeg";
  final String bbTitle = "FLAG GUESSER";
  final String bbDesc = "Is it difficult for you to decide?";

  final String spinAppUrl = Platform.isAndroid
      ? "https://play.google.com/store/apps/details?id=com.desicion.spinner"
      : "https://play.google.com/store/apps/details?id=com.desicion.spinner";

  final String spinAppLogoUrl = "assets/logos/spin_app_logo.jpeg";
  final String spinAppTitle = "DECISION SPINNER";
  final String spinAppDesc = "Spin And Decide!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          _buildOtherAppCard(bbAppUrl, bbLogoUrl, bbTitle, bbDesc),
          _buildOtherAppCard(spinAppUrl, spinAppLogoUrl, spinAppTitle, spinAppDesc)
        ],
      ),
    );
  }

  GestureDetector _buildOtherAppCard(String appUrl, String logoUrl, String title, String desc) {
    return GestureDetector(
      onTap: () => _launchURL(appUrl),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  logoUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(title),
                subtitle: Text(desc),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url ';
  }
}
