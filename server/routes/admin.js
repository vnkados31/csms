const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Qrcode } = require("../models/qrcode");
const { PromiseProvider } = require("mongoose");

// Add product
adminRouter.post("/admin/scan-qr", async (req, res) => {
  try {
    const { name, email, psNumber, vegUsers, nonVegUsers, dietUsers,totalUsers,scannedBy,couponsLeft } = req.body;
    let qrcode = new Qrcode ({
        name,
        email,
        psNumber,
        vegUsers,
        nonVegUsers,
        dietUsers,
        totalUsers,
        scannedBy,
        couponsLeft,
    });
    qrcode = await qrcode.save(); 
    res.json(qrcode);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get all your products
adminRouter.get("/admin/get-scanned-users", admin, async (req, res) => {
  try {
    const qrcode = await Qrcode.find({});
    res.json(qrcode);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// Delete the product

adminRouter.post('/admin/delete-scanned-user', admin , async (req,res) => {
    try {
        const {id} = req.body;
        let qrcode = await Qrcode.findByIdAndDelete(id);
        
        res.json(qrcode);
    } catch (e) {
        res.status(500).json({error : e.message});
    }
})

module.exports = adminRouter;