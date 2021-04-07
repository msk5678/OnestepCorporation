import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

sendMail(int schollAuthFlag,
    [String checkPassword = "", String universityEmail = ""]) async {
  String smtpServerName = 'smtp.gmail.com';
  int smtpPort = 465;
  String smtpUserName = 'leedool3003@gmail.com';
  String smtpPassword = 'alstjsdl421!';

  final smtpServer = SmtpServer(
    smtpServerName,
    port: smtpPort,
    ssl: true,
    ignoreBadCertificate: false,
    allowInsecure: false,
    username: smtpUserName,
    password: smtpPassword,
  );

  final message = Message()
    ..from = Address('leedool3003@gmail.com', 'leedool3003@gmail.com')
    ..recipients.add('5414030@stu.kmu.ac.kr')
    ..subject =
        'Test Dart Mailer library :: 😀 :: ${DateTime.now().add(Duration(hours: 9))}' // title
    ..html =
        "<h1>Test</h1>\n<p>Hey! Here's some $checkPassword</p>\n본 인증 코드는 5분동안 유효합니다. "; // body of the email
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  // // schollAuthFlag = 1 이면 학교인증 sendMail
  // // schollAuthFlag = 0 이면 학교인증 아닌 sendMail

  // // 회사 공용 email 들어가야하고
  // String _username = 'leedool3003@gmail.com';
  // String _password = 'alstjsdl421!';

  // // ignore: deprecated_member_use
  // final smtpServer = gmail(_username, _password);

  // // 학교인증 sendMail
  // if (schollAuthFlag == 1) {
  //   final message = Message()
  //     ..from = Address(_username)
  //     ..recipients
  //         .add('5414030@stu.kmu.ac.kr') // 받는사람 email -> universityEmail 로 받아옴
  //     // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  //     // ..bccRecipients.add(Address('bccAddress@example.com'))
  //     ..subject =
  //         'Test Dart Mailer library :: 😀 :: ${DateTime.now().add(Duration(hours: 9))}' // title
  //     // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
  //     ..html =
  //         "<h1>Test</h1>\n<p>Hey! Here's some $checkPassword</p>\n본 인증 코드는 5분동안 유효합니다. "; // body of the email
  //   print("@@@@@@@@@@@@@ 여기옴?");
  //   try {
  //     // final sendReport = await send(message, _smtpServer,timeout: Duration(hours: 60));
  //     final sendReport =
  //         await send(message, smtpServer, timeout: Duration(seconds: 15));
  //     print('Message sent: ' + sendReport.toString());
  //   } on MailerException catch (e) {
  //     print('Message not sent.');
  //     for (var p in e.problems) {
  //       print('Problem: ${p.code}: ${p.msg}');
  //     }
  //   }
  // }
  // // 학교인증 아닌 sendMail
  // else {
  //   print("학교인증 아닌 sendMail");
  // }

  // // var connection = PersistentConnection(_smtpServer);
  // // await connection.send(message);
  // // connection.close();
}
