import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wtd/widgets/app_widgets.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  static const routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Colors
    final primaryColor = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.grey.shade800;
    final titleColor = isDark ? Colors.white : Colors.black87;
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
            'About Developer',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: myDrawer('What To Do', 'App version: 1.0.0', context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // Developer Main Profile Card
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Picture Container with border and shadow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withAlpha(100),
                            width: 6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withAlpha(40),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: isDark
                              ? Colors.grey.shade900
                              : Colors.blue.shade50,
                          backgroundImage:
                              const AssetImage('assets/images/habib.jpg'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Developer Name
                      Text(
                        'Khandaker Ahsun Habib',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Developer Role
                      Text(
                        'Mobile App Developer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Organization Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.blue.withAlpha(40)
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.blue.withAlpha(80)
                                : Colors.blue.shade100,
                          ),
                        ),
                        child: Text(
                          'Strivenith Venture Ltd.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Details Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                    child: Text(
                      'Get in Touch',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor.withAlpha(180),
                      ),
                    ),
                  ),
                ),

                // Contact Detail Items
                _buildContactItem(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email Address',
                  value: 'ahsun.csm@gmail.com',
                  iconColor: Colors.blue,
                  isDark: isDark,
                  cardBgColor: cardBgColor,
                  textColor: textColor,
                  titleColor: titleColor,
                  borderColor: borderColor,
                  onTap: () => _launchEmail(),
                ),
                const SizedBox(height: 12),

                _buildContactItem(
                  context,
                  icon: Icons.phone_android_rounded,
                  title: 'Phone Number',
                  value: '+8801308166502',
                  iconColor: Colors.green,
                  isDark: isDark,
                  cardBgColor: cardBgColor,
                  textColor: textColor,
                  titleColor: titleColor,
                  borderColor: borderColor,
                  onTap: () => _launchPhone(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required bool isDark,
    required Color cardBgColor,
    required Color textColor,
    required Color titleColor,
    required Color borderColor,
    required VoidCallback onTap,
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? iconColor.withAlpha(40) : iconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
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
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDark ? Colors.white30 : Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ahsun.csm@gmail.com',
      queryParameters: {
        'subject': 'Inquiry to Developer',
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

  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+8801308166502',
    );
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      debugPrint('Could not launch phone dialer: $e');
    }
  }
}
