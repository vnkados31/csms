const mongoose = require('mongoose');

const feedbackSchema= new mongoose.Schema({
    feedText:{
        type:String,

    },
    ratingText:{
        type:String,
        required:true
        
    },
    psNumber:{
        type:Number,
        required:true
    },
    today:{
        type:String,
        required:true
    },
});

const Feedback = mongoose.model('Feedback',feedbackSchema);
module.exports = {Feedback, feedbackSchema};