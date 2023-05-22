import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../widgets/app_widgets.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
  static const routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: tdBlue,
          elevation: 0,
          title: const Text('About Developer'),
          centerTitle: true,
        ),
        drawer: myDrawer('What To Do', 'App version: 1.0.0', context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy for What To Do\n\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text:
                        'This Privacy Policy explains how [Your App Name] collects, uses, and handles personal information when you use our Flutter to-do app. By using our app, you agree to the collection and use of your information as described in this policy.\n\n',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: '1. Information Collection and Use\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [Specify the types of information you collect, such as names, email addresses, task details, etc.]\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                      text:
                          '- [Explain the purpose of collecting this information, such as task management, personalized features, and app improvement.]\n\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                    text: '2. Data Storage and Security\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [Describe how you store and protect the collected data. For example, mention the use of encryption, secure servers, or other security measures to ensure data confidentiality and integrity.]\n\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                    text: '3. Third-Party Services\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [If your app uses any third-party services like analytics tools, ad networks, or social media integrations, disclose this information. Provide links to their privacy policies and explain how they handle user data.]\n\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                    text: '4. Data Sharing and Disclosure\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [Specify if and when you share user data with third parties, such as advertisers or business partners. Describe the circumstances under which user data might be disclosed, for example, to comply with legal obligations or respond to lawful requests.]\n\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                    text: '5. User Choices and Control\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [Explain how users can access, update, or delete their personal information within the app. Provide instructions on how users can customize their privacy preferences or opt-out of data collection.]\n\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                    text: '6. Policy Updates\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [Specify that the privacy policy may be subject to updates and explain how users will be notified about any changes made.]\n\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                    text: '7. Contact Us\n',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                      text:
                          '- [Provide your contact details, such as an email address or support page, where users can reach out with privacy-related concerns or questions.]\n',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
