const mongoose = require('mongoose');

const menuItemSchema = new mongoose.Schema ({
     name : {
        type : String,
        required : true,
        trim : true,
      },
      day : {
        type : String,
        required : true,
        trim : true,
      },
      type : {
        type : String,
        required : true,
        trim : true,
      },
    
      
});

const MenuItem = mongoose.model('MenuItem',menuItemSchema);
module.exports = {MenuItem, menuItemSchema};