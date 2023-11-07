const mongoose = require('mongoose')


const userSchema = mongoose.Schema({

    name : {
        require : true,
        type : String,
        trim : true
    },
    email : {
        require : true,
        type : String,
        trim  :true,
        validate : {
            validator : (value) => {
                const re = /^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$/;
                 return value.match(re);
            }
        }
    },
    psNumber : {
        require : true,
        type : Number,
        trim : true,
        
    },
    dob : {
        require : true,
        type : String,
    },
    foodType : {
        type : String,
        default : 'Veg',

    },
    userType : {
        type : String,
        default : 'user',

    },
    couponsLeft : {
        type: Number,
        default : 25
    },
    password : {
        required : true,
        type:String
    }

});

const User = mongoose.model("User", userSchema);
module.exports = User;