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
    ps_number : {
        require : true,
        type : String,
        trim : true,
        
    },
    dob : {
        require : true,
        type : String,
    },
    food_type : {
        type : String,
        default : 'Veg',

    },
    user_type : {
        type : String,
        default : 'user',

    },
    coupons_left : {
        type: String,
        default : '25'
    },
    password : {
        required : true,
        type:String
    }

});

const User = mongoose.model("User", userSchema);
module.exports = User;