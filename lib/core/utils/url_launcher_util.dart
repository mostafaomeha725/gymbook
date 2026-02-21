// import 'package:flutter/widgets.dart';

// class UrlLauncherUtil {
//   static Future<void> launchAnyUrl(String urlString) async {
//     final Uri url = Uri.parse(urlString);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $urlString';
//     }
//   }

//   static Future<void> launchPhone(String phoneNumber) async {
//     final Uri url = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $phoneNumber';
//     }
//   }

//   static Future<void> launchEmail(String postEmail) async {
//     Uri email = Uri(
//       scheme: 'mailto',
//       path: postEmail,
//       query: Uri.encodeQueryComponent('subject=Testing subject'),
//     );
//     bool canLaunch = await canLaunchUrl(email);
//     debugPrint('Can launch email: $canLaunch'); // Debug line
//     await launchUrl(email, mode: LaunchMode.externalApplication);

//     if (canLaunch) {
//     } else {
//       throw Exception('Could not launch $email');
//     }
//   }

//   static Future<void> launchWhatsApp({
//     required String phone,
//     required String message,
//   }) async {
//     final Uri whatsappUri = Uri.parse(
//       "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
//     );

//     bool canLaunchWhatsApp = await canLaunchUrl(whatsappUri);
//     debugPrint('Can launch WhatsApp: $canLaunchWhatsApp'); // Debug line

//     if (canLaunchWhatsApp) {
//       await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
//     } else {
//       throw Exception('Could not launch WhatsApp');
//     }
//   }
// }
