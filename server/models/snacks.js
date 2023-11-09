const mongoose = require('mongoose');

const snacksSchema = new mongoose.Schema ({
     name : {
        type : String,
        required : true,
     },
     psNumber : {
        type : Number,
        required : true,
      },
      scannedBy : {
        type : Number,
        require : true
      },
      date : {
        type : String,
        require : true,
      }
      

});

const Snacks = mongoose.model('Snacks',snacksSchema);
module.exports = {Snacks, snacksSchema};