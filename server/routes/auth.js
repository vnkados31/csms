const express = require("express");
const User = require("../models/user");
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');

const authRouter = express.Router();

function generatePassword(name, dob) {
    // Extract the first three letters of the name
    const namePart = name.slice(0, 3).toLowerCase(); // Ensure it's in lowercase
  
    // Extract the day and month from the date of birth
    const dobPart = dob.split('-').slice(0, 2).join('');
  
    // Combine the name and date of birth parts to create the password
    const password = namePart + dobPart;

  
    return password;
  }



//sign up Route
authRouter.post("/api/signup", async function (req,res) {

    try {
        const {name,email,psNumber,dob} = req.body;
        const existingUser = await User.findOne({psNumber});

        if(existingUser) {
            return res.status(400).json({msg: 'User with same PS Number already exists!'});
        }

        var password = generatePassword(name,dob);
        password = password.toString();

        //print(password);
        var hashedPassword = await bcryptjs.hash(password,8);

        let user = new User ({
            name,
            email,
            password : hashedPassword,
            psNumber,
            dob
        });

        user = await user.save();

        res.json(user);


    } catch (e) {
        res.status(500).json({error : e.message});
    }
});

//sign in 

authRouter.post('/api/signin',async (req,res) => {
    try {
        const {psNumber,password} = req.body;

        const user =await User.findOne({psNumber});
        if(!user){
            return res.status(400).json({msg : "User with this PS Number does not exist!"});
        }

        const isMatch =await bcryptjs.compare(password,user.password);

        if(!isMatch) { 
            return res.status(400).json({msg: "Incorrect password."});
        }

        const token = jwt.sign({id: user._id},"passwordKey");
        res.json({token,...user._doc});
        //..user is to add token to user part in json
        // test123
        // gibbrish
    } catch (e) {
        res.status(500).json({error: e.message});
    }

});

authRouter.post('/tokenIsValid', async (req,res) => {
    try {
        const token =req.header('x-auth-token');
        if(!token) return res.json(false);
        const verified = jwt.verify(token,'passwordKey');

        if(!verified) return res.json(false);

        const user = await User.findById(verified.id);

        if(!user) return res.json(false);

        res.json(true);
    } catch (e) {
        res.status(500).json({error : e.message});
    }
});


//get user data
authRouter.get('/', auth , async (req , res) => {
    const user = await User.findById(req.user);
    res.json({...user._doc,token : req.token});
});

module.exports = authRouter

