const express = require("express");
const snacksRouter = express.Router();
const admin = require("../middlewares/admin");


const { Snacks, snacksSchema } = require("../models/snacks");

// Add product
snacksRouter.post("/snacks/save-user", async (req, res) => {
  try {
    const {name , psNumber ,scannedBy, date  } = req.body;
    let user = new Snacks ({
        name,
        psNumber,
        scannedBy ,
        date
        
    });
    user = await user.save(); 

    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



// Get all your products
snacksRouter.post("/snacks/get-scanned-users",admin, async (req, res) => {
  try {
    const { scannedBy , date} = req.body;
    const users = await Snacks.find({scannedBy,date});
    res.json(users);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// Delete the product

snacksRouter.post('/snacks/check-scanned-user', async (req, res) => {
  const { psNumber, date } = req.body;
  try {
    const user = await Snacks.findOne({ psNumber, date });
    if (user) {
      res.json({ found: true, user });
    } else {
      res.json({ found: false,date:date });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


module.exports = snacksRouter;