import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;

  const RateInitWidget({
    super.key,
    required this.builder,
  });

  @override
  State<RateInitWidget> createState() => _RateInitWidgetState();
}

class _RateInitWidgetState extends State<RateInitWidget> {
  RateMyApp? rateMyApp;

  static const playStoreId = "com.norlaxn.lidPrufungstraining";
  static const appStoreId = "";

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
        googlePlayIdentifier: playStoreId,
        appStoreIdentifier: appStoreId,
        minDays: 0,
        minLaunches: 2,
        remindDays: 2,
        remindLaunches: 3,
      ),
      onInitialized: (context, rateMyApp) {
        setState(() => this.rateMyApp = rateMyApp);
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: 'Rate This App',
            message: 'Do you like this app? Please leave a rating',
            starRatingOptions: const StarRatingOptions(initialRating: 5),
            actionsBuilder: actionsBuilder,
          );
        }
      },
      builder: (context) => rateMyApp == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : widget.builder(rateMyApp!),
    );
  }

  List<Widget> actionsBuilder(BuildContext context, double? stars) =>
      stars == null ? [buildCancelButton()] : [buildOkButton(stars), buildCancelButton()];

  Widget buildOkButton(double stars) => TextButton(
        child: const Text('OK'),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks for your feedback!')),
          );

          final launchAppStore = stars >= 4;

          const event = RateMyAppEventType.rateButtonPressed;

          await rateMyApp!.callEvent(event);

          if (launchAppStore) {
            rateMyApp!.launchStore();
          }
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );

  Widget buildCancelButton() => RateMyAppNoButton(
        rateMyApp!,
        text: 'CANCEL',
      );
}
