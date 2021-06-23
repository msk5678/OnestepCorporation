import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:device_apps/device_apps.dart';

sendEmailAuth([
  String checkPassword = "",
  String universityEmail = "",
]) async {
  // schollAuthFlag = 1 이면 학교인증 sendMail
  // schollAuthFlag = 2 이면 증명서
  print("checkPassword = ${checkPassword}");
  // 회사 공용 email 들어가야하고
  String smtpUserName = 'legendstarthelp@gmail.com';
  String smtpPassword = 'rmflsqlf123';

  final _smtpServer = gmail(smtpUserName, smtpPassword);

  final message = Message()
    ..from = Address(smtpUserName)
    ..recipients.add('$universityEmail') // 받는사람 email -> universityEmail 로 받아옴
    ..subject = 'Onestep 학교이메일 인증코드.' // title
    ..html =
        "<h1>Onestep</h1>\n<p> 인증코드는 $checkPassword 입니다.</p>\n본 인증 코드는 5분동안 유효합니다. "; // body of the email
  try {
    final sendReport = await send(message, _smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    print(e.problems);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

// newSendTest() async {
//   const GMAIL_SCHEMA = 'com.google.android.gm';

//   final bool gmailinstalled = await DeviceApps.isAppInstalled(GMAIL_SCHEMA);
//   print("gmailinstalled = ${gmailinstalled}");

//   if (gmailinstalled) {
//     final MailOptions mailOptions = MailOptions(
//       body: 'a long body for the email <br> with a subset of HTML',
//       subject: 'the Email Subject',
//       recipients: ['leedool3003@naver.com'],
//       isHTML: true,
//       // bccRecipients: ['other@example.com'],
//       // ccRecipients: ['third@example.com'],
//       // attachments: [
//       //   'path/to/image.png',
//       // ],
//       appSchema: GMAIL_SCHEMA,
//     );
//     await FlutterMailer.send(mailOptions);
//   }
// }

sendCertificateAuth([
  String certificateURL = "",
  String storageNum = "",
]) async {
  // print("@@@@@@@@@@@@@@@@@@@@@@ url = $certificateURL num = $storageNum");
  // String smtpUserName = 'leedool3003@gmail.com';
  // String smtpPassword = 'alstjsdl421!';

  // final _smtpServer = gmail(smtpUserName, smtpPassword);

  // final message = Message()
  //   ..from = Address(smtpUserName)
  //   ..recipients.add('leedool3003@naver.com')
  //   ..subject =
  //       'Test Dart Mailer library :: 😀 :: ${DateTime.now().add(Duration(hours: 9))}' // title
  //   ..html =
  //       "<h1>Test</h1>\n<p>Hey! Here's url $certificateURL</p>\n storageNum = $storageNum"; // body of the email
  // try {
  //   final sendReport = await send(message, _smtpServer);
  //   print('Message sent: ' + sendReport.toString());
  // } on MailerException catch (e) {
  //   print('Message not sent.');
  //   for (var p in e.problems) {
  //     print('Problem: ${p.code}: ${p.msg}');
  //   }
  // }
}
