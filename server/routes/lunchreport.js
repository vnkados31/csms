const express = require('express');
const lunchReportRouter = express.Router();
const ExcelJS = require('exceljs');
const nodemailer = require('nodemailer');
const { Qrcode } = require('./models/qrcode'); // Update the path accordingly

lunchReportRouter.post('/lunch/generate-report-and-send-email', async (req, res) => {
  try {
    const { date1, date2, email } = req.body;

    // Fetch entries within the date range
    const entries = await Qrcode.find({
      date: { $gte: date1, $lte: date2 },
    });

    // Create an Excel file
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Qrcode Data');

    // Add headers to the worksheet
    worksheet.addRow(['Date', 'Name', 'Email', 'PsNumber', 'VegUsers', 'NonVegUsers', 'DietUsers', 'TotalUsers', 'ScannedBy', 'CouponsLeft']);

    // Add data to the worksheet
    for (const entry of entries) {
      for (const scannedUser of entry.scannedUsers) {
        worksheet.addRow([
          entry.date,
          scannedUser.name,
          scannedUser.email,
          scannedUser.psNumber,
          scannedUser.vegUsers,
          scannedUser.nonVegUsers,
          scannedUser.dietUsers,
          scannedUser.totalUsers,
          scannedUser.scannedBy,
          scannedUser.couponsLeft
        ]);
      }
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
      to: email, // Use the recipient's email address from the request body
      subject: 'Qrcode Report',
      text: 'Attached is the Qrcode report.',
      attachments: [
        {
          filename: 'QrcodeData.xlsx',
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
});

module.exports = lunchReportRouter;
