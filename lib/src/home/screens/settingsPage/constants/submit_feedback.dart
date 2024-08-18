import 'dart:convert' show base64Encode, jsonDecode, jsonEncode;
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/widgets.dart' show BuildContext, debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http;
import 'package:orangelist/src/home/widgets/flushbar/custom_flushbar.dart'
    show showCustomFlushBar;

Future<void> submitFeedback({
  required BuildContext context,
  required String title,
  required String body,
  required bool isWeb,
  Uint8List? image,
}) async {
  final String token = dotenv.env['GITHUB_TOKEN']!;
  const String repoOwner = 'singlesoup';
  const String repoName = 'orangelist';

  String imageUrl = '';

  // If the image is provided and it's not a web submission, upload it to Imgur
  if (!isWeb && image != null) {
    imageUrl = await uploadImageToImgur(image, context);
  }

  // Create the issue body
  String issueBody = body;

  // If the image
  if (imageUrl.isNotEmpty) {
    issueBody +=
        '\n\n![User Feedback Image]($imageUrl)'; // Append the image URL to the body
  }

  const url = 'https://api.github.com/repos/$repoOwner/$repoName/issues';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'token $token',
      'Accept': 'application/vnd.github.v3+json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'title': title, 'body': issueBody}),
  );

  if (response.statusCode == 201) {
    // Issue created successfully
    const String msg = 'Feedback submitted successfully!';
    if (context.mounted) {
      showCustomFlushBar(context, msg);
    }
  } else {
    // Handle error
    debugPrint('Failed to submit feedback: ${response.body}');
    const String msg = 'Failed to submit feedback!';
    if (context.mounted) {
      showCustomFlushBar(context, msg);
    }
  }
}

Future<String> uploadImageToImgur(Uint8List image, BuildContext context) async {
  String clientId = dotenv.env['IMGUR_CLIENT_ID']!;
  const String url = 'https://api.imgur.com/3/image';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Client-ID $clientId',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'image': base64Encode(image),
      'type': 'base64',
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['data']['link']; // Return the image URL
  } else {
    String msg = 'Failed to upload image';
    if (context.mounted) {
      showCustomFlushBar(context, msg);
    }
    // throw Exception('msg: ${response.body}');
    ///[NOTE] : Here suppose the total limit given by imgur is hit
    /// then we dont want to stop our feedback we will just move feedback without images.
    return '';
  }
}
