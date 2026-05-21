import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_widgets.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
  static const routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme Colors
    final primaryColor = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.grey.shade800;
    final subtitleColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: isDark ? null : Colors.blue,
          elevation: 0,
          title: const Text(
            'Privacy Policy',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: myDrawer('What To Do', 'App version: 1.0.0', context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Security Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.blue.shade900.withAlpha(150), Colors.purple.shade900.withAlpha(150)]
                        : [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.blue.shade800.withAlpha(100) : Colors.blue.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: isDark ? Colors.blue.shade900.withAlpha(200) : Colors.white,
                      child: Icon(
                        Icons.shield_outlined,
                        color: primaryColor,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Privacy Policy for What To Do',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your privacy is our priority. We design our app to keep your personal data completely private and secure on your own device.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: isDark ? Colors.white70 : Colors.blue.shade900.withAlpha(200),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Overview Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'At "What to do (WTD)," we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, and safeguard any data you provide while using our todo app. By using our app, you agree to the terms and practices described in this policy.',
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.5,
                    color: subtitleColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Policy Section Cards
              _buildPolicyCard(
                context,
                title: 'Information Collection & Use',
                icon: Icons.info_outline_rounded,
                iconColor: Colors.blue,
                description:
                    "We do not collect any personal information or user data through the 'What to do (WTD)' app. Any tasks or information you save within the app are stored locally on your device's storage. We do not have access to or collect any of this data.",
                isDark: isDark,
                cardBgColor: cardBgColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              _buildPolicyCard(
                context,
                title: 'Third-Party Services',
                icon: Icons.api_rounded,
                iconColor: Colors.purple,
                description:
                    'In this application we shall not collect any user information. Here we have used local database, so any information you save in this app will store in your phone storage.',
                isDark: isDark,
                cardBgColor: cardBgColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              _buildPolicyCard(
                context,
                title: 'Local Database Storage',
                icon: Icons.storage_rounded,
                iconColor: Colors.green,
                description:
                    'Our app utilizes a local database, specifically Hive, to securely store your tasks and other related information. This ensures that all your data remains within the confines of your device, providing you with full control and privacy.',
                isDark: isDark,
                cardBgColor: cardBgColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              _buildPolicyCard(
                context,
                title: 'Security Measures',
                icon: Icons.security_rounded,
                iconColor: Colors.orange,
                description:
                    'We take reasonable measures to protect the security and integrity of your data. We have implemented industry-standard practices to safeguard the app and its local database from unauthorized access or data breaches.',
                isDark: isDark,
                cardBgColor: cardBgColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              _buildPolicyCard(
                context,
                title: "Children's Privacy",
                icon: Icons.child_care_rounded,
                iconColor: Colors.teal,
                description:
                    'The "What to do (WTD)" app is not intended for use by individuals under the age of 13. We do not knowingly collect any personal information from children. If we become aware that a child under 13 has provided us with personal information, we will promptly delete it from our records.',
                isDark: isDark,
                cardBgColor: cardBgColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              _buildPolicyCard(
                context,
                title: "Changes to Privacy Policy",
                icon: Icons.update_rounded,
                iconColor: Colors.indigo,
                description:
                    'We may update our Privacy Policy from time to time. Any changes will be reflected within the app or on our website. It is your responsibility to review this policy periodically and ensure that you agree with any modifications made.',
                isDark: isDark,
                cardBgColor: cardBgColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 24),

              // Contact Us & Bottom Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.blue.shade50.withAlpha(120),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.blue.shade100,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.blue,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Have Questions or Feedback?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If you have any questions or concerns regarding our Privacy Policy or data practices, please get in touch with us.',
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _launchEmail(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.email_outlined),
                      label: const Text(
                        'Email Us',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required String description,
    required bool isDark,
    required Color cardBgColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? iconColor.withAlpha(40) : iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          children: [
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ahsun.csm@gmail.com',
      queryParameters: {
        'subject': 'What To Do App Privacy Inquiry',
      },
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      debugPrint('Could not launch email client: $e');
    }
  }
}
