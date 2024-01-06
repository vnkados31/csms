const mongoose = require('mongoose');

const snacksSchema = new mongoose.Schema({
    date: {
        type: String,
        required: true,
    },
    scannedUsers: [{
        name: {
            type: String,
            required: true,
        },
        psNumber: {
            type: Number,
            required: true,
        },
        scannedBy: {
            type: Number,
            required: true,
        },
    }],
});

const Snacks = mongoose.model('Snacks', snacksSchema);
module.exports = { Snacks, snacksSchema };