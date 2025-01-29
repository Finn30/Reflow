const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Konfigurasi transporter untuk mengirim email
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "f1d022102@student.unram.ac.id", // Ganti dengan email pengirim
    pass: "Yusril0311_", // Ganti dengan password email (atau gunakan App Password)
  },
});

// Fungsi untuk mengirim email saat email diverifikasi
exports.sendWelcomeEmail = functions.auth.user().onCreate(async (user) => {
  if (user.emailVerified) {
    const mailOptions = {
      from: "your-email@gmail.com",
      to: user.email,
      subject: "Selamat, Email Anda telah diverifikasi!",
      text: `Halo ${user.email},\n\nAkun Anda telah berhasil diverifikasi.\n\nTerima kasih telah bergabung!`,
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log("Email verifikasi dikirim ke:", user.email);
    } catch (error) {
      console.error("Gagal mengirim email:", error);
    }
  }
});
