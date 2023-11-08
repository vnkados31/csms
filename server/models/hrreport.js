const mongoose = require('mongoose');

const couponsBookSchema = new mongoose.Schema ({
     psNumber : {
        type : Number,
        required : true,
        trim : true,
      },            
      date : {
        type : String,
        required : true,
        trim : true,
      },
    
      
});

const CouponsBook = mongoose.model('CouponsBook',couponsBookSchema);
module.exports = {CouponsBook, couponsBookSchema};