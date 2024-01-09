const express = require('express');
const snacksReportRouter = express.Router();
const ExcelJS = require('exceljs');
const nodemailer = require('nodemailer');
const { Snacks } = require('./models/snacks'); // Update the path accordingly

snacksReportRouter.post('/snacks/generate-report-and-send-email', async (req, res) => {
  try {
    const { date1, date2, email } = req.body;

    // Fetch entries within the date range
    const entries = await Snacks.find({
      date: { $gte: date1, $lte: date2 },
    });

    // Create an Excel file
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Snacks Data');

    // Add headers to the worksheet
    worksheet.addRow(['Date', 'Name', 'PsNumber', 'ScannedBy']);

    // Add data to the worksheet
    for (const entry of entries) {
      for (const scannedUser of entry.scannedUsers) {
        worksheet.addRow([
          entry.date,
          scannedUser.name,
          scannedUser.psNumber,
          scannedUser.scannedBy,
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
      subject: 'Snacks Report',
      text: 'Attached is the Snacks report.',
      attachments: [
        {
          filename: 'SnacksData.xlsx',
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

module.exports = snacksReportRouter;
