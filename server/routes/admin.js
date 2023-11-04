const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Qrcode, qrcodeSchema } = require("../models/qrcode");
const { PromiseProvider } = require("mongoose");
const { MenuItem } = require("../models/menuitem");
const { User } = require("../models/user");

// Add product
adminRouter.post("/admin/scan-qr", async (req, res) => {
  try {
    const { name, email, psNumber, vegUsers, nonVegUsers, dietUsers,totalUsers,scannedBy,couponsLeft,date } = req.body;
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
        date
    });
    qrcode = await qrcode.save(); 



    res.json(qrcode);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// Get all your products
adminRouter.post("/admin/get-scanned-users",admin, async (req, res) => {
  try {
    const { scannedBy , date} = req.body;
    const qrcode = await Qrcode.find({scannedBy,date});
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
});

adminRouter.post('/admin/check-scanned-user', async (req, res) => {
  const { psNumber, date } = req.body;
  try {
    const user = await Qrcode.findOne({ psNumber, date });
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

adminRouter.post('/admin/add-menu-item', admin, async (req,res) => {
      try {

        const { name , day,type} = req.body;
        let menuitem = new MenuItem (
          {
            name : name,
            day : day,
            type : type

          }
        );

        menuitem = await menuitem.save(); 
        res.json(menuitem);
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
});

adminRouter.get("/admin/get-menu-items", admin, async (req, res) => {
  try {
    const menuitems = await MenuItem.find({});
    res.json(menuitems);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/check-food-type", async (req, res) => {
  try {
    const {day , type} = req.body;
    const menuitems = await MenuItem.findOne({day : day, type : type});

    if(menuitems) {
      res.status(200).send('found data with following fields');
    }
    else {
      res.status(400).send('Sorry, cant find that');
    }
   // res.json(menuitems);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


adminRouter.post('/admin/delete-menu-item', admin, async (req,res) => {

  try {
    const {id} = req.body;
    const menuitem = await MenuItem.findByIdAndDelete(id);

    res.status(200).send('Success');
    

  } catch (e) {
    res.status(500).json({error : e.message});
   }
 
});

adminRouter.post('/admin/update-menu-item', async (req,res) => {
  try {
    const {id,name} = req.body;
    const menuitem = await MenuItem.findByIdAndUpdate(id, {name : name});

    res.status(200).send('Success');
    

  } catch (e) {
    res.status(500).json({error : e.message});
   }
}

);

module.exports = adminRouter;