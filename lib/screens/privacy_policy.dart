import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
  static const routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('Privacy Policy'),
          centerTitle: true,
        ),
        drawer: myDrawer('What To Do', 'App version: 1.0.0', context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy for What To Do\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        "At 'What to do (WTD),' we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, and safeguard any data you provide while using our todo app. By using our app, you agree to the terms and practices described in this policy.\n\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: '>>| Information Collection and Use:\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        "We do not collect any personal information or user data through the 'What to do (WTD)' app. Any tasks or information you save within the app are stored locally on your device's storage. We do not have access to or collect any of this data.\n\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: '>>| Third-Party Services:\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        'In this application we shall not collect any user informations. Here we have used local database, so any information you save in this app will store in your phone storage.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: '>>| Local Database Storage:\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        'Our app utilizes a local database, specifically Hive, to securely store your tasks and other related information. This ensures that all your data remains within the confines of your device, providing you with full control and privacy.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: '>>| Security Measures:\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        'We take reasonable measures to protect the security and integrity of your data. We have implemented industry-standard practices to safeguard the app and its local database from unauthorized access or data breaches.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: ">>| Children's Privacy:\n",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        'The "What to do (WTD)" app is not intended for use by individuals under the age of 13. We do not knowingly collect any personal information from children. If we become aware that a child under 13 has provided us with personal information, we will promptly delete it from our records.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: ">>| Changes to Privacy Policy:\n",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        'We may update our Privacy Policy from time to time. Any changes will be reflected within the app or on our website. It is your responsibility to review this policy periodically and ensure that you agree with any modifications made.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: '>>| Contact Us:\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[600]),
                  ),
                  TextSpan(
                    text:
                        'If you have any questions or concerns regarding our Privacy Policy or the data practices of the "What to do (WTD)" app, please contact us at ahsunhabib96bd@gmail.com.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text:
                        'By using the "What to do (WTD)" app, you acknowledge that you have read and understood this Privacy Policy and agree to its terms. Your continued use of the app constitutes your acceptance of any updates or modifications to this policy.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.4, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
