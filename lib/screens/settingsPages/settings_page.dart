import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:leben_in_deutschland/cache/dark_mode_cache_manager.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/extensions/context_extension.dart';
import 'package:leben_in_deutschland/screens/settingsPages/other_apps_page.dart';
import 'package:leben_in_deutschland/widgets/settingsPageWidgets/setting_menu_item_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DarkModeCacheManager _darkModeCacheManager = DarkModeCacheManager();
  bool? isDark;

  SMIInput? _bump;

  @override
  void initState() {
    super.initState();
    isDark = _darkModeCacheManager.getDarkMode();
  }

  void _hitBump() => _bump?.change(!isDark!);

  @override
  Widget build(BuildContext context) {
    String urlStore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.norlaxn.lidPrufungstraining"
        : "https://apps.apple.com/us/story/id1310535450?itscg=10000&itsct=";

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: GridView.extent(
          shrinkWrap: true,
          padding: EdgeInsets.all(context.lowValue),
          mainAxisSpacing: context.lowValue,
          crossAxisSpacing: context.lowValue,
          maxCrossAxisExtent: context.width * 0.5,
          childAspectRatio: 1,
          children: [
            GestureDetector(
              onTap: () {
                _darkModeCacheManager.putDarkMode(!isDark!);
                isDark = !isDark!;
                _hitBump();
              },
              child: RiveAnimation.asset(
                'assets/animations/onoff-switch.riv',
                fit: BoxFit.fill,
                onInit: _onRiveInit,
              ),
            ),
            SettingMenuItemButton(
              onpressed: () {
                _launchURL(urlStore);
              },
              icon: Icons.star,
              iconColor: Colors.yellow,
              title: rateUsButtonTitle,
            ),
            SettingMenuItemButton(
              onpressed: () {
                BetterFeedback.of(context).show((feedback) async {
                  final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

                  final Email email = Email(
                    body: feedback.text,
                    subject: emailSubject,
                    recipients: [emailAddress],
                    attachmentPaths: [screenshotFilePath],
                    isHTML: false,
                  );
                  await FlutterEmailSender.send(email);
                });
              },
              icon: Icons.feedback,
              iconColor: Colors.green,
              title: feedbackButtonTitle,
            ),
            // SettingMenuItemButton(
            //   onpressed: () {
            //     final snackBar = SnackBar(
            //       content: const Text('Remove Ads unavailable!'),
            //       action: SnackBarAction(
            //         label: 'OK',
            //         onPressed: () {},
            //       ),
            //     );
            //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //   },
            //   icon: Icons.do_not_disturb,
            //   iconColor: Colors.red,
            //   title: removeAdsButtonTitle,
            // ),
            SettingMenuItemButton(
              onpressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherAppsPage(),
                  )),
              icon: Icons.apps,
              iconColor: Colors.blue,
              title: otherAppsButtonTitle,
            ),
            // ElevatedButton(
            //   onPressed: () => _launchURL(buyMeCoffeeUrl),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Expanded(
            //           flex: 3,
            //           child: Padding(
            //             padding: EdgeInsets.all(context.normalValue),
            //             child: Image.asset(
            //               buyMeCoffeeImageUrl,
            //               fit: BoxFit.values[0],
            //             ),
            //           )),
            //       Expanded(
            //         flex: 2,
            //         child: Text("Buy Me A Coffee",
            //             textAlign: TextAlign.center,
            //             style: context.theme.primaryTextTheme.headlineSmall),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);

    _bump = controller.findInput<bool>('On/Of');
    _bump!.change(isDark);
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url ';
  }

  Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
