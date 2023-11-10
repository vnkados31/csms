const express = require("express");
const User = require("../models/user");


const settingsRouter = express.Router();




settingsRouter.post('/api/change-food-type', async (req, res) => {
    try {

      const { foodType , psNumber } = req.body;
  
      // Validate that foodType is a string
      if (foodType === null || typeof foodType !== 'string' || psNumber === null || typeof psNumber !== 'number') {
        return res.status(400).json({ error: 'Invalid request data' });
      }
      
  
      
      // Find the user by their ID
      const user = await User.findOneAndUpdate({psNumber}, { foodType }, { new: true });
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      return res.json(user);
    } catch (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal server error' });
    }
  });


  settingsRouter.put('/api/change-food-type/:psNumber', async (req, res) => {
    const { foodType} = req.body;
    const psNumber = req.params.psNumber;
  
    try {
      const user = await User.findOne({ psNumber });
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
  
      user.foodType = foodType;
      await user.save();
  
      res.json(user);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Could not update user' });
    }
  });

  settingsRouter.post("/api/deduct-coupons" , async (req, res) => {
 

    const { psNumber, couponsToDeduct} = req.body;
  
    try {
      const user = await User.findOne({ psNumber: psNumber });
        if (!user) {
        return res.status(400).json({ error: 'User not found' });
      }
  
      if (user.couponsLeft < couponsToDeduct) {
        return res.status(400).json({ error: 'Insufficient coupons' });
      }
  
      // Deduct coupons
      user.couponsLeft -= couponsToDeduct;
      await user.save();
  
      return res.status(200).json({ message: 'Coupons deducted successfully' });
    } catch (error) {
      return res.status(500).json({ error: 'Internal server error' });
    }
  });

  settingsRouter.put('/api/add-coupons/:psNumber', async (req, res) => {
  
    const psNumber = req.params.psNumber;
  
    try {
      const user = await User.findOne({ psNumber });
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      
        user.couponsLeft += 25;
  
      await user.save();
  
      res.json(user);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Could not update user' });
    }
  });

  module.exports = settingsRouter