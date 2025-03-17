import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000022),
      appBar: AppBar(
        backgroundColor: Color(0xff000022),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Privacy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. Introduction'),
              _buildContent(
                'Welcome to 5FIT! Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal data when you use our app.',
              ),
              _buildSectionTitle('2. Data We Collect'),
              _buildBulletPoint('Personal Information: Name, email, age, and profile details (if provided).'),
              _buildBulletPoint('Health & Fitness Data: Workout history, calorie tracking, and progress reports.'),
              _buildBulletPoint('Device & Usage Data: IP address, app activity, and device type.'),
              _buildSectionTitle('3. How We Use Your Data'),
              _buildCheckBulletPoint('Improve your fitness experience.'),
              _buildCheckBulletPoint('Track your progress and provide personalized recommendations.'),
              _buildCheckBulletPoint('Send important updates and notifications.'),
              _buildCheckBulletPoint('Enhance app performance and security.'),
              _buildSectionTitle('4. Data Sharing & Security'),
              _buildWarningBulletPoint('We DO NOT sell your data to third parties.'),
              _buildBulletPoint('Analytics providers (e.g., Google Analytics) to improve app performance.'),
              _buildBulletPoint('Health tracking integrations (Apple Health or Google Fit).'),
              _buildContent('We use encryption and security measures to protect your information.'),
              _buildSectionTitle('5. Your Rights'),
              _buildBulletPoint('Access, edit, or delete your data.'),
              _buildBulletPoint('Request a copy of your stored information.'),
              _buildBulletPoint('Opt-out of certain data collection (e.g., location tracking).'),
              _buildSectionTitle('6. Cookies & Tracking'),
              _buildContent('We may use cookies and tracking technologies to enhance your experience. You can disable these in your device settings.'),
              _buildSectionTitle('7. Policy Updates'),
              _buildContent('We may update this Privacy Policy from time to time. We’ll notify you of any major changes within the app.'),
              _buildSectionTitle('8. Contact Us'),
              _buildContent('If you have any questions about this Privacy Policy, contact us at:'),
              _buildContactEmail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContent(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        children: [
          Icon(Icons.check_box, color: Colors.greenAccent, size: 16),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.exclamationTriangle, color: Colors.red, size: 16),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactEmail() {
    return Row(
      children: [
        Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white, size: 16),
        SizedBox(width: 10),
        Text(
          'support@5fit.com',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
