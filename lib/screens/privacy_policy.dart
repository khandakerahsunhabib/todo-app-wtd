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
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy for What To Do\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[700]),
                  ),
                  TextSpan(
                    text:
                        "This Privacy Policy explains how What To Do collects, uses, and handles personal information when you use our Flutter to-do app. By using our app, you agree to the collection and use of your information as described in this policy.\n\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(height: 1.4, color: Colors.grey.shade700),
                  ),
                  TextSpan(
                    text: 'Information Collection and Use\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[700]),
                  ),
                  TextSpan(
                    text:
                        'In this application we shall not collect any user informations. Here we have used local database, so any information you save in this app will store in your phone storage.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(height: 1.4, color: Colors.grey.shade700),
                  ),
                  TextSpan(
                    text: 'Third-Party Services\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[700]),
                  ),
                  TextSpan(
                    text:
                        'In this application we shall not collect any user informations. Here we have used local database, so any information you save in this app will store in your phone storage.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(height: 1.4, color: Colors.grey.shade700),
                  ),
                  TextSpan(
                    text: 'Data Sharing and Disclosure\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[700]),
                  ),
                  TextSpan(
                    text:
                        'In this application we shall not collect any user informations. Here we have used local database, so any information you save in this app will store in your phone storage.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(height: 1.4, color: Colors.grey.shade700),
                  ),
                  TextSpan(
                    text: 'Contact Us\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blue[700]),
                  ),
                  TextSpan(
                    text:
                        'In this application we shall not collect any user informations. Here we have used local database, so any information you save in this app will store in your phone storage.\n\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(height: 1.4, color: Colors.grey.shade700),
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
