const express = require("express");
const { Qrcode } = require("../models/qrcode"); 
const { Snacks } = require("../models/snacks"); 

const countRouter = express.Router();


// API endpoint to get day-wise counts
countRouter.get('/user-counts/lunch', async (req, res) => {
  try {
    const { date1, date2 } = req.query;

    // Ensure date1 and date2 are provided
    if (!date1 || !date2) {
      return res.status(400).json({ error: 'Both date1 and date2 are required parameters.' });
    }

    // Query MongoDB for the specified date range
    const results = await Qrcode.aggregate([
      {
        $match: {
          date: { $gte: date1, $lte: date2 },
        },
      },
      {
        $unwind: '$scannedUsers',
      },
      {
        $group: {
          _id: null, // Group all documents into one
          vegUsers: { $sum: '$scannedUsers.vegUsers' },
          nonVegUsers: { $sum: '$scannedUsers.nonVegUsers' },
          dietUsers: { $sum: '$scannedUsers.dietUsers' },
        },
      },
    ]);

    

    // Check if results is not empty
    if (results.length > 0) {
      const { vegUsers, nonVegUsers, dietUsers } = results[0];
      console.log(`vegUsers ${results[0]}`);

      res.json({ vegUsers, nonVegUsers, dietUsers });
    } else {
      // Handle the case where no data is found
     // console.log(`nvegUsers ${vegUsers}`);
      res.json({ vegUsers: 0, nonVegUsers: 0, dietUsers: 0 });
      
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



countRouter.get('/user-counts/snacks', async (req, res) => {
  try {
      const { date1, date2 } = req.query;

      // Validate input
      if (!date1 || !date2) {
          return res.status(400).json({ error: 'Invalid input. Please provide date1 and date2.' });
      }

      // Find documents within the specified date range
      const result = await Snacks.aggregate([
          {
              $match: {
                  date: { $gte: date1, $lte: date2 }
              }
          },
          {
              $project: {
                  scannedUsersCount: { $size: "$scannedUsers" }
              }
          }
      ]);

      console.log(`result ${result}`);

      res.status(200).json({ message: 'Scanned users count retrieved successfully', result });
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
  }
});


  module.exports = countRouter;
  

  