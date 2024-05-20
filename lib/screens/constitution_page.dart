import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ConstitutionPage extends StatelessWidget {
  const ConstitutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PDF(
        fitPolicy: FitPolicy.WIDTH,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          // ignore: avoid_print
          print(error.toString());
        },
        onPageError: (page, error) {
          // ignore: avoid_print
          print('$page: ${error.toString()}');
        },
      ).fromAsset('assets/pdfs/GG.pdf'),
    );
  }
}
