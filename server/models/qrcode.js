const mongoose = require('mongoose');

const qrcodeSchema = new mongoose.Schema ({
  date: {
    type: String,
    required: true,
    unique: true,
},
  scannedUsers: [{
    name: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        trim: true,
    },
    psNumber: {
        type: Number,
        required: true,
    },
    vegUsers: {
        type: Number,
        required: true,
    },
    nonVegUsers: {
        type: Number,
        required: true,
    },
    dietUsers: {
        type: Number,
        required: true,
    },
    totalUsers: {
        type: Number,
        required: true,
    },
    scannedBy: {
        type: Number,
        required: true,
    },
    couponsLeft: {
        type: Number,
        required: true,
    },
}],
      
});

const Qrcode = mongoose.model('Qrcode',qrcodeSchema);
module.exports = {Qrcode, qrcodeSchema};