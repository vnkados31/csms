const express = require("express");
const snacksRouter = express.Router();
const admin = require("../middlewares/admin");


const { Snacks, snacksSchema } = require("../models/snacks");

// Add Scanned User

snacksRouter.post("/snacks/save-user", async (req, res) => {
  try {
      const { name, psNumber, scannedBy, date } = req.body;


      // Find the document for the provided date
      const snacksDocument = await Snacks.findOne({ date });

      if (snacksDocument) {
          // If the document for the date exists, add the scanned user to the scannedUsers array
          snacksDocument.scannedUsers.push({
              name,
              psNumber,
              scannedBy,
          });

          // Save the updated document
          await snacksDocument.save();

          res.json(snacksDocument);
      } else {
          // If the document for the date doesn't exist, create a new one and add the scanned user
          const newSnacksDocument = new Snacks({
              date,
              scannedUsers: [{
                  name,
                  psNumber,
                  scannedBy,
              }],
          });

          // Save the new document
          const savedSnacksDocument = await newSnacksDocument.save();
          res.json(savedSnacksDocument);
      }
  } catch (e) {
      console.error(e);
      res.status(500).json({ error: 'Server error' });
  }
});



// Get all your products
snacksRouter.post("/snacks/get-scanned-snacks", admin, async (req, res) => {
  try {
      const { scannedBy, date } = req.body;

      // Find the document for the provided date
      const snacksDocument = await Snacks.findOne({ date });

      if (snacksDocument) {
          // If the document for the date exists, filter scanned users based on scannedBy
          const scannedUsers = snacksDocument.scannedUsers.filter(user => user.scannedBy === scannedBy);

          res.json(scannedUsers);
      } else {
          // If the document for the date doesn't exist, respond with an empty array
          res.json([]);
      }
  } catch (e) {
      console.error(e);
      res.status(500).json({ error: 'Server error' });
  } 

});
// Delete the product


snacksRouter.post('/snacks/check-scanned-user', async (req, res) => {
  const { psNumber, date } = req.body;

  try {

      // Find the document for the provided date
      const snacksDocument = await Snacks.findOne({ date });

      if (snacksDocument) {
          // If the document for the date exists, search for the user in the scannedUsers array
          const user = snacksDocument.scannedUsers.find(u => u.psNumber === psNumber);

          if (user) {
              res.json({ found: true, user });
          } else {
              res.json({ found: false, date });
          }
      } else {
          // If the document for the date doesn't exist, the user is not found
          res.json({ found: false, date });
      }
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Server error' });
  } 
});



module.exports = snacksRouter;