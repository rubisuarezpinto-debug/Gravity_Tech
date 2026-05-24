const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

// ── Verificar conexión al arrancar ─────────────────────────────────────────
transporter.verify((error) => {
  if (error) {
    console.error('❌ Error al conectar con el servidor de correo:', error.message);
  } else {
    console.log('✅ Servidor de correo listo');
  }
});

// ── Enviar código de verificación de registro ──────────────────────────────
const sendVerificationCode = async (email, nombre, codigo) => {
  await transporter.sendMail({
    from: `"Gravity Tech" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: '🔐 Verifica tu cuenta — Gravity Tech',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 480px; margin: auto; background: #0D0D2B; color: #ffffff; border-radius: 12px; padding: 32px;">
        <h2 style="color: #5B5BF6; text-align: center;">Gravity Tech</h2>
        <p>Hola <strong>${nombre}</strong>,</p>
        <p>Gracias por registrarte. Usa el siguiente código para verificar tu cuenta:</p>
        <div style="text-align: center; margin: 32px 0;">
          <span style="font-size: 36px; font-weight: bold; letter-spacing: 12px; color: #5B5BF6;">
            ${codigo}
          </span>
        </div>
        <p style="color: #9090B0; font-size: 13px;">Este código expira en <strong>15 minutos</strong>.</p>
        <p style="color: #9090B0; font-size: 13px;">Si no creaste una cuenta, ignora este correo.</p>
      </div>
    `,
  });
};

// ── Enviar código de recuperación de contraseña ────────────────────────────
const sendResetCode = async (email, nombre, codigo) => {
  await transporter.sendMail({
    from: `"Gravity Tech" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: '🔑 Recupera tu contraseña — Gravity Tech',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 480px; margin: auto; background: #0D0D2B; color: #ffffff; border-radius: 12px; padding: 32px;">
        <h2 style="color: #5B5BF6; text-align: center;">Gravity Tech</h2>
        <p>Hola <strong>${nombre}</strong>,</p>
        <p>Recibimos una solicitud para restablecer tu contraseña. Usa este código:</p>
        <div style="text-align: center; margin: 32px 0;">
          <span style="font-size: 36px; font-weight: bold; letter-spacing: 12px; color: #E040FB;">
            ${codigo}
          </span>
        </div>
        <p style="color: #9090B0; font-size: 13px;">Este código expira en <strong>15 minutos</strong>.</p>
        <p style="color: #9090B0; font-size: 13px;">Si no solicitaste esto, ignora este correo.</p>
      </div>
    `,
  });
};

module.exports = { sendVerificationCode, sendResetCode };