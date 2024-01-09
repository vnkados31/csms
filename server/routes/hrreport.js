const express = require('express');
const mongoose = require('mongoose');
const ExcelJS = require('exceljs');
const nodemailer = require('nodemailer');
const bodyParser = require('body-parser');
const { CouponsBook } = require("../models/hrreport");

const hrrouter = express();


// Define the CouponsBook schema and model


// API route to generate the Excel report and send it via email
hrrouter.post('/hr/generate-report-and-send-email', async (req, res) => {
  try {
    const {date1,date2,email} = req.body;
    // Fetch entries within the date range
    // const startDate = new Date('2023-01-01');
    // const endDate = new Date('2023-12-31');
    
    const entries = await CouponsBook.find({
      date: { $gte: date1, $lte: date2 },
    });

    // Calculate the count of couponsBook entries for each psNumber
    const entriesByPsNumber = entries.reduce((acc, entry) => {
      const psNumber = entry.psNumber;
      acc[psNumber] = (acc[psNumber] || 0) + 1;
      return acc;
    }, {});

    // Create an Excel file
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('CouponsBook Data');

    // Add headers to the worksheet
    worksheet.addRow(['psNumber', 'Date', 'couponsBookCount']);

    // Add data to the worksheet
    for (const entry of entries) {
      const psNumber = entry.psNumber;
      const date = entry.date;
    //  const couponsBookCount = entriesByPsNumber[psNumber] || 0;
      const couponsBookCount = 1;
      worksheet.addRow([psNumber, date, couponsBookCount]);
    }

    // Send the Excel file via email

    const transporter = nodemailer.createTransport({
      host: 'smtp.ethereal.email',
      port: 587,
      auth: {
          user: 'addie24@ethereal.email',
          pass: 'VesV4GmurBxaaEkY3x'
      }
  });

    const mailOptions = {
      from: 'addie24@ethereal.email',
      to: 'kadosvaibhav@gmail.com', // Replace with the recipient's email address
      subject: 'CouponsBook Report',
      text: 'Attached is the CouponsBook report.',
      attachments: [
        {
          filename: 'CouponsBookData.xlsx',
          content: await workbook.xlsx.writeBuffer(),
        },
      ],
    };

    // Send the email
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error('Error sending email:', error);
        res.status(500).json({ error: 'Email could not be sent.' });
      } else {
        console.log('Email sent:', info.response);
        res.json(entries);
      }
    });
  } catch (error) {
    console.error('Error generating report and sending email:', error);
    res.status(500).json({ error: 'Report generation and email sending failed.' });
  }
}

);


hrrouter.post('/hr/save-user', async (req, res) => {
    try {
      const { psNumber, date } = req.body;
  
      const user = new CouponsBook({
        psNumber,
        date,
      });
  
      await user.save(); // Save the new feedback
      res.status(201).json("User added successfully");
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: err.message });
    }
  });

  module.exports = hrrouter;