const express = require("express");
const { Feedback } = require("../models/feedback"); // Import Feedback model

const feedbackRouter = express.Router();

feedbackRouter.post('/api/sendfeedback', async (req, res) => {
  try {
    const { feedText, ratingText, psNumber, today } = req.body;

    // Check if feedback already exists for the same psNumber and date
    const existingFeedback = await Feedback.findOne({
      'today': today,
      'feedbacks': {
        $elemMatch: {
          'psNumber': psNumber
        }
      }
    });

    if (existingFeedback) {
      return res.status(422).json("Already Submitted Feedback");
    }

    const feedback = new Feedback({
      today,
      feedbacks: [{
        feedText,
        ratingText,
        psNumber,
      }],
    });

    await feedback.save(); // Save the new feedback
    res.status(201).json("Feedback Submitted successfully");
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});



module.exports = feedbackRouter;