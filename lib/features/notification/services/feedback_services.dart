import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/feedback.dart';
import '../../../providers/user_provider.dart';

class FeedServices {
  void feedUser({
    required BuildContext context,
    required String feedText,
    required String ratingText,
    required int psNumber,
    required String date,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      FeedbackReq request = FeedbackReq(
          id: "",
          feedText: feedText,
          ratingText: ratingText,
          psNumber: psNumber,
          today: date);
      http.Response res = await http.post(Uri.parse('$uri/api/sendfeedback'),
          body: request.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Feedback Submitted');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
