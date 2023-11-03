import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../services/feedback_services.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notification-screen';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime now = DateTime.now();
  String? today;
  double _rating = 1.0;
  final FeedServices feedServices = FeedServices();
  final TextEditingController _feedbackController = TextEditingController();

  void sendFeedback(double psNumber) {
    feedServices.feedUser(
      context: context,
      feedText: _feedbackController.text,
      ratingText: _rating.toString(),
      psNumber: psNumber,
      date: '${now.year}-${now.month}-${now.day}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Photo in Circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2.0),
                  image: const DecorationImage(
                    image: AssetImage('asset/images/feedback.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Text: How was today's food
              const SizedBox(height: 20),
              const Text(
                'How was today\'s food?',
                style: TextStyle(fontSize: 18),
              ),

              // Rating Bar
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, index) {
                  String emoji = '';

                  switch (index) {
                    case 0:
                      emoji = '😠'; // Angry emoji
                      break;
                    case 1:
                      emoji = '😒'; // Neutral emoji
                      break;
                    case 2:
                      emoji = '😐'; // Happy emoji
                      break;
                    case 3:
                      emoji =
                          '🙂'; // Adjust this to another happy emoji or use a different one
                      break;
                    case 4:
                      emoji =
                          '😊'; // Adjust this to another happy emoji or use a different one
                      break;
                    default:
                      break;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1.0; // Set the selected rating
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        text: emoji,
                        style: TextStyle(
                          fontSize: _rating == index + 1.0 ? 30.0 : 24.0,
                        ),
                      ),
                    ),
                  );
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),

              // TextBox for Custom Review and Feedback
              const SizedBox(height: 20),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your feedback here...',
                  border: OutlineInputBorder(),
                ),
              ),

              // Submit Button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  sendFeedback(user.psNumber);
                },
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
